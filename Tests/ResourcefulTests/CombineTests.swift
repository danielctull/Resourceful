
import Resourceful
import XCTest

#if canImport(Combine)
import Combine
#endif

@available(iOS 13.0, *)
@available(OSX 10.15, *)
@available(tvOS 13.0, *)
@available(watchOS 6.0, *)
final class CombineTests: XCTestCase {

    #if canImport(Combine)
    private var cancellable: AnyCancellable?
    #endif

    func testSuccess() throws {
        #if canImport(Combine)
        try createFile(withContents: "Hello") { url in
            expect { completion in

                cancellable = URLSession.shared
                    .publisher(for: resource(url))
                    .sink(receiveCompletion: { _ in completion() },
                          receiveValue: { XCTAssertEqual($0, "Hello") })
            }
        }
        #endif
    }

    func testRequestFailure() throws {
        #if canImport(Combine)
        expect { completion in

            cancellable = URLSession.shared
                .publisher(for: failingRequestResource)
                .replaceError(with: "ERROR")
                .sink(receiveCompletion: { _ in completion() },
                      receiveValue: { XCTAssertEqual($0, "ERROR") })
        }
        #endif
    }

    func testFailure() throws {
        #if canImport(Combine)
        try createFile(withContents: "Hello") { base in
            expect { completion in

                let url = base.appendingPathComponent("ThisDoesNotExist")
                cancellable = URLSession.shared
                    .publisher(for: resource(url))
                    .replaceError(with: "ERROR")
                    .sink(receiveCompletion: { _ in completion() },
                          receiveValue: { XCTAssertEqual($0, "ERROR") })
            }
        }
        #endif
    }
}
