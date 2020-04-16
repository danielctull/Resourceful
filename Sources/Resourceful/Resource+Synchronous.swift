
import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession {

    /// Synchronously perfoms the network request and returns the value.
    ///
    /// This extension is useful in contexts like command line apps.
    ///
    /// - Parameter resource: The resource to retrieve.
    /// - Throws: An error thrown.
    /// - Returns: The value of the resource.
    public func get<Value>(_ resource: Resource<Value>) throws -> Value {

        let semaphore = DispatchSemaphore(value: 0)

        var result: Result<Value, Error>!

        fetch(resource, callbackQueue: .global(qos: .userInitiated)) {
            result = $0
            semaphore.signal()
        }

        semaphore.wait()

        switch result! {
        case let .failure(error): throw error
        case let .success(value): return value
        }
    }
}
