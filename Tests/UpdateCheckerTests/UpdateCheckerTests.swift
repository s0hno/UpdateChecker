import XCTest
@testable import UpdateChecker

class UpdateCheckerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(UpdateChecker().text, "Hello, World!")
    }


    static var allTests : [(String, (UpdateCheckerTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
