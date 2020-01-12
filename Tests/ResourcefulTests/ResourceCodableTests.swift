
import Resourceful
import XCTest

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class ResourceCodableTests: XCTestCase {

    func testDecode() throws {
        let resource = Resource<User>(request: request, decoder: JSONDecoder())
        XCTAssertEqual(resource.request, request)
        let response = try userResponse(name: "Daniel")
        XCTAssertEqual(try resource.transform(response), User(name: "Daniel"))
    }

    // swiftlint:disable force_unwrapping
    private var url: URL { return URL(string: "http://example.com")! }
    // swiftlint:enable force_unwrapping

    private var request: URLRequest { return URLRequest(url: url) }
    private func userResponse(name: String) throws -> (Data, URLResponse) {
        let json = try Unwrap("{\"name\":\"\(name)\"}".data(using: .utf8))
        return (json, URLResponse(url: url,
                                  mimeType: nil,
                                  expectedContentLength: 0,
                                  textEncodingName: nil))
    }
}

fileprivate struct User: Codable, Equatable {
    let name: String
}
