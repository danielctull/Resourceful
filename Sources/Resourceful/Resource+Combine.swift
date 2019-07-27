
import Foundation

#if canImport(Combine)

import Combine

@available(iOS 13.0, *)
@available(OSX 10.15, *)
@available(tvOS 13.0, *)
@available(watchOS 6.0, *)
extension URLSession {

    /// Returns a publisher that wraps a URL session data task for a given
    /// resource.
    ///
    /// The publisher publishes the value when the task completes, or terminates
    /// if the task fails with an error.
    ///
    /// - Parameter resource: The resource to fetch.
    /// - Returns: A publisher wrapping a data task.
    public func publisher<Value>(for resource: Resource<Value>) -> AnyPublisher<Value, Error> {

        dataTaskPublisher(for: resource.request)
            .tryMap(resource.transform)
            .eraseToAnyPublisher()
    }
}

#endif
