#if !canImport(ObjectiveC)
import XCTest

extension ResourceCombineTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ResourceCombineTests = [
        ("testFailure", testFailure),
        ("testSuccess", testSuccess),
    ]
}

extension ResourceTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ResourceTests = [
        ("testInit", testInit),
        ("testMap", testMap),
    ]
}

extension ResourceURLSessionTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ResourceURLSessionTests = [
        ("testFailure", testFailure),
        ("testSuccess", testSuccess),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ResourceCombineTests.__allTests__ResourceCombineTests),
        testCase(ResourceTests.__allTests__ResourceTests),
        testCase(ResourceURLSessionTests.__allTests__ResourceURLSessionTests),
    ]
}
#endif