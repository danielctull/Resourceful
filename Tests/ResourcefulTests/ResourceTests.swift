import Foundation
import Resourceful
import Testing

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

@Suite("Resource")
struct ResourceTests {

  @Test func initialiser() throws {
    let resource = try Resource(request: request) { _, _ in return "Hello" }
    #expect(try resource.request == request)
    #expect(try resource.value(for: response) == "Hello")
  }

  @Test func testMapRequest() throws {
    let resource = try Resource(request: request) { _, _ in return 20 }
      .mapRequest { request in
        URLRequest(url: request.url!.appendingPathComponent("test"))
      }
    #expect(try resource.request.url == url.appendingPathComponent("test"))
  }

  @Test func testModifyRequest() throws {
    let resource = try Resource(request: request) { _, _ in return 20 }
      .modifyRequest { $0.url?.appendPathComponent("test") }

    #expect(try resource.request.url == url.appendingPathComponent("test"))
  }

  @Test func testTryMap() throws {
    let integer = try Resource(request: request) { _, _ in return 20 }
    let string = integer.tryMap { String($0) }
    #expect(try integer.value(for: response) == 20)
    #expect(try string.value(for: response) == "20")
  }
}

// MARK: - Test helpers

private var url: URL {
  get throws { try #require(URL(string: "http://example.com")) }
}

private var request: URLRequest {
  get throws { try URLRequest(url: url) }
}

private var response: (Data, URLResponse) {
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
