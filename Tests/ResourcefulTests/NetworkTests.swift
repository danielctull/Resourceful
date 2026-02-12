import Foundation
import Resourceful
import Testing

@Suite("Network")
struct NetworkTests {

  @Test func success() async throws {
    let url = try #require(Bundle.module.url(forResource: "Hello", withExtension: "txt"))
    let request = URLRequest(url: url)
    let resource = Resource(request: request, success: String.init)
    let value = try await Network.disk.value(for: resource)
    #expect(value == "Hello\n")
  }

  @Test func `failure: make request`() async throws {

    struct TestError: Error {}

    let resource = Resource(
      request: { throw TestError() },
      success: String.init
    )

    await #expect(throws: TestError.self) {
      try await Network.disk.value(for: resource)
    }
  }

  @Test func `failure: network`() async throws {
    let failing = Network { _ in throw TestError() }
    let url = try #require(Bundle.module.url(forResource: "Hello", withExtension: "txt"))
    let request = URLRequest(url: url)
    let resource = Resource(request: request, success: String.init)
    await #expect(throws: TestError.self) {
      try await failing.value(for: resource)
    }
  }

  @Test func `failure: recover`() async throws {
    let failing = Network { _ in throw TestError() }
    let url = try #require(Bundle.module.url(forResource: "Hello", withExtension: "txt"))
    let request = URLRequest(url: url)
    let resource = Resource(
      request: request,
      success: String.init,
      failure: { "\(type(of: $0))" }
    )
    let value = try await failing.value(for: resource)
    #expect(value == "TestError")
  }

  @Test func `failure: rethrow`() async throws {
    struct NewError: Error {}
    let failing = Network { _ in throw TestError() }
    let url = try #require(Bundle.module.url(forResource: "Hello", withExtension: "txt"))
    let request = URLRequest(url: url)
    let resource = Resource(
      request: request,
      success: String.init,
      failure: { _ in throw NewError() }
    )
    await #expect(throws: NewError.self) {
      try await failing.value(for: resource)
    }
  }
}

extension Network {
#if os(Linux)
  fileprivate static let disk = Network { request in
    let url = try #require(request.url)
    let data = try Data(contentsOf: url)
    let response = URLResponse(
      url: url,
      mimeType: nil,
      expectedContentLength: data.count,
      textEncodingName: nil
    )
    return (data, response)
  }
#else
  fileprivate static let disk = Network(fetch: URLSession.shared.data)
#endif
}

fileprivate struct TestError: Error {}

extension String {
  fileprivate init(data: Data, response: URLResponse) {
    self.init(decoding: data, as: UTF8.self)
  }
}
