
import Foundation
import Resourceful
import XCTest

#if swift(>=5.5)

@available(iOS 15.0, *)
@available(OSX 12, *)
@available(tvOS 15.0, *)
@available(watchOS 8.0, *)
final class AsyncTests: XCTestCase {

    func testSuccess() throws {
        // Linux doesn't support file-based URLs that this test uses.
        #if !os(Linux)
        try createFile(withContents: "Hello") { url in
            expect { completion in
                detach {
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
            detach {
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
                detach {
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

#endif
