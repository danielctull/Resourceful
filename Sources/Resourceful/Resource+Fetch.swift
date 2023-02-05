
import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession {

    /// Fetches a resource using its request and transforms the returned data
    /// using its transform closure.
    ///
    /// - Parameters:
    ///   - resource: The resource to fetch.
    ///   - callbackQueue: The queue to call the completion handler on. Defaults
    ///                    to `DispatchQueue.main`.
    ///   - completion: Completion handler with the result.
    @discardableResult
    public func fetch<Value>(
        _ resource: Resource<Value>,
        callbackQueue queue: DispatchQueue = .main,
        completion: @escaping @Sendable (Result<Value, Error>) -> Void
    ) -> URLSessionDataTask {

        do {
            let request = try resource.makeRequest()
            return perform(request: request) { result in
                let value = Result { try resource.transform(result.get()) }
                queue.async {
                    completion(value)
                }
            }
        } catch {
            queue.async {
                completion(.failure(error))
            }
            return URLSessionDataTask()
        }
    }

    private func perform(
        request: URLRequest,
        completion: @escaping @Sendable (Result<(Data, URLResponse), URLError>) -> Void
    ) -> URLSessionDataTask {

        let task = dataTask(with: request) { data, response, error in

            guard let data = data, let response = response else {
                let error = (error as? URLError) ?? URLError(.unknown)
                completion(.failure(error))
                return
            }

            completion(.success((data, response)))
        }

        task.resume()
        return task
    }
}
