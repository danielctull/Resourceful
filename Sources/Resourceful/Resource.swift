
import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Represents a value, retrieved from the given request, where the data is
/// transformed with the given transform function.
public struct Resource<Value> {

    public typealias Response = (data: Data, response: URLResponse)

    private let _request: () throws -> URLRequest
    private let _success: (Response) throws -> Value

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
        success: @escaping (Response) throws -> Value
    ) {
        _request = request
        _success = success
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
        success: @escaping (Response) throws -> Value
    ) {
        self.init(request: { request }, success: success)
    }
}

extension Resource {

    /// A request used to fetch the data.
    public var request: URLRequest {
        get throws { try _request() }
    }

    /// Transforms the network response into the desired value.
    public func value(for response: Response) throws -> Value {
        try _success(response)
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

        Resource<NewValue>(request: _request) { response in
            try transform(value(for: response))
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
        _ modify: @escaping (inout URLRequest) throws -> ()
    ) -> Resource {
        mapRequest { request in
            var request = request
            try modify(&request)
            return request
        }
    }
}

// MARK: - Deprecations

extension Resource {

    /// Transforms the network response into the desired value.
    @available(*, deprecated, message: "Use value(for:) instead.")
    public var transform: (Response) throws -> Value { _success }

    /// Makes the request for the resource.
    @available(*, deprecated, message: "Use request instead.")
    public var makeRequest: () throws -> URLRequest { _request }

    /// Creates a resource located with the request and transformed from data
    /// using the given transform.
    ///
    /// Any failures from the makeRequest or transform functions will be
    /// surfaced when performing the network request using the fetch or
    /// publisher methods on URLSession.
    ///
    /// - Parameters:
    ///   - makeRequest: Used to create a request for this resource.
    ///   - transform: Used to transform the response into the desired value.
    @available(*, deprecated, message: "Use init(request:success:) instead.")
    public init(
        makeRequest: @escaping () throws -> URLRequest,
        transform: @escaping (Response) throws -> Value
    ) {
        _request = makeRequest
        _success = transform
    }
}
