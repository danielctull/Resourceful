import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

#if swift(>=5.5)

  @available(iOS 13.0, *)
  @available(OSX 10.15, *)
  @available(tvOS 13.0, *)
  @available(watchOS 6.0, *)
  extension URLSession {

    /// Asynchronously retrieves the value of the resource.
    ///
    /// - Parameter resource: The resource to fetch.
    /// - Returns: The value of the resource.
    public func value<Value>(for resource: Resource<Value>) async throws -> Value {
      try await withUnsafeThrowingContinuation { continuation in
        fetch(resource, completion: continuation.resume)
      }
    }
  }

#endif
