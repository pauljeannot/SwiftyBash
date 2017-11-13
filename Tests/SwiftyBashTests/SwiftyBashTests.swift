import XCTest
@testable import SwiftyBash

class SwiftyBashTests: XCTestCase {
    func testTrimmingNewLinesString() {

        let notTrimmedString = " a\n  b   \n      c    d     \n  "
        let trimmedString = "a\nb\nc    d\n"

        XCTAssertEqual(trimmedString, notTrimmedString.trimmingCharactersEachNewLine(in:.whitespaces))
    }


    static var allTests = [
        ("testTrimmingNewLinesString", testTrimmingNewLinesString),
    ]
}
