
import Resourceful
import XCTest

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class FetchTests: XCTestCase {

    func testSuccess() throws {
        // Linux doesn't support file-based URLs that this test uses.
        #if !os(Linux)
        try createFile(withContents: "Hello") { url in
            expect { completion in

                URLSession.shared.fetch(resource(url)) { result in
                    AssertSuccess(result, "Hello")
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
            URLSession.shared.fetch(failingRequestResource) { result in
                AssertFailure(result)
                completion()
            }
        }
        #endif
    }

    func testFailure() throws {
        // Linux doesn't support file-based URLs that this test uses.
        #if !os(Linux)
        try createFile(withContents: "Hello") { base in
            expect { completion in

                let url = base.appendingPathComponent("ThisDoesNotExist")
                URLSession.shared.fetch(resource(url)) { result in
                    AssertFailure(result)
                    completion()
                }
            }
        }
        #endif
    }
}
