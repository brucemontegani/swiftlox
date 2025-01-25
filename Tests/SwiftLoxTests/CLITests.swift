// Tests/SwiftLoxTests/CLITests.swift

import FoundationEssentials
import Testing
import XCTest

@testable import SwiftLoxCLI

final class CLITests: XCTestCase {
  //   // Helper function to create a temporary file
  //   func createTempFile(content: String) throws -> String {
  //     let tempDir = NSTemporaryDirectory()
  //     let fileName = UUID().uuidString + ".lox"
  //     let filePath = (tempDir as NSString).appendingPathComponent(fileName)
  //     try content.write(toFile: filePath, atomically: true, encoding: .utf8)
  //     return filePath
  //   }

  // Helper to capture stdout for testing REPL output
  //   class OutputCapture {
  //     private let pipe = Pipe()
  //     private let originalStdout: Int32

  //     init() {
  //       originalStdout = dup(FileHandle.standardOutput.fileDescriptor)
  //       dup2(pipe.fileHandleForWriting.fileDescriptor, FileHandle.standardOutput.fileDescriptor)
  //     }

  //     func capture() -> String {
  //       pipe.fileHandleForWriting.closeFile()
  //       let data = pipe.fileHandleForReading.readDataToEndOfFile()
  //       return String(data: data, encoding: .utf8) ?? ""
  //     }

  //     func restore() {
  //       dup2(originalStdout, FileHandle.standardOutput.fileDescriptor)
  //       close(originalStdout)
  //     }
  //   }

  //   func testVersionFlag() throws {
  //     let cli = SwiftLoxCLI()
  //     let output = try cli.run(["--version"])
  //     XCTAssertEqual(output, "swiftlox 0.0.1\n")
  //   }

  //   func testCLIVersionFlag() throws {
  //     let process = try Process.run(
  //       productsDirectory.appendingPathComponent("SwiftLoxCLI"),
  //       arguments: ["--version"])
  //     process.waitUntilExit()

  //     XCTAssertEqual(process.terminationStatus, 0)
  //   }

  //   func testCLIHelpFlag() throws {
  //     let process = try Process.run(
  //       productsDirectory.appendingPathComponent("SwiftLoxCLI"),
  //       arguments: ["--help"])
  //     process.waitUntilExit()

  //     XCTAssertEqual(process.terminationStatus, 0)
  //   }

  //   func testFileExecution() throws {
  //     let testContent = "print(\"Hello, World!\");"
  //     let filePath = try createTempFile(content: testContent)
  //     defer { try? FileManager.default.removeItem(atPath: filePath) }

  //     let outputCapture = OutputCapture()
  //     defer { outputCapture.restore() }

  //     var cli = SwiftLoxCLI()
  //     cli.path = filePath
  //     try cli.run()

  //     let output = outputCapture.capture()
  //     XCTAssertTrue(output.contains("Running: print(\"Hello, World!\");"))
  //   }

  //   func testFileNotFound() throws {
  //     var cli = SwiftLoxCLI()
  //     cli.path = "nonexistent.lox"

  //     XCTAssertThrowsError(try cli.run()) { error in
  //       guard let runtimeError = error as? RuntimeError else {
  //         XCTFail("Expected RuntimeError")
  //         return
  //       }
  //       XCTAssertTrue(runtimeError.message.contains("Could not read file"))
  //     }
  //   }

  //   // Helper to get the path to the built products directory
  //   var productsDirectory: URL {
  //     for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
  //       return bundle.bundleURL.deletingLastPathComponent()
  //     }
  //     fatalError("couldn't find the products directory")
  //   }
}
