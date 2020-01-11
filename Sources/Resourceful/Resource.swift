
import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Represents a value, retrieved from the given request, where the data is
/// transformed with the given transform function.
public struct Resource<Value> {

    public typealias Response = (data: Data, response: URLResponse)

    /// A request used to fetch the data.
    public let request: URLRequest

    /// Transforms the network response into the desired value.
    public let transform: (Response) throws -> Value

    /// Creates a resource located with the request and transformed from data
    /// using the given transform.
    ///
    /// - Parameters:
    ///   - request: A request for this resource.
    ///   - transform: Used to transform the response into the desired value.
    public init(request: URLRequest,
                transform: @escaping (Response) throws -> Value) {
        self.request = request
        self.transform = transform
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

        return Resource<NewValue>(request: request) {
            return try transform(self.transform($0))
        }
    }
}
