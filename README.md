
 <p align="center">
	<img src="http://itechnodev.com/img/logo.png" align="center" alt="logo">
</p>
<br \>


[![CI Status](http://img.shields.io/travis/AladinWay/PromisedFuture.svg?style=flat)](https://travis-ci.org/AladinWay/PromisedFuture)
[![Version](https://img.shields.io/cocoapods/v/PromisedFuture.svg?style=flat)](http://cocoapods.org/pods/PromisedFuture)
[![License](https://img.shields.io/cocoapods/l/PromisedFuture.svg?style=flat)](http://cocoapods.org/pods/PromisedFuture)
[![Platform](https://img.shields.io/cocoapods/p/PromisedFuture.svg?style=flat)](http://cocoapods.org/pods/PromisedFuture)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

   
## PromisedFuture
**PromisedFuture** is a lightweight implementation of Futures/Promises. 
`PromisedFuture` helps to write readable and comprehensible asynchronous code. 

Usually the callback mechanism is used when working with asynchronous tasks. It should get the job done for some use cases, but usually we need to perform more that one asynchronous operation, so we have to nest the second operation inside the completion block of the first one, but when we have nested callbacks it starts to get messy, the code is not friendly in term of maintainability, readability and control, and this leads to the Pyramid of doom, Callback hell and error handling issues.

**PromisedFuture** is here to rescue, the code will go from this:

```
APIClient.login(email: "test@gmail.com", password: "myPassword", completion: { result in
    switch result {
    case .success(let user):
        APIClient.userArticles(userID: user.id, completion: { result in
            switch result {
            case .success(let articles):
                APIClient.getArticle(id: articles.last!.id, completion: { result in
                    switch result {
                    case .success(let article):
                        print(article)
                    case .failure(let error):
                        print(error)
                    }
                })
            case .failure(let error):
                print(error)
            }
        })
    case .failure(let error):
        print(error)
    }
})

```

to this: 


```
APIClient.login(email: "test@gmail.com", password: "myPassword")
         .map({$0.id})
         .andThen(APIClient.userArticles)
         .map({$0.last!.id})
         .andThen(APIClient.getArticle)
         .execute(onSuccess: { article in
            print(article)
         }, onFailure: {error in
            print(error)
         })
```

## Features

- [x] Chainable asynchronous operations.
- [x] Lightweight and simple to use (just ≈ 40 lines of code).
- [x] Fully unit tested.
- [x] Fully Documented.


## Requirements

- iOS 10.0+ / macOS 10.12+ / tvOS 10.0+ / watchOS 3.0+
- Xcode 9.0+
- Swift 4.0+

## Example

To run the example project, clone the repo, then open the workspace `PromisedFuture.xcworkspace` run using `iOS Example` scheme.

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate PromisedFuture into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
use_frameworks!

pod 'PromisedFuture'
```

Then, run the following command:

```bash
$ pod install
```


### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate PromisedFuture into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "aladinway/PromisedFuture"
```

Run `carthage update` to build the framework and on your application targets’ “General” settings tab, in the “Embedded Binaries” section, drag and drop the built `PromisedFuture.framework` from the Carthage/Build folder on disk.

## Usage

**Create a `Future`**:

to create a `Future` using an operation (network call for example) we use:

`init(operation: @escaping (_ completion:@escaping Completion) -> Void)`

  - Parameters:
      - `operation`: the operation that should be performed by the Future. This is usually the asynchronous operation.
      - `completion`: the completion block of the operation. It has the `Result` of the operation as parameter.
  - Example usage:

```swift
let future = Future(operation: { completion in
// Your operation here to retrieve the value
Alamofire.request("https://httpbin.org/get")
    .responseData { response in
        switch response.result {
        case .success(let value):
		// Then in case of success you call the completion
		// with the Result passing the value
		completion(.success(data))
        case .failure(let error):
		// or in case of error call the completion
		// with the Result passing the error like :
		//completion(.failure(error))
        }
    }
})
```

You can also create a `Future` by `Result`, `Value` or `Error`.

Initialize a new `Future` with the provided `Result`:

`init(result: Result<Value>)` 

  - Parameters:
      - `result`: The result of the `Future`. It can be a `Result` of success with a value or failure with an `Error`.
 
  - Example usage:

```swift
let future = Future(result: Result.success(12))
```
 Initialize a new `Future` with the provided value:
  
`init(value: Value)` 

  - Parameters:
      - `value`: The value of the `Future`.
 
  - Example usage:

```swift
let future = Future(value: "Hello")
```
 
Initialize a new `Future` with the provided `Error`:
  
`init(value: Value)` 

  - Parameters:
      - `value`: The value of the `Future`.
 
  - Example usage:

```swift
let f: Future<Int>= Future(error: NSError(domain: "E", code: 4, userInfo: nil))
```
 
**Execute a `Future`**:
 
 To execute the operation of the Future we can use one these methods:
 
 - `func execute(completion: @escaping Completion)`

   - Parameters:
      - `completion`: the completion block of the operation. It has the `Result` of the operation as parameter.
 
  - Example usage:

	```swift
     let future = Future(value: 14)
     future.execute(completion: { result in
        switch result {
        case .success(let value):
            print(value) // it will print 14
        case .failure(let error):
            print(error)
        }
     })
	```
  
 - `func execute(completion: @escaping Completion)`

   - Parameters:
       - `onSuccess`: the success completion block of the operation. It has the value of the operation as parameter.
       - `onFailure`: the failure completion block of the operation. It has the error of the operation as parameter.
 
  - Example usage:

	```swift
     let future = Future(value: 14)
     future.execute(onSuccess: { value in
        print(value) // it will print 14
     }, onFailure: { error in
        print(error)
     })
	```
 
**Chaining multiple `Future`**:
 
 The powerful part of the Future is the ability to chain asynchronous operations.  We can use `andThen` method to chain two depending futures.
 
 - `func andThen<U>(_ f: @escaping (_ value: Value) -> Future<U>) -> Future<U>`

   - Parameters:
       - `f`: function that will generate a new `Future` by passing the value of this Future.
 
  - Example usage:

	```swift
     struct User {
        id: Int
     }

     // Let's assume we need to perform two network operations
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
	```
	
	We can also map the result of the `Future` using `map` function:
	
	 - `func map<T>(_ f: @escaping (_ value: Value) -> T) -> Future<T>`

   - Parameters:
       - `f`: function that will generate a new `Future` by passing the value of this Future
 
  - Example usage:

	```swift
     let stringFuture = Future(value: "http://www.google.com")
     let urlFuture = stringFuture.map({URL(string: $0)})
	```
 
## Reading

I highly recommend reading my article below, If you want to learn more about `Futures` and how we can use **PromisedFuture** in the networking layer with `Alamofire` : 

[Write a Networking Layer in Swift 4 using Alamofire 5 and Codable Part 3: Using Futures/Promises](https://medium.com/@AladinWay/write-a-networking-layer-in-swift-4-using-alamofire-5-and-codable-part-3-using-futures-promises-cf3977fc8a5)

 
## Author

Alaeddine Messaoudi <itechnodev@gmail.com>

## License

PromisedFuture is available under the MIT license. See the LICENSE file for more info.