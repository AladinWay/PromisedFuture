//
//  Future+Functional.swift
//  PromisedFuture
//
//  Created by Alaeddine Messaoudi on 29/05/2018.
//

import Foundation

extension Future {
    public func andThen<U>(_ f: @escaping (Value) -> Future<U>) -> Future<U> {
        return Future<U>(operation: { completion in
            self.execute(onSuccess: { value in
                f(value).execute(completion: completion)
            }, onFailure: { error in
                completion(.failure(error))
            })
        })
    }

    public func map<T>(_ f: @escaping (Value) -> T) -> Future<T> {
        return Future<T>(operation: { completion in
            self.execute(onSuccess: { value in
                completion(.success(f(value)))
            }, onFailure: { error in
                completion(.failure(error))
            })
        })
    }

    public func flatten<Value>(_ future: Future<Future<Value>>) -> Future<Value> {
        return Future<Value>(operation: { completion in
            future.execute(onSuccess: { nestedFuture in
                nestedFuture.execute(completion: completion)
            }, onFailure: { error in
                completion(.failure(error))
            })
        })
    }

    public func flatMap<T>(f: @escaping (Value) -> Future<T>) -> Future<T> {
        return flatten(map(f))
    }

    public func concat<T>(_ that: Future<T>) -> Future<(Value, T)> {
        return self.flatMap { thisVal -> Future<(Value, T)> in
            return that.map { thatVal in
                return (thisVal, thatVal)
            }
        }
    }
}
