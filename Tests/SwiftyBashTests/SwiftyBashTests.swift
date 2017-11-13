import XCTest
import Foundation
@testable import SwiftyBash

infix operator |: MultiplicationPrecedence

class SwiftyBashTests: XCTestCase {

    let testDirectoryName = "TestDirectory"

    // MARK: - Setup test environment
    func setupTestFolder() {
        do {
            guard let mkdir = try BashCmd("mkdir", args:testDirectoryName).run(), mkdir == "" else { XCTFail(); return }
        }
        catch {
            print(error as? BashException)
            XCTFail()
        }
    }

    func removeTestFolderIfExists() {
        do {
            let ls = BashCmd("ls")
            let grep = BashCmd("grep", args:"'\(testDirectoryName)'")
            let wc = BashCmd("wc", args:"-l")
            // If exists the folder exists
            guard let result = try (ls | grep | wc).run(outputType: .string(.whiteSpacesTrimmed)), Int(result) == 1 else { return }

            // Remove it
            guard let rm = try BashCmd("rm", args: "-r", testDirectoryName).run(), rm == "" else { XCTFail(); return }

            // After removal, check if it was well removed
            if let resultAfterRemoval = try (ls | grep | wc).run(outputType: .string(.whiteSpacesTrimmed)), Int(resultAfterRemoval) != 0  {
                XCTFail()
            }
        }
        catch {
            print(error as? BashException)
            XCTFail()
        }
    }

    // MARK: - BashCmd Tests
    func testEchoBashCommand() {
        let echoMessage = "Hello, World!"
        print(echoMessage)
        do {
            print("0")
            let cmd = BashCmd("echo", args:echoMessage)
            print("1")
            guard let echo = try cmd.run() else {
              print("2")
            XCTFail()
            return
          }
            print("4")
            XCTAssertEqual(echoMessage, echo)
        }
        catch {
            print("10")
            print(error as? BashException)
            XCTFail()
        }
    }

    func testSetBashCommands() {
        removeTestFolderIfExists()
        setupTestFolder()

        do {
            guard let ls = try BashCmd("ls", from:testDirectoryName).run(outputType: .string(.whiteSpacesTrimmed)), ls == "" else { XCTFail(); return }
            let ls_all = BashCmd("ls", args:"-al", testDirectoryName)
            let wc = BashCmd("wc", args:"-l")
            guard let numberOfLines = try (ls_all | wc).run(outputType: .string(.whiteSpacesTrimmed)), Int(numberOfLines) == 3 else { XCTFail(); return }
        }
        catch {
            print(error as? BashException)
            XCTFail()
        }

        removeTestFolderIfExists()
    }

    func testWritingFile() {
        removeTestFolderIfExists()
        setupTestFolder()

        do {
            let filename = "file.txt"
            let ls_all = BashCmd("ls", args:"-al", from:testDirectoryName)
            guard ls_all.command == "cd \(testDirectoryName) && ls -al" else { XCTFail(); return }
            // Write `ls` to file
            guard let ls_result = try ls_all.run() else { XCTFail(); return }
            let write_result = try BashCmd("echo", args:"'\(ls_result)'", from:testDirectoryName).run(outputType: .file(filename))
            guard write_result == nil else { XCTFail(); return }

            // Check the number of lines
            let wc = BashCmd("wc", args:"-l")
            guard let numberOfLines = try (ls_all | wc).run(outputType: .string(.whiteSpacesTrimmed)), Int(numberOfLines) == 4 else { XCTFail(); return }

            // Cat the created file and compare with the string version of the file
            guard let cat = try BashCmd("cat", args:filename, from:testDirectoryName).run(), ls_result == cat else { XCTFail(); return }
        }
        catch {
            print(error as? BashException)
            XCTFail()
        }

        removeTestFolderIfExists()
    }

    func testThrowingError() {
        removeTestFolderIfExists()

        do {
            let _ = try BashCmd("cd", args:testDirectoryName).run()
            XCTFail()
        }
        catch {
            if let error = error as? BashException {
                guard error.stdout == "", error.stderr.contains("No such file or directory") else { XCTFail(); return }
            }
            else {
                print(error as? BashException)
                XCTFail()
            }
        }
    }

    func testThrowingError2() {

        let text = "my errz"

        do {
            let bashCmd = BashCmd("echo", args:"'\(text)'", ">", "/dev/stderr")
            guard bashCmd.command == "echo 'my errz' > /dev/stderr" else { XCTFail(); return }
            let _ = try bashCmd.run(outputType: .string(.raw))
        }
        catch {
            if let error = error as? BashException {
                guard error.stdout == "", error.stderr == "\(text)\n" else { XCTFail(); return }
            }
            else {
                print(error as? BashException)
                XCTFail()
            }
        }
    }

    // MARK: - String extension Test
    /// One line test
    func testTrimmingNewLinesString() {
        let notTrimmedString = "  a   b  "
        let trimmedString = "a   b"

        XCTAssertEqual(trimmedString, notTrimmedString.trimmingCharactersEachNewLine(in:.whitespaces))
    }

    /// Multi-lines test
    func testTrimmingNewLinesString2() {
        let notTrimmedString2 = """
 a
    b
  c    d
"""
        let trimmedString2  = """
a
b
c    d
"""
        XCTAssertEqual(trimmedString2, notTrimmedString2.trimmingCharactersEachNewLine(in:.whitespaces))
    }

    /// One-liner Multi-lines test
    func testTrimmingNewLinesString3() {
        let notTrimmedString3 = "  a   b  \n     o     \n c d e      "
        let trimmedString3 = "a   b\no\nc d e"

        XCTAssertEqual(trimmedString3, notTrimmedString3.trimmingCharactersEachNewLine(in:.whitespaces))
    }

    static var allTests = [
        ("testEchoBashCommand", testEchoBashCommand),
        ("testSetBashCommands", testSetBashCommands),
        ("testWritingFile", testWritingFile),
        ("testThrowingError", testThrowingError),
        ("testThrowingError2", testThrowingError2),
        ("testTrimmingNewLinesString", testTrimmingNewLinesString),
        ("testTrimmingNewLinesString2", testTrimmingNewLinesString2),
        ("testTrimmingNewLinesString3", testTrimmingNewLinesString3),
    ]
}
