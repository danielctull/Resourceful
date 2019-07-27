
import Foundation
import Resourceful
import XCTest

extension XCTestCase {

    /// Work around for not having file resources in swift package manager :)
    ///
    /// This writes a file containing the UTF8 representation of the
    /// string "Hello".
    ///
    /// - Parameter function: A function that is provided with the created file.
    func setup(function: (URL) -> Void) throws {

        let fileManager = FileManager()
        let cache = try fileManager.url(for: .cachesDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: true)
        let url = cache.appendingPathComponent(UUID().uuidString)
        try "Hello".data(using: .utf8)?.write(to: url)

        function(url)
        try fileManager.removeItem(at: url)
    }

    /// Waits for an expectation while the function runs. The function is
    /// provided a closure to fulfill the expectation.
    ///
    /// - Parameter function: The function to wait for.
    func expect(function: (@escaping () -> Void) -> Void) {
        let expectation = self.expectation(description: "expectation")
        function { expectation.fulfill() }
        wait(for: [expectation], timeout: 3)
    }

    /// A resource pointing to the url which decodes a UTF8 string.
    ///
    /// - Parameter url: The location of the data.
    func resource(_ url: URL) -> Resource<String> {
        let request = URLRequest(url: url)
        return Resource<String>(request: request) {
            String(data: $0.data, encoding: .utf8) ?? ""
        }
    }
}
