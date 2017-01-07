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
    
    // Initialize with a set of functions which resolve the promise to a fulfilled or rejected state
    init(resolvers: (_ fulfill: @escaping (Value) -> Void, _ reject: @escaping (Error) -> Void) throws -> Void) {
        /// Implement me
    }
    
    // After this promise fulfills, then do something else
    // In functional programming terms this is a flatMap
    // You take a function that takes a value and returns a promise with a new value.
    // You take the value out of the promise box, map it and put it back into a promise box
    public func then<NewValue>(_ onFulfilled: @escaping (Value) throws -> Promise<NewValue>) -> Promise<NewValue> {
        /// Implement me
    }
    
    // After this promise fulfills, then do something else
    // In functional programming terms this is a map
    // You take a function that takes a value and returns a newValue and wrap the newValue in a promise
    // Note that you can implement map using flatMap
    public func then<NewValue>(_ onFulfilled: @escaping (Value) throws -> NewValue) -> Promise<NewValue> {
        /// Implement me
    }
    
    public func then(_ onFulfilled: @escaping (Value) -> (), _ onRejected: @escaping (Error) -> () = { _ in }) -> Promise<Value> {
        /// Implement me
    }
    
    func `catch`(onRejected: @escaping (Error) -> Void) -> Promise<Value> {
        /// Implement me
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
