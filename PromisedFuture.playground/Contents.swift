
import PromisedFuture

func doSomething() -> Future<String> {
    return Future(operation: { completion in
       completion(.success("Hello"))
       //completion(.failure(NSError.init(domain: "domain", code: 400, userInfo: nil)))
    })
}

doSomething().execute(onSuccess: { value in
    print(value)
}, onFailure: { error in
    print(error)
})
