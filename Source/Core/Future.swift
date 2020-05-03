//
//  Future.swift
//  PromisedFuture
//
//  Created by Alaeddine Messaoudi on 26/05/2018.
//

import Foundation

/**
    A `Future` helps us to encapsulate a deferred computation, it's a way to represent a value that will exist (or will fail with an error) at some
    point in the future. It's a placeholder for values that are currently unknown due to waiting for the network, long and complex computations,
    or anything else that does not immediately resolve.

    A `Future` represents a placeholder for a value not necessarily known when the `Future` is created. This lets asynchronous methods return values
    like synchronous methods, instead of the final value, the asynchronous method returns a promise of having a value at some point in the
    future. `Future` help us to treat values that incur a delay to be retrieved as if they were regular values.

    The outcome of the `Future` will be represented as an instance of the `Result` enum. The `Future` can be executed using `execute` method

    `Future` is easily composable and chainable using `andThen`, `map`
*/

public struct Future<Value> {

    //MARK: - Typealias
    public typealias Completion = (Result<Value>) -> Void
    public typealias AsyncOperation = (@escaping Completion) -> Void
    public typealias FailureCompletion = (Error) -> Void
    public typealias SuccessCompletion = (Value) -> Void

    //MARK: - Properties
    private let operation: AsyncOperation

    //MARK: - Initialization
    /**
     Initialize a new `Future` with the provided `Result`.

     Example usage:

     ````
     let future = Future(result: Result.success(12))
     ````

     - Parameters:
        - result: The result of the `Future`. It can be a `Result` of success with a value or failure with an `Error`.

     - Returns: A new `Future`.
     */
    public init(result: Result<Value>) {
        self.init(operation: { completion in
            completion(result)
        })
    }

    /**
     Initialize a new `Future` with the provided value.

     Example usage:

     ````
     let future = Future(value: 14)
     ````

     - Parameters:
        - value: The value of the `Future`.

     - Returns: A new `Future`.
     */
    public init(value: Value) {
        self.init(result: .success(value))
    }

    /**
     Initialize a new `Future` with the provided `Error`.

     Example usage:

     ````
     let f: Future<Int>= Future(error: NSError(domain: "E",
                                                 code: 400,
                                             userInfo: nil))
     ````
     - Parameters:
        - error: The error of the `Future`.

     - Returns: A new `Future`.
     */
    public init(error: Error) {
        self.init(result: .failure(error))
    }

    /**
     Initialize a new `Future` with the provided operation.
     Example usage:

     ````
     let future = Future(operation: { completion in
     // Your operation to retrieve the value here
     // Then in case of success you call the completion
     // with the Result passing the value
     completion(.success("Hello"))
     // or in case of error call the completion
     // with the Result passing the error like :
     //completion(.failure(NSError.init(domain: "domain",
     //                                   code: 400,
     //                               userInfo: nil)))
     })
     ````

     - Parameters:
        - operation: the operation that should be performed by the Future. This is usually the asynchronous operation.
        - completion: the completion block of the operation. It has the `Result` of the operation as parameter.

     - Returns: A new `Future`.
     */
    public init(operation: @escaping (_ completion:@escaping Completion) -> Void) {
        self.operation = operation
    }

    //MARK: - Actions
    /**
     Execute the operation.
     Example usage:

     ````
     let future = Future(value: 14)
     future.execute(completion: { result in
        switch result {
        case .success(let value):
            print(value) // it will print 14
        case .failure(let error):
            print(error)
        }
     })
     ````

     - Parameters:
        - completion: the completion block of the operation. It has the `Result` of the operation as parameter.
     */
    public func execute(completion: @escaping Completion) {
        self.operation() { result in
            completion(result)
        }
    }

    /**
     Execute the operation. Example usage

     ````
     let future = Future(value: 14)
     future.execute(onSuccess: { value in
        print(value) // it will print 14
     }, onFailure: { error in
        print(error)
     })
     ````

     - Parameters:
        - onSuccess: the success completion block of the operation. It has the value of the operation as parameter.
        - onFailure: the failure completion block of the operation. It has the error of the operation as parameter.
     */
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
