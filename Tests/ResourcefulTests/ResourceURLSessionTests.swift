
import Resourceful
import XCTest

final class ResourceURLSessionTests: XCTestCase {

    func testSuccess() throws {
        try createFile(withContents: "Hello") { url in
            expect { completion in

                URLSession.shared.fetch(resource(url)) { result in
                    XCTAssertEqual(try? result.get(), "Hello")
                    completion()
                }
            }
        }
    }

    func testFailure() throws {
        try createFile(withContents: "Hello") { base in
            expect { completion in

                let url = base.appendingPathComponent("ThisDoesNotExist")
                URLSession.shared.fetch(resource(url)) { result in

                    // Why does XCTAssertThrowsError propagate the error through?
                    // What am I doing wrong here?
                    try? {
                        XCTAssertNil(try? result.get())
                        XCTAssertThrowsError(try result.get())
                    }()

                    completion()
                }
            }
        }
    }
}
