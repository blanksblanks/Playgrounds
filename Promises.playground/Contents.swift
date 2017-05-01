struct Callback<Value> {
    let onFulfilled: (Value) -> ()
    let onRejected: (Error) -> ()
}

enum State<Value> {
    case pending
    case fulfilled(value: Value)
    case rejected(error: Error)
}

final class Promise<Value> {
    
    fileprivate var state: State<Value>
    private var callbacks: [Callback<Value>] = []
    
    // Initialize with a fulfilled value
    init(value: Value) {
        self.state = .fulfilled(value: value)
    }
    
    // Initialize with a rejected error
    init(error: Error) {
        self.state = .rejected(error: error)
    }
    
    /// Initialize with a set of functions which resolve the promise to a fulfilled or rejected state
    /// @escaping note: If a closure is passed as an argument to a function and it is invoked after the function returns, the closure is escaping.
    ///
    /// - Parameter resolvers: a throwing function that takes two functions
    /// It is called immediately in tx`he init and will resolve with either fulfill or reject
    /// - Parameter fulfill: function that fulfills the promise with the passed in value
    /// - Parameter reject: function that rejects the promise with the passed in error
    init(resolvers: (_ fulfill: @escaping (Value) -> Void, _ reject: @escaping (Error) -> Void) throws -> Void) {
        self.state = .pending
        let fulfill: (Value) -> () = { (value: Value) in
            self.updateState(state: .fulfilled(value: value))
        }
        let reject: (Error) -> () = { (error: Error) in
            self.updateState(state: .rejected(error: error))
        }
        do {
            try resolvers(fulfill, reject)
        } catch {
            self.updateState(state: .rejected(error: error))
        }
    }
    
    /**
     Example:
     URLSession.GET(url1).then { data in
     return CLLocationManager.promise()
     }.then { location in
     //…
     }
     **/
    
    /// After this promise fulfills, then do something else
    /// In functional programming terms this is a flatMap
    /// You take the value out of the promise box, map it and put it back into a promise box
    /// This variant of `then` allows chaining promises, the promise returned by onFulfilled
    /// is resolved before the promise returned by this closure resolves.
    ///
    /// - Parameter onFulfilled: a function that takes a Value and returns a promise with a NewValue
    /// It is called when this promise resolves
    /// - Returns: a promise with a NewValue
    /// It resolves when the promise returned from onFulfilled resolves
    public func then<NewValue>(_ onFulfilled: @escaping (Value) throws -> Promise<NewValue>) -> Promise<NewValue> {
        return Promise<NewValue>(resolvers: {
            (fulfill: @escaping (NewValue) -> Void, reject: @escaping (Error) -> ()) in
            let doFulfill: (Value) -> Void = { (value: Value) in
                do {
                    try onFulfilled(value)
                        .then(fulfill, reject)
                } catch {
                    reject(error)
                }
            }
            self.addCallbacks(onFulfilled: doFulfill, onRejected: reject)
        })
    }

    /**
     Example:
     NSURLSession.GET(url).then { data -> Int in
     //…
     return data.length
     }.then { length in
     //…
     }
     **/
    
    /// After this promise fulfills, then do something else
    /// In functional programming terms this is a map
    /// Note that you can implement map using flatMap (the above `then` implementation)
    ///
    /// - Parameter onFulfilled: a function that takes a Value and returns a NewValue.
    /// It gets called when this Promise is fulfilled
    /// - Returns: a promise with a NewValue
    /// It gets resolved with the NewValue returned from onFulfilled
    
    public func then<NewValue>(_ onFulfilled: @escaping (Value) throws -> NewValue) -> Promise<NewValue> {
        return then({ (value: Value) -> Promise<NewValue> in
            do {
                let newValue: NewValue = try onFulfilled(value)
                return Promise<NewValue>(value: newValue)
            } catch {
                return Promise<NewValue>(error: error)
            }
        })
    }
    
    /// After this promise fulfills, do something else
    /// If the promise is rejected, do something different than when it's fulfilled
    ///
    /// - Parameter onFulfilled: a function that takes a Value and returns nothing
    /// It gets called when this Promise is fulfilled
    /// - Parameter onRejected: a function that takes an Error and returns nothing
    /// It gets called when this Promise is rejected
    /// - Returns: a promise with a value
    public func then(_ onFulfilled: @escaping (Value) -> (), _ onRejected: @escaping (Error) -> () = { _ in }) -> Promise<Value> {
        return Promise(resolvers: { fulfill, reject in
            let doFulfill: (Value) -> Void = { (value: Value) in
                fulfill(value)
                onFulfilled(value)
            }
            let doReject: (Error) -> Void = { (error: Error) in
                reject(error)
                onRejected(error)
            }
            self.addCallbacks(onFulfilled: doFulfill, onRejected: doReject)
        })
    }
    
    /// If the promise is rejected, calls the provided closure
    /// Rejecting a promise cascades, this rejects all subsequent promises
    /// That's why you typically put `catch` at the end of the chain
    ///
    /// - Parameter onRejected: a function that takes an error and does nothing
    /// - Returns: `self`
    func `catch`(onRejected: @escaping (Error) -> Void) -> Promise<Value> {
        return self
            .then({ _ in }, onRejected)
    }
    
    private func updateState(state: State<Value>) {
        guard self.isPending else { return }
        self.state = state
        fireCallbacksIfCompleted()
    }
    
    private func addCallbacks(onFulfilled: @escaping (Value) -> Void, onRejected: @escaping (Error) -> Void) {
        let callback = Callback(onFulfilled: onFulfilled, onRejected: onRejected)
        self.callbacks.append(callback)
        fireCallbacksIfCompleted()
    }
    
    private func fireCallbacksIfCompleted() {
        guard !self.state.isPending else { return }
        self.callbacks.forEach { callback in
            switch self.state {
            case let .fulfilled(value):
                callback.onFulfilled(value)
            case let .rejected(error):
                callback.onRejected(error)
            default:
                break
            }
        }
        self.callbacks.removeAll()
    }
    
    
}


/// Computed Properties
extension Promise {
    
    var isPending: Bool {
        return !self.isFulfilled && !self.isRejected
    }
    
    var isFulfilled: Bool {
        return self.value != nil
    }
    
    var isRejected: Bool {
        return self.error != nil
    }
    
    var value: Value? {
        return self.state.value
    }
    
    var error: Error? {
        return self.state.error
    }
}

extension State {
    var isPending: Bool {
        if case .pending = self {
            return true
        } else {
            return false
        }
    }
    
    var isFulfilled: Bool {
        if case .fulfilled = self {
            return true
        } else {
            return false
        }
    }
    
    var isRejected: Bool {
        if case .rejected = self {
            return true
        } else {
            return false
        }
    }
    
    var value: Value? {
        if case let .fulfilled(value) = self {
            return value
        }
        return nil
    }
    
    var error: Error? {
        if case let .rejected(error) = self {
            return error
        }
        return nil
    }
    
}

/// Errors
enum AwfulError: Error {
    case bad
    case worse
    case terrible
}


///
/// Simple test example
///

var triggerError = false

func passItOn(_ value: String) -> Promise<String> {
    if (triggerError) {
        return Promise { fulfill, reject in reject(AwfulError.bad) }
    }
    return Promise { fulfill, reject in
        print(value)
        fulfill(value)
    }
}

func disemvowel(_ s: String) -> String {
    let vowels = Set("aeiouAEIOU".characters)
    return String(s.characters.filter { !vowels.contains($0) })
}

func runRandomExample() {
    passItOn("will it rain today?").then { (value: String) -> Promise<String> in
        return passItOn(value + "!")
        }.then { (value: String) -> Promise<String> in
            let uppercased = value.uppercased()
            return passItOn(uppercased)
        }.then { (value: String) -> Promise<String> in
            let disemvoweled = disemvowel(value)
            return passItOn(disemvoweled)
        }.catch { error in
            print("boo! a wild error has appeared")
    }
    print("\n☔️☔️☔️\n")

}

runRandomExample()


/// Map

let promise = Promise(value: "someString").then { string in
    return string.characters.count
}.then { count in
    return count*2
}.then { doubled in
    return Promise(value: doubled)
}

print(promise.state)


/// FlatMap

let flatPromise = Promise<String> { fulfill, reject in
    fulfill("hello")
}.then { value in
    return Promise<Int> { fulfill, reject in
        fulfill(value.characters.count)
    }
}.then { value in
    return Promise(value: value)
}

print(flatPromise.state)

print("\n🌏🌎🌍\n")


///
/// Mock example for async downloading flow
///

/// Checks the manifest version on the backend
///
/// - returns: A promise with the json response when the check is done
func checkVersion() -> Promise<[String: Any]> {
    print("Checking version manifest")
    return Promise(value: ["version" : "1337"])
}

/// Parses the version
///
/// - parameter json: the json containing the version
/// - returns: A promise with the version, throws an error if version is not found
func parseVersion(_ json: [String: Any]) -> Promise<String> {
    print("Parsing the json")
    guard let version = json["version"] as? String else {
        return Promise(error: AwfulError.bad)
    }
    return Promise(value: version)
}

/// Checks whether player needs to be updated
///
/// - parameter remoteVersion: the latest version on the backend
/// - returns: A promise with the version if it differs from the version stored on user defaults, throws an error if the versions are the same
func shouldUpdatePlayer(to remoteVersion: String) -> Promise<String> {
    print("Checking whether player needs an update")
    let localVersion = userDefaultVersion ?? ""
    if (localVersion != remoteVersion) {
        return Promise(value: remoteVersion)
    }
    return Promise(error: AwfulError.worse)
}

/// Downloads the player
///
/// - parameter version: the version to download
/// - returns: A promise with the version if it successfully downloads, throws error if download fails
func downloadPlayer(_ version: String) -> Promise<String> {
    print("Downloading version: \(version)")
    let success = true
    if (success) {
        return Promise(value: version)
    } else {
        return Promise(error: AwfulError.terrible)
    }
}

/// Send event to analytics
///
/// - parameter eventDescription: the eventDescription to send to analytics
func logEvent(_ eventDescription: String) {
    print("Logging event: \(eventDescription)")
}

var userDefaultVersion: String? = "n00b"
func updatePlayer() {
    checkVersion().then { json -> Promise<String> in
        return parseVersion(json)
    }.then { version -> Promise<String> in
        return shouldUpdatePlayer(to: version)
    }.then { version -> Promise<String> in
        return downloadPlayer(version)
    }.then { version -> Void in // ()
        logEvent("successful update from version \(userDefaultVersion ?? "") to version \(version)")
        userDefaultVersion = version
    }.catch { error in
        logEvent("failed to update due to \(error)")
    }
}

updatePlayer()



// States:
// (image, no error)
// (no image, error)
// (image, error)
// (no image, no error)
//
//struct User { let avatarURL: URL }
//func requestUserInfo(userID: String, completion: (User?, NSError?) -> ())
//func downloadImage(URL: URL, completion: (UIImage?, NSError?) -> ())
//
//func loadAvatar(userID: String, completion: (UIImage?, NSError?) -> ()) {
//    requestUserInfo(userID) { user, error in
//        if let user = user {
//            downloadImage(user.avatarURL) { avatar, error in
//                if let avatar = avatar { completion(avatar, nil) }
//                else { completion(nil, error!) }
//            }
//        } else { completion(nil, error!) }
//    }
//}
//


