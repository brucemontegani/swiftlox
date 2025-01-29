// Tests/SwiftLoxTests/ScannerTests.swift

import Testing
import XCTest

@testable import SwiftLox

struct ScannerTests {
  @Test(
    "Scan single character tokens with and without spaces",
    arguments: ["(){},.-+;*=!></", "( ) { } , . - + ; * = ! > < /"])
  func scanSingleOnlyCharTokens(source: String) throws {
    let scanner = Scanner(source: source)
    let result = scanner.scanTokens()

    let expectedTokens = [
      Token(type: .leftParen, lexeme: "(", line: 1),
      Token(type: .rightParen, lexeme: ")", line: 1),
      Token(type: .leftBrace, lexeme: "{", line: 1),
      Token(type: .rightBrace, lexeme: "}", line: 1),
      Token(type: .comma, lexeme: ",", line: 1),
      Token(type: .dot, lexeme: ".", line: 1),
      Token(type: .minus, lexeme: "-", line: 1),
      Token(type: .plus, lexeme: "+", line: 1),
      Token(type: .semiColon, lexeme: ";", line: 1),
      Token(type: .star, lexeme: "*", line: 1),
      Token(type: .equal, lexeme: "=", line: 1),
      Token(type: .bang, lexeme: "!", line: 1),
      Token(type: .greater, lexeme: ">", line: 1),
      Token(type: .less, lexeme: "<", line: 1),
      Token(type: .slash, lexeme: "/", line: 1),
      Token(type: .eof, lexeme: "", line: 1),
    ]

    switch result {
    case .success(let tokens):
      try #require(tokens.count == expectedTokens.count)
      for (index, token) in tokens.enumerated() {
        #expect(token == expectedTokens[index])
      }
    case .failure(let errors):
      try #require(errors.errors.count == 0)
    }

  }

  @Test("Scan Double character tokens", arguments: ["!= == >= <="])
  func scanSingleDoubleCharTokens(source: String) throws {
    let scanner = Scanner(source: source)
    let result = scanner.scanTokens()

    let expectedTokens = [
      Token(type: .bangEqual, lexeme: "!=", line: 1),
      Token(type: .equalEqual, lexeme: "==", line: 1),
      Token(type: .greaterEqual, lexeme: ">=", line: 1),
      Token(type: .lessEqual, lexeme: "<=", line: 1),
      Token(type: .eof, lexeme: "", line: 1),
    ]

    switch result {
    case .success(let tokens):
      try #require(tokens.count == expectedTokens.count)
      for (index, token) in tokens.enumerated() {
        #expect(token == expectedTokens[index])
      }
    case .failure(let errors):
      try #require(errors.errors.count == 0)
    }

  }

  @Test("Scan for comment tokens", arguments: ["//comment\n"])
  func scanSlashAndCommentTokens(source: String) throws {
    let scanner = Scanner(source: source)
    let result = scanner.scanTokens()

    let expectedTokens = [
      Token(type: .eof, lexeme: "", line: 1)
    ]

    switch result {
    case .success(let tokens):
      try #require(tokens.count == expectedTokens.count)
      for (index, token) in tokens.enumerated() {
        #expect(token == expectedTokens[index])
      }
    case .failure(let errors):
      try #require(errors.errors.count == 0)
    }

  }

}
