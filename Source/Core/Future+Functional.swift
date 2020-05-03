//
//  Future+Functional.swift
//  PromisedFuture
//
//  Created by Alaeddine Messaoudi on 29/05/2018.
//

import Foundation

extension Future {
    /**
     Chain two depending futures providing a function that gets the value of this future as parameter
     and then creates new one

     ````
     struct User {
        id: Int
     }

     // Let's assume we need to perfom two network operations
     // The first one to get the user id
     // And the second one to get the user information
     // we can use `andThen` to chain them

     let userIdFuture = Future(value: 14)

     func userFuture(by userId: Int) -> Future<User> {
        return Future(value: User(id: userId))
     }

     userIdFuture.andThen(userFuture).execute { user in
        print(user)
     }

     ````

     - Parameters:
        - f: function that will generate a new `Future` by passing the value of this Future
        - value: the value of this Future

     - Returns: New chained Future

     */
    public func andThen<U>(_ f: @escaping (_ value: Value) -> Future<U, Failure>) -> Future<U, Failure> {
        return Future<U, Failure>(operation: { completion in
            self.execute(onSuccess: { value in
                f(value).execute(completion: completion)
            }, onFailure: { error in
                completion(.failure(error))
            })
        })
    }

    /**
     Creates a new Future by applying a function to the successful result of this future.
     If this future is completed with an error then the new future will also contain this error

     ````
     let stringFuture = Future(value: "http://www.google.com")
     let urlFuture = stringFuture.map({URL(string: $0)})
     ````

     - Parameters:
        - f: function that will generate a new `Future` by passing the value of this Future
        - value: the value of this Future

     - Returns: New Future
     */

    public func map<T>(_ f: @escaping (_ value: Value) -> T) -> Future<T, Failure> {
        return Future<T, Failure>(operation: { completion in
            self.execute(onSuccess: { value in
                completion(.success(f(value)))
            }, onFailure: { error in
                completion(.failure(error))
            })
        })
    }
}
