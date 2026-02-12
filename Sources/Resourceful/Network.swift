import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public struct Network: Sendable {
  private let fetch: @Sendable (URLRequest) async throws -> (Data, URLResponse)

  public init(
    fetch: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse)
  ) {
    self.fetch = fetch
  }
}

extension Network {

  /// Asynchronously retrieves the value of the resource.
  ///
  /// - Parameter resource: The resource to fetch.
  /// - Returns: The value of the resource.
  public func value<Value>(
    for resource: Resource<Value>
  ) async throws -> Value {
    try await resource.value(for: fetch(resource.request))
  }
}
