
import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

#if swift(>=5.5)

@available(iOS 15.0, *)
@available(OSX 12, *)
@available(tvOS 15.0, *)
@available(watchOS 8.0, *)
extension URLSession {

    /// Asynchronously retrieves the value of the resource.
    ///
    /// - Parameter resource: The resource to fetch.
    /// - Returns: The value of the resource.
    public func value<Value>(for resource: Resource<Value>) async throws -> Value {
        let request = try resource.makeRequest()
        let response = try await data(for: request)
        return try resource.transform(response)
    }
}

#endif
