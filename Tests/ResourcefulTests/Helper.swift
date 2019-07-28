
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
    func createFile(withContents string: String, function: (URL) -> Void) throws {

        let fileManager = FileManager()
        let cache = try fileManager.url(for: .cachesDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: true)
        let url = cache.appendingPathComponent(UUID().uuidString)
        guard let data = string.data(using: .utf8) else {
            struct DataError: Error {}
            throw DataError()
        }

        try data.write(to: url)
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

/// Asserts that the given Result is a success.
///
/// - Parameter result: The result to evaluate
/// - Parameter expected: The expected Success value.
/// - Parameter file: The file in which failure occurred. Defaults to the file
///                   name of the test case in which this function was called.
/// - Parameter line: The line number on which failure occurred. Defaults to the
///                   line number on which this function was called.
func AssertSuccess<Success: Equatable, Failure>(
    _ result: Result<Success, Failure>,
    _ expected: Success,
    file: StaticString = #file,
    line: UInt = #line
) {
    switch result {
    case .success(let success):
        XCTAssertEqual(success, expected, file: file, line: line)
    case .failure(let failure):
        XCTFail("Failure: \(failure.localizedDescription)", file: file, line: line)
    }
}

/// Asserts that the given Result is a failure.
///
/// - Parameter result: The result to evaluate.
/// - Parameter expected: The expected Failure value.
/// - Parameter file: The file in which failure occurred. Defaults to the file
///                   name of the test case in which this function was called.
/// - Parameter line: The line number on which failure occurred. Defaults to the
///                   line number on which this function was called.
func AssertFailure<Success, Failure: Equatable>(
    _ result: Result<Success, Failure>,
    _ expected: Failure,
    file: StaticString = #file,
    line: UInt = #line
) {
    switch result {
    case .success(let success):
        XCTFail("Success: \(success)", file: file, line: line)
    case .failure(let failure):
        XCTAssertEqual(failure, expected, file: file, line: line)
    }
}

/// Asserts that the given Result is a failure.
///
/// - Parameter result: The result to evaluate.
/// - Parameter file: The file in which failure occurred. Defaults to the file
///                   name of the test case in which this function was called.
/// - Parameter line: The line number on which failure occurred. Defaults to the
///                   line number on which this function was called.
func AssertFailure<Success, Failure>(
    _ result: Result<Success, Failure>,
    file: StaticString = #file,
    line: UInt = #line
) {
    switch result {
    case .success(let success):
        XCTFail("Success: \(success)", file: file, line: line)
    case .failure:
        break
    }
}
