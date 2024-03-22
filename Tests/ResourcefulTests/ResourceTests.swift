
import Resourceful
import XCTest

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class ResourceTests: XCTestCase {

    func testInit() throws {
        let resource = try Resource(request: request) { _ in return "Hello" }
        try XCTAssertEqual(resource.request, request)
        try XCTAssertEqual(resource.value(for: response), "Hello")
    }

    func testMapRequest() throws {
        let resource = try Resource(request: request) { _ in return 20 }
            .mapRequest { request in
                URLRequest(url: request.url!.appendingPathComponent("test"))
            }
        try XCTAssertEqual(try resource.request.url, url.appendingPathComponent("test"))
    }

    func testModifyRequest() throws {
        let resource = try Resource(request: request) { _ in return 20 }
            .modifyRequest { $0.url?.appendPathComponent("test") }
        try XCTAssertEqual(resource.request.url, url.appendingPathComponent("test"))
    }

    func testTryMap() throws {
        let integer = try Resource(request: request) { _ in return 20 }
        let string = integer.tryMap { String($0) }
        XCTAssertEqual(try integer.value(for: response), 20)
        XCTAssertEqual(try string.value(for: response), "20")
    }

    private var url: URL {
        get throws { try XCTUnwrap(URL(string: "http://example.com")) }
    }

    private var request: URLRequest {
        get throws { try URLRequest(url: url) }
    }

    private var response: Resource.Response {
        get throws {
            try (
                Data(),
                URLResponse(
                    url: url,
                    mimeType: nil,
                    expectedContentLength: 0,
                    textEncodingName: nil
                )
            )
        }
    }
}
