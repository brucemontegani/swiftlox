// Tests/SwiftLoxTests/ScannerTests.swift

import Testing
import XCTest

@testable import SwiftLox

struct ScannerTests {
  @Test("Scan Single character tokens", arguments: ["(){},.-+;*", "( ) { } , . - + ; *"])
  func scanSingleCharTokensWithSpaces(source: String) throws {
    let scanner = Scanner(source: source)
    let (tokens, errors) = scanner.scanTokens()

    let expectedTokenTypes: [TokenType] = [
      .leftParen, .rightParen,
      .leftBrace, .rightBrace,
      .comma, .dot, .minus, .plus,
      .semiColon, .star, .eof,
    ]

    try #require(errors.count == 0)
    try #require(tokens.count == expectedTokenTypes.count)
    for (index, token) in tokens.enumerated() {
      #expect(token.type == expectedTokenTypes[index])
    }

  }
}
