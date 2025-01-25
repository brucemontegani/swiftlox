import Testing

@testable import SwiftLox

struct TokenTests {
  @Test func tokenCreationWithNoAssociatedValue() {
    let token = Token(
      type: .leftParen,
      lexeme: "(",
      line: 1
    )

    #expect(token.type == .leftParen)
    #expect(token.lexeme == "(")
    #expect(token.line == 1)
  }

  @Test func tokenWithNumberIntLiteral() {
    let token = Token(
      type: .number(.integer(42)),
      lexeme: "42",
      line: 1
    )
    #expect(token.type == .number(.integer(42)))
    #expect(token.lexeme == "42")
    #expect(token.line == 1)
  }

  @Test func tokenWithNumberFloatLiteral() {
    let token = Token(
      type: .number(.floatingPoint(3.14)),
      lexeme: "3.14",
      line: 1
    )
    #expect(token.type == .number(.floatingPoint(3.14)))
    #expect(token.lexeme == "3.14")
    #expect(token.line == 1)
  }

  @Test func tokenDescription() {
    let token = Token(
      type: .number(.integer(42)),
      lexeme: "42",
      line: 1
    )

    #expect(token.description == "number ( 42 ) 42")

  }

}
