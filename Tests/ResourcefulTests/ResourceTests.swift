
import Resourceful
import XCTest

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class ResourceTests: XCTestCase {

    func testInit() {
        let resource = Resource(request: request) { _ in return "Hello" }
        XCTAssertEqual(resource.request, request)
        XCTAssertEqual(try resource.transform(response), "Hello")
    }

    func testTryMap() {
        let integer = Resource(request: request) { _ in return 20 }
        let string = integer.tryMap(String.init)
        XCTAssertEqual(try integer.transform(response), 20)
        XCTAssertEqual(try string.transform(response), "20")
    }

    // swiftlint:disable force_unwrapping
    private var url: URL { return URL(string: "http://example.com")! }
    // swiftlint:enable force_unwrapping

    private var request: URLRequest { return URLRequest(url: url) }
    private var response: (Data, URLResponse) {
        return (Data(), URLResponse(url: url,
                                    mimeType: nil,
                                    expectedContentLength: 0,
                                    textEncodingName: nil))
    }
}
