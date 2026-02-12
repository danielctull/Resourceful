import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

extension URLSession {

  /// Asynchronously retrieves the value of the resource.
  ///
  /// - Parameter resource: The resource to fetch.
  /// - Returns: The value of the resource.
  public func value<Value>(for resource: Resource<Value>) async throws -> Value {
    try await resource.value(for: data(for: resource.request))
  }
}
