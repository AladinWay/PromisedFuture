//
//  ViewController.swift
//  iOS Example
//
//  Created by Alaeddine Messaoudi on 14/07/2018.
//  Copyright © 2018 PromisedFuture. All rights reserved.
//

import UIKit
import PromisedFuture

class ViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    private let userID = 12

    override func viewDidLoad() {
        super.viewDidLoad()

        let avatarFuture = loadAvatar(of: userID)

        avatarFuture.execute(onSuccess: { image in
            self.avatarImageView.image = image
        }, onFailure: { error in
            print(error.localizedDescription)
        })
    }

    func downloadFile(from URL: URL) -> Future<Data> {
        return Future() { completion in
            DispatchQueue.global(qos: .background).async {
                guard let data = try? Data(contentsOf: URL) else {
                    completion(.failure(UserInfoErrorDomain.networkRequestFailure))
                    return
                }
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            }
        }
    }

    func requestUserInfo(of userID: Int) -> Future<User> {
        if let url = URL(string: "https://picsum.photos/200/200/?random/?\(userID)") {
            return Future(value: User(avatarURL: url))
        } else {
            return Future(error: UserInfoErrorDomain.userInfoFailure)
        }
    }

    func downloadImage(URL: URL) -> Future<UIImage> {
        return downloadFile(from: URL).map { UIImage(data: $0)! }
    }

    func loadAvatar(of userID: Int) -> Future<UIImage> {
        return requestUserInfo(of: userID)
                .map { $0.avatarURL }
                .andThen(downloadImage)
    }
}

enum UserInfoErrorDomain: Error {
    case userInfoFailure
    case userRequestFailure
    case networkRequestFailure
}

struct User {
    let avatarURL: URL
}
