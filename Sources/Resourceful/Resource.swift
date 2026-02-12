import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

/// Represents a value, retrieved from the given request, where the data is
/// transformed with the given transform function.
public struct Resource<Value> {

  private let _request: () throws -> URLRequest
  private let _success: (Data, URLResponse) throws -> Value
  private let _failure: (any Error) throws -> Value

  /// Creates a resource located with the request and transformed from data
  /// using the given transform.
  ///
  /// Any failures from the makeRequest or transform functions will be
  /// surfaced when performing the network request using the fetch or
  /// publisher methods on URLSession.
  ///
  /// - Parameters:
  ///   - request: Creates a request for this resource.
  ///   - success: Used to transform the response into the desired value.
  public init(
    request: @escaping () throws -> URLRequest,
    success: @escaping (Data, URLResponse) throws -> Value,
    failure: @escaping (any Error) throws -> Value = { throw $0 },
  ) {
    _request = request
    _success = success
    _failure = failure
  }
}

extension Resource {

  /// Creates a resource located with the request and transformed from data
  /// using the given transform.
  ///
  /// - Parameters:
  ///   - request: A request for this resource.
  ///   - success: Used to transform the response into the desired value.
  public init(
    request: URLRequest,
    success: @escaping (Data, URLResponse) throws -> Value,
    failure: @escaping (any Error) throws -> Value = { throw $0 },
  ) {
    self.init(
      request: { request },
      success: success,
      failure: failure,
    )
  }
}

extension Resource {

  /// A request used to fetch the data.
  public var request: URLRequest {
    get throws { try _request() }
  }

  /// Transforms the network response into the desired value.
  public func value(for response: (Data, URLResponse)) throws -> Value {
    try _success(response.0, response.1)
  }

  /// Transforms the error into the desired value.
  public func value(for error: any Error) throws -> Value {
    try _failure(error)
  }
}

extension Resource {

  /// Returns a resource containing the result of mapping the given
  /// transform on the receiver's value.
  ///
  /// - Parameter transform: A mapping closure. transform accepts the value
  /// of this resource as its parameter and returns a transformed value.
  /// - Returns: A resource of generic type NewValue.
  public func tryMap<NewValue>(
    _ transform: @escaping (Value) throws -> NewValue
  ) -> Resource<NewValue> {

    Resource<NewValue>(request: _request) { data, response in
      try transform(_success(data, response))
    }
  }

  public func mapRequest(
    _ modify: @escaping (URLRequest) throws -> URLRequest
  ) -> Resource {
    Resource(
      request: { try modify(self._request()) },
      success: _success
    )
  }

  public func modifyRequest(
    _ modify: @escaping (inout URLRequest) throws -> Void
  ) -> Resource {
    mapRequest { request in
      var request = request
      try modify(&request)
      return request
    }
  }
}
