import Foundation
import Resourceful
import Testing

@Suite("Network")
struct NetworkTests {

  @Test func success() async throws {
    let value = try await Network.disk.value(for: .hello)
    #expect(value == "Hello\n")
  }

  @Test func `failure: make request`() async throws {
    await #expect(throws: TestError.self) {
      try await Network.disk.value(for: .makeRequestFailure)
    }
  }

  @Test func `failure: not found`() async throws {
    await #expect(throws: Error.self) {
      try await Network.disk.value(for: .notFound)
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

// MARK: Test Resources

struct TestError: Error {}

extension Resource<String> {

  /// A resource pointing to the hello.txt file in Resources.
  fileprivate static var hello: Resource {
    get throws {
      let url = try #require(Bundle.module.url(forResource: "Hello", withExtension: "txt"))
      let request = URLRequest(url: url)
      return Resource<String>(request: request) { data, _ in
        String(decoding: data, as: UTF8.self)
      }
    }
  }

  /// A resource which fails to make its request.
  fileprivate static var makeRequestFailure: Resource<String> {
    return Resource<String> {
      throw TestError()
    } success: { data, _ in
      String(decoding: data, as: UTF8.self)
    }
  }

  /// A resource pointing to a non-existent file.
  fileprivate static var notFound: Resource {
    get throws {
      let url = Bundle.module.bundleURL.appending(component: "not_here")
      let request = URLRequest(url: url)
      return Resource<String>(request: request) { data, _ in
        String(decoding: data, as: UTF8.self)
      }
    }
  }
}
