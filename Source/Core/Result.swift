//
//  Result.swift
//  PromisedFuture
//
//  Created by Alaeddine Messaoudi on 25/05/2018.
//

import Foundation

/// An enum representing either a failure with an error, or a success with a result value.
public enum Result<T> {
    case success(T)
    case failure(Error)
}
