
import Foundation
import Resourceful
import XCTest

@available(iOS 13.0, *)
@available(OSX 10.15, *)
@available(tvOS 13.0, *)
@available(watchOS 6.0, *)
final class AsyncTests: XCTestCase {

    func testSuccess() async throws {
        // Linux doesn't support file-based URLs that this test uses.
        #if !os(Linux)
        try createFile(withContents: "Hello") { url in
            expect { completion in
                Task.detached {
                    let value = try await URLSession.shared.value(for: self.resource(url))
                    XCTAssertEqual(value, "Hello")
                    completion()
                }
            }
        }
        #endif
    }

    func testRequestFailure() throws {
        // Linux doesn't support file-based URLs that this test uses.
        #if !os(Linux)
        expect { completion in
            Task.detached {
                do {
                    _ = try await URLSession.shared.value(for: self.failingRequestResource)
                    XCTFail("Should cause an error.")
                } catch {
                    completion()
                }
            }
        }
        #endif
    }

    func testFailure() throws {
        // Linux doesn't support file-based URLs that this test uses.
        #if !os(Linux)
        try createFile(withContents: "Hello") { base in
            expect { completion in
                Task.detached {
                    do {
                        let url = base.appendingPathComponent("ThisDoesNotExist")
                        _ = try await URLSession.shared.value(for: self.resource(url))
                        XCTFail("Should cause an error.")
                    } catch {
                        completion()
                    }
                }
            }
        }
        #endif
    }
}
