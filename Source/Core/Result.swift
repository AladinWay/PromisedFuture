//
//  Result.swift
//  PromisedFuture
//
//  Created by Alaeddine Messaoudi on 25/05/2018.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(Error)
}
