import XCTest
@testable import ThreadSafeCollections

final class ThreadSafeCollectionsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ThreadSafeCollections().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
