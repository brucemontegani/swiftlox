// Tests/SwiftLoxTests/lexerTests.swift

import Testing
import XCTest

@testable import SwiftLox

struct LexerTests {
  @Test(
    "Scan single character tokens with and without spaces",
    arguments: ["(){},.-+;*=!></", "( ) { } , . - + ; * = ! > < /"])
  func scanSingleOnlyCharTokens(source: String) throws {

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

    if let data = source.data(using: .utf8) {
      let lexer = Lexer(source: data)
      let (tokens, errors) = lexer.tokenize()

      try #require(tokens.count == expectedTokens.count)
      try #require(errors.count == 0)

    }
  }
  @Test("Scan Double character tokens", arguments: ["!= == >= <="])
  func scanSingleDoubleCharTokens(source: String) throws {

    let expectedTokens = [
      Token(type: .bangEqual, lexeme: "!=", line: 1),
      Token(type: .equalEqual, lexeme: "==", line: 1),
      Token(type: .greaterEqual, lexeme: ">=", line: 1),
      Token(type: .lessEqual, lexeme: "<=", line: 1),
      Token(type: .eof, lexeme: "", line: 1),
    ]

    if let data = source.data(using: .utf8) {
      let lexer = Lexer(source: data)
      let (tokens, errors) = lexer.tokenize()

      try #require(tokens.count == expectedTokens.count)
      try #require(errors.count == 0)

    }

  }

  @Test("Scan for comment tokens", arguments: ["//comment\n"])
  func scanSlashAndCommentTokens(source: String) throws {
    if let data = source.data(using: .utf8) {
      let lexer = Lexer(source: data)
      let (tokens, errors) = lexer.tokenize()

      try #require(tokens.count == 1)
      try #require(errors.count == 0)

      #expect(tokens[0].type == .eof)
      #expect(tokens[0].lexeme == "")
      #expect(tokens[0].line == 2)
    }

  }

  @Test("Scan for new line. Should increase line number by 1")
  func scanNewLine() throws {

    let source = "\n\n"
    if let data = source.data(using: .utf8) {
      let lexer = Lexer(source: data)
      let (tokens, errors) = lexer.tokenize()

      try #require(tokens.count == 1)
      try #require(errors.count == 0)

      #expect(tokens[0].type == .eof)
      #expect(tokens[0].lexeme == "")
      #expect(tokens[0].line == 3)
    }

  }

  @Test("Scan for a string")
  func scanString() throws {
    let source = "\"This is a string\"\n\"and this is another string\""
    if let data = source.data(using: .utf8) {
      let lexer = Lexer(source: data)
      let (tokens, errors) = lexer.tokenize()

      try #require(tokens.count == 3)
      try #require(errors.count == 0)

      #expect(tokens[0].type == .string("This is a string"))
      #expect(tokens[0].lexeme == "This is a string")
      #expect(tokens[0].line == 1)
      #expect(tokens[1].type == .string("and this is another string"))
      #expect(tokens[1].lexeme == "and this is another string")
      #expect(tokens[1].line == 2)
    }

  }

  @Test(
    "Scan for a integer number and floating point number",
    arguments: ["1234 123.45"])
  func scanNumber(source: String) throws {
    if let data = source.data(using: .utf8) {
      let lexer = Lexer(source: data)
      let (tokens, errors) = lexer.tokenize()

      try #require(tokens.count == 3)
      try #require(errors.count == 0)

      #expect(tokens[0].type == .number(.integer(1234)))
      #expect(tokens[0].lexeme == "1234")
      #expect(tokens[0].line == 1)
      #expect(tokens[1].type == .number(.floatingPoint(123.45)))
      #expect(tokens[1].lexeme == "123.45")
      #expect(tokens[1].line == 1)
      #expect(tokens[2].type == .eof)
      #expect(tokens[2].lexeme == "")
      #expect(tokens[2].line == 1)
    }

  }

  @Test(
    "Scan for an identifier",
    arguments: ["Abc9_R abcD8 _1ABC"])
  func scanIdentifier(source: String) throws {
    if let data = source.data(using: .utf8) {
      let lexer = Lexer(source: data)
      let (tokens, errors) = lexer.tokenize()

      try #require(tokens.count == 4)
      try #require(errors.count == 0)

      #expect(tokens[0].type == .identifier)
      #expect(tokens[0].lexeme == "Abc9_R")
      #expect(tokens[0].line == 1)
      #expect(tokens[1].type == .identifier)
      #expect(tokens[1].lexeme == "abcD8")
      #expect(tokens[1].line == 1)
      #expect(tokens[2].type == .identifier)
      #expect(tokens[2].lexeme == "_1ABC")
      #expect(tokens[2].line == 1)
    }

  }

  @Test(
    "Scan for a keyword",
    arguments: ["and for return"])
  func scanKeyword(source: String) throws {
    if let data = source.data(using: .utf8) {
      let lexer = Lexer(source: data)
      let (tokens, errors) = lexer.tokenize()

      try #require(tokens.count == 4)
      try #require(errors.count == 0)

      #expect(tokens[0].type == .keyword(.and))
      #expect(tokens[0].lexeme == "and")
      #expect(tokens[0].line == 1)
      #expect(tokens[1].type == .keyword(.for))
      #expect(tokens[1].lexeme == "for")
      #expect(tokens[1].line == 1)
      #expect(tokens[2].type == .keyword(.return))
      #expect(tokens[2].lexeme == "return")
      #expect(tokens[2].line == 1)
    }

  }

  @Test func lexerBenchmark() async throws {
    let source = try! String(contentsOfFile: "large_token_input.txt", encoding: .utf8)
    if let data = source.data(using: .utf8) {
      let lexer = Lexer(source: data)

      let start1 = ContinuousClock.now
      _ = lexer.tokenize()
      let end1 = ContinuousClock.now

      let time1 = start1.duration(to: end1)

      print("Optimized lexer Time: \(time1)")

    }

  }
}
