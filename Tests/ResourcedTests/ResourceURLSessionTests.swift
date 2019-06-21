
import Resourced
import XCTest

final class ResourceURLSessionTests: XCTestCase {

    func testSuccess() throws {
        try setup { url in
            expect { fulfill in

                URLSession.shared.fetch(resource(url)) { result in
                    XCTAssertEqual(try? result.get(), "Hello")
                    fulfill()
                }
            }
        }
    }

    func testFailure() throws {
        try setup { base in
            expect { fulfill in

                let url = base.appendingPathComponent("ThisDoesNotExist")
                URLSession.shared.fetch(resource(url)) { result in

                    // Why does XCTAssertThrowsError propagate the error through?
                    // What am I doing wrong here?
                    try? {
                        XCTAssertNil(try? result.get())
                        XCTAssertThrowsError(try result.get())
                    }()

                    fulfill()
                }
            }
        }
    }
}
