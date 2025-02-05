// Sources/SwiftLox/Scanner.swift
import FoundationEssentials

public class Lexer {
  private let source: Data
  private var line = 1
  private var current = 0
  private var start = 0

  public init(source: Data) {
    self.source = source
  }

  public struct LexerErrors: Error, Equatable {
    public let errors: [TokenizeError]
  }

  public struct TokenizeError: Error, Equatable {
    public let line: Int
    public let message: String
  }

  public func tokenize() -> ([Token], [TokenizeError]) {
    var tokens: [Token] = []
    var errors: [TokenizeError] = []

    while !isAtEnd() {
      start = current
      let result = scanToken()

      switch result {
      case .success(let token):
        if let token {
          tokens.append(token)
        }

      case .failure(let error):
        errors.append(error)
      }

    }

    tokens.append(Token(type: .eof, lexeme: "", line: line))
    return (tokens, errors)
  }

  private func scanToken() -> Result<Token?, TokenizeError> {
    let byte = advance()

    // var token: Token? = nil

    switch byte {
    case UInt8(ascii: "("): return .success(createToken(type: .leftParen))
    case UInt8(ascii: ")"): return .success(createToken(type: .rightParen))
    case UInt8(ascii: "{"): return .success(createToken(type: .leftBrace))
    case UInt8(ascii: "}"): return .success(createToken(type: .rightBrace))
    case UInt8(ascii: ","): return .success(createToken(type: .comma))
    case UInt8(ascii: "."): return .success(createToken(type: .dot))
    case UInt8(ascii: "-"): return .success(createToken(type: .minus))
    case UInt8(ascii: "+"): return .success(createToken(type: .plus))
    case UInt8(ascii: ";"): return .success(createToken(type: .semiColon))
    case UInt8(ascii: "*"): return .success(createToken(type: .star))
    case UInt8(ascii: "!"):
      return match(UInt8(ascii: "="))
        ? .success(createToken(type: .bangEqual)) : .success(createToken(type: .bang))
    case UInt8(ascii: "="):
      return match(UInt8(ascii: "="))
        ? .success(createToken(type: .equalEqual)) : .success(createToken(type: .equal))
    case UInt8(ascii: ">"):
      return match(UInt8(ascii: "="))
        ? .success(createToken(type: .greaterEqual)) : .success(createToken(type: .greater))
    case UInt8(ascii: "<"):
      return match(UInt8(ascii: "="))
        ? .success(createToken(type: .lessEqual)) : .success(createToken(type: .less))
    case UInt8(ascii: "\""): return string()
    case UInt8(ascii: "/"): return isComment() ? .success(nil) : .success(createToken(type: .slash))
    case let b where b.isNumber: return .success(number())
    case let b where b.isAlpha: return .success(identifierOrKeyword())
    case let b where b.isWhitespace: return .success(nil)
    case let b where b.isNewline:
      line += 1
      return .success(nil)
    default:
      return .failure(
        TokenizeError(
          line: line, message: "Unexpected character: \(Character(Unicode.Scalar(byte)))"))
    }
  }

  private func match(_ expected: UInt8) -> Bool {
    guard !isAtEnd() && source[current] == expected else { return false }
    _ = advance()
    return true
  }

  private func peek() -> UInt8? {
    if isAtEnd() { return nil }
    return source[current]
  }

  private func peekNext() -> UInt8? {
    if isAtEnd() { return nil }
    return source[current + 1]
  }

  private func advance() -> UInt8 {
    let byte = source[current]
    current += 1
    return byte
  }

  private func isComment() -> Bool {
    if match(UInt8(ascii: "/")) {  // Skip comments
      while let next = peek(), !next.isNewline {
        _ = advance()
      }
      return true
    }
    return false
  }

  private func string() -> Result<Token?, TokenizeError> {
    while let next = peek(), next != UInt8(ascii: "\"") {
      if next.isNewline {
        line += 1
      }
      _ = advance()
    }

    if isAtEnd() {
      return .failure(TokenizeError(line: line, message: "unterminated string"))
    }

    _ = advance()

    let startPos = start + 1
    let endPos = current - 1

    let numberOfChars = endPos - startPos
    if numberOfChars == 0 {
      return .success(nil)
    }

    let text = String(bytes: source[startPos..<endPos], encoding: .utf8) ?? ""
    return .success(Token(type: .string(text), lexeme: text, line: line))

  }

  private func number() -> Token {
    while let next = peek(), next.isNumber {
      _ = advance()
    }

    var isInteger = true

    if let next = peek(), next == UInt8(ascii: ".") {
      if let peekNext = peekNext(), peekNext.isNumber {
        isInteger = false
        _ = advance()
        while let next = peek(), next.isNumber {
          _ = advance()
        }
      }
    }

    let valueAsString = String(bytes: source[start..<current], encoding: .utf8) ?? ""
    let tokenType = TokenType.number(
      isInteger ? .integer(Int(valueAsString)!) : .floatingPoint(Double(valueAsString)!))

    return createToken(type: tokenType)
  }

  private func identifierOrKeyword() -> Token {
    while let next = peek(), next.isAlphaNumeric {
      _ = advance()
    }

    let lexeme = String(bytes: source[start..<current], encoding: .utf8) ?? ""
    if let keyword = Keyword(rawValue: lexeme.uppercased()) {
      return Token(type: .keyword(keyword), lexeme: lexeme, line: line)
    }
    return Token(type: .identifier, lexeme: lexeme, line: line)
  }

  private func createToken(type: TokenType) -> Token {
    return Token(
      type: type, lexeme: String(bytes: source[start..<current], encoding: .utf8) ?? "", line: line)
  }

  private func isAtEnd() -> Bool {
    return current >= source.count
  }

}

extension UInt8 {
  var isAlpha: Bool {
    return (self >= UInt8(ascii: "A") && self <= UInt8(ascii: "Z"))
      || (self >= UInt8(ascii: "a") && self <= UInt8(ascii: "z")) || self == UInt8(ascii: "_")
  }

  var isNumber: Bool {
    return self >= UInt8(ascii: "0") && self <= UInt8(ascii: "9")
  }

  var isWhitespace: Bool {
    return self == UInt8(ascii: " ") || self == UInt8(ascii: "\t") || self == UInt8(ascii: "\r")
  }

  var isNewline: Bool {
    return self == UInt8(ascii: "\n")
  }

  var isAlphaNumeric: Bool {
    return self.isAlpha || self.isNumber
  }
}
