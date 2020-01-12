
import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Resource where Value: Decodable {

    /// Creates a resource located with the request and transformed from data
    /// using the given top level decoder.
    ///
    /// The top level decoder can be a JSONDecoder or PropertyListDecoder from
    /// the standard library or any other that conforms to the TopLevelDecoder
    /// protocol.
    /// 
    /// - Parameters:
    ///   - request: The request for this resource.
    ///   - decoder: Used to decode the response data desired value.
    public init<Decoder>(request: URLRequest, decoder: Decoder)
        where
        Decoder: TopLevelDecoder,
        Decoder.Input == Data
    {
        self.init(request: request) {
            try decoder.decode(Value.self, from: $0.data)
        }
    }
}

/// A type that defines methods for decoding.
public protocol TopLevelDecoder {

    /// The type this decoder accepts.
    associatedtype Input

    /// Decodes an instance of the indicated type.
    func decode<T>(_ type: T.Type, from: Input) throws -> T where T: Decodable
}

extension JSONDecoder: TopLevelDecoder {}

#if !os(Linux) || swift(>=5.1)
extension PropertyListDecoder: TopLevelDecoder {}
#endif
