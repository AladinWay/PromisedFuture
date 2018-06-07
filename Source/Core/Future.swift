//
//  Future.swift
//  PromisedFuture
//
//  Created by Alaeddine Messaoudi on 26/05/2018.
//

import Foundation

public struct Future<Value> {

    public typealias Completion = (Result<Value>) -> Void
    public typealias AsyncOperation = (@escaping Completion) -> Void
    public typealias FailureCompletion = (Error) -> Void
    public typealias SuccessCompletion = (Value) -> Void

    private let operation: AsyncOperation

    public init(result: Result<Value>) {
        self.init(operation: { completion in
            completion(result)
        })
    }

    public init(value: Value) {
        self.init(result: .success(value))
    }

    public init(error: Error) {
        self.init(result: .failure(error))
    }

    public init(operation: @escaping (@escaping Completion) -> Void) {
        self.operation = operation
    }

    public func execute(completion: @escaping Completion) {
        self.operation() { result in
            completion(result)
        }
    }

    public func execute(onSuccess: @escaping SuccessCompletion, onFailure: FailureCompletion? = nil) {
        self.operation() { result in
            switch result {
            case .success(let value):
                onSuccess(value)
            case .failure(let error):
                onFailure?(error)
            }
        }
    }
}
