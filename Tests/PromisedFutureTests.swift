//
//  PromisedFutureTests.swift
//  PromisedFutureTests
//
//  Created by Alaeddine Messaoudi on 24/05/2018.
//

import XCTest
@testable import PromisedFuture

class PromisedFutureTests: XCTestCase {

    let futureWithValue = Future(value: 1)
    let futureWithError = Future<Int>(error: NSError(domain: "futureWithError", code: 500, userInfo: nil))
    let futureWithResultValue = Future(result: Result.success(1))
    let futureWithResultError = Future<Int>(result: Result.failure(NSError(domain: "futureWithError", code: 500, userInfo: nil)))
    let futureWithSuccessOperation = Future { completion in
        DispatchQueue.global().asyncAfter(deadline: .now() + 1 , execute: {
            completion(.success(1))
        })
    }
    let futureWithFailureOperation = Future<Int> { completion in
        DispatchQueue.global().asyncAfter(deadline: .now() + 1 , execute: {
            completion(.failure(NSError(domain: "FutureWithFailureOperation", code: 501, userInfo: nil)))
        })
    }

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFutureWithValue() {
        let expectation = self.expectation(description: "future has correct value")
        var expectedValue = 0

        futureWithValue.execute(onSuccess: { value in
            expectedValue = value
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(expectedValue, 1, "future should have a correct value")
    }

    func testFutureWithError() {
        let expectation = self.expectation(description: "future should fail")
        var expectedError: Error? = nil

        futureWithError.execute(onSuccess: {_ in}, onFailure: { error in
            expectedError = error
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(expectedError, "future should fail with an error")
    }

    func testFutureWithResultValue() {
        let expectation = self.expectation(description: "future has correct value")
        var expectedValue = 0

        futureWithResultValue.execute(onSuccess: { value in
            expectedValue = value
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(expectedValue, 1, "future should have a correct value")
    }

    func testFutureWithResultError() {
        let expectation = self.expectation(description: "future should fail")
        var expectedError: Error? = nil

        futureWithResultError.execute(onSuccess: {_ in}, onFailure: { error in
            expectedError = error
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(expectedError, "future should fail with an error")
    }

    func testFutureWithSuccessOperation() {
        let expectation = self.expectation(description: "future has correct value")
        var expectedValue = 0

        futureWithSuccessOperation.execute(onSuccess: { value in
            expectedValue = value
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(expectedValue, 1, "future should have a correct value")
    }

    func testFutureWithFailureOperation() {
        let expectation = self.expectation(description: "future should fail")
        var expectedError: Error? = nil

        futureWithFailureOperation.execute(onSuccess: {_ in}, onFailure: { error in
            expectedError = error
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(expectedError, "future should fail with an error")
    }
}
