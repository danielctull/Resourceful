
import Resourceful
import XCTest

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class SynchronousTests: XCTestCase {

    func testSuccess() throws {
        // Linux doesn't support file-based URLs that this test uses.
        #if !os(Linux)
        try createFile(withContents: "Hello") { url in

            do {
                let value = try URLSession.shared.get(resource(url))
                XCTAssertEqual(value, "Hello")
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
        #endif
    }

    func testFailure() throws {
        // Linux doesn't support file-based URLs that this test uses.
        #if !os(Linux)
        try createFile(withContents: "Hello") { base in

            let url = base.appendingPathComponent("ThisDoesNotExist")

            do {
                let value = try URLSession.shared.get(resource(url))
                XCTFail("Value: \(value)")
            } catch {
            }
        }
        #endif
    }
}
