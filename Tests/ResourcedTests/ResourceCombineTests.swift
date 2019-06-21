
import Resourced
import XCTest

#if canImport(Combine)

import Combine

@available(iOS 13.0, *)
@available(OSX 10.15, *)
@available(UIKitForMac 13.0, *)
@available(tvOS 13.0, *)
@available(watchOS 6.0, *)
final class ResourceCombineTests: XCTestCase {

    func testSuccess() throws {
        try setup { url in
            expect { fulfill in

                _ = URLSession.shared
                    .publisher(for: resource(url))
                    .sink { XCTAssertEqual($0, "Hello"); fulfill() }
            }
        }
    }

    func testFailure() throws {
        try setup { base in
            expect { fulfill in

                let url = base.appendingPathComponent("ThisDoesNotExist")
                _ = URLSession.shared
                    .publisher(for: resource(url))
                    .replaceError(with: "ERROR")
                    .sink { XCTAssertEqual($0, "ERROR"); fulfill() }
            }
        }
    }
}

#endif
