import ArgumentParser
import Foundation
import SwiftLox

@main
struct SwiftLoxCLI: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "swiftlox",
    abstract: "A Swift implementation of the Lox programming language",
    version: "0.0.1"
  )

  @Argument(help: "The path to the Lox source file to execute")
  var path: String?

  mutating func run() throws {
    if let path = path {
      try runFile(path: path)
    } else {
      runPrompt()
    }
  }

  private func runFile(path: String) throws {
    guard let source = try? String(contentsOfFile: path, encoding: .utf8) else {
      throw RuntimeError("Could not read file at path: \(path)")
    }
    // We'll implement this later
    run(source: source)
  }

  private func runPrompt() {
    print("SwiftLox REPL v0.0.1")
    while true {
      print("> ", terminator: "")
      var source = ""
      while let line = readLine(strippingNewline: false) {
        if line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
          break
        }
        source += line
      }
      if source.isEmpty { continue }
      // We'll implement this later
      run(source: source)
    }
  }

  private func run(source: String) {
    print("Input: \(source)")
    let scanner = Scanner(source: source)
    let result = scanner.scanTokens()
    switch result {
    case .success(let tokens):
      for token in tokens {
        print(token)
      }
    case .failure(let scannerErrors):
      for error in scannerErrors.errors {
        print(error)
      }
    }
    // This will be implemented as we build our interpreter
  }
}

struct RuntimeError: Error, CustomStringConvertible {
  let message: String

  init(_ message: String) {
    self.message = message
  }

  var description: String {
    return message
  }
}
