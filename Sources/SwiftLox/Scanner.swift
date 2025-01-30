// Sources/SwiftLox/Scanner.swift

public class Scanner {
  private let source: String
  private var line = 1
  private var current: String.Index
  private var start: String.Index
  // private var errors: [ScanError] = []

  public init(source: String) {
    self.source = source
    self.current = source.startIndex
    self.start = source.startIndex
  }

  public struct ScannerErrors: Error, Equatable {
    public let errors: [ScanError]
  }

  public struct ScanError: Error, Equatable {
    public let line: Int
    public let message: String
  }

  public func scanTokens() -> Result<[Token], ScannerErrors> {
    var tokens: [Token] = []
    var errors: [ScanError] = []

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

    if errors.isEmpty {
      return .success(tokens)
    } else {
      return .failure(ScannerErrors(errors: errors))
    }
  }

  private func scanToken() -> Result<Token?, ScanError> {
    let char = advance()

    var token: Token? = nil

    switch char {
    case "(": token = createToken(type: .leftParen)
    case ")": token = createToken(type: .rightParen)
    case "{": token = createToken(type: .leftBrace)
    case "}": token = createToken(type: .rightBrace)
    case ",": token = createToken(type: .comma)
    case ".": token = createToken(type: .dot)
    case "-": token = createToken(type: .minus)
    case "+": token = createToken(type: .plus)
    case ";": token = createToken(type: .semiColon)
    case "*": token = createToken(type: .star)
    case "\"": return string()
    case let c where c.isWholeNumber: token = number()
    case "/": token = isComment() ? nil : createToken(type: .slash)
    case let c where c.isAlpha: token = identifierOrKeyword()
    case "!": token = createToken(type: match("=") ? .bangEqual : .bang)
    case "=": token = createToken(type: match("=") ? .equalEqual : .equal)
    case ">": token = createToken(type: match("=") ? .greaterEqual : .greater)
    case "<": token = createToken(type: match("=") ? .lessEqual : .less)
    case let c where c.isNewline:
      line += 1
      return .success(nil)
    case let c where c.isWhitespace: return .success(nil)
    default:
      return .failure(ScanError(line: line, message: "unexpected character: \(char)"))
    }

    return .success(token)
  }

  private func match(_ expected: Character) -> Bool {
    guard !isAtEnd() && source[current] == expected else { return false }
    _ = advance()
    return true
  }

  private func peek() -> Character? {
    if isAtEnd() { return nil }
    return source[current]
  }

  private func peekNext() -> Character? {
    if isAtEnd() { return nil }
    return source[source.index(after: current)]
  }

  private func advance() -> Character {
    let char = source[current]
    current = source.index(after: current)
    return char
  }

  private func isComment() -> Bool {
    if match("/") {  // Skip comments
      while let next = peek(), !next.isNewline {
        _ = advance()
      }
      return true
    }
    return false
  }

  private func string() -> Result<Token?, ScanError> {
    while let next = peek(), next != "\"" {
      if next.isNewline {
        line += 1
      }
      _ = advance()
    }

    if isAtEnd() {
      return .failure(ScanError(line: line, message: "unterminated string"))
    }

    _ = advance()

    let stringStart = source.index(after: start)
    let stringEnd = source.index(before: current)
    let numberOfChars = source.distance(from: stringStart, to: stringEnd)
    if numberOfChars == 0 {
      return .success(nil)
    }

    let text = String(source[stringStart..<stringEnd])
    return .success(Token(type: .string(text), lexeme: text, line: line))

  }

  private func number() -> Token {
    while let next = peek(), next.isWholeNumber {
      _ = advance()
    }

    var isInteger = true

    if let next = peek(), next == "." {
      if let peekNext = peekNext(), peekNext.isWholeNumber {
        isInteger = false
        _ = advance()
        while let next = peek(), next.isWholeNumber {
          _ = advance()
        }
      }
    }

    let valueAsString = String(source[start..<current])
    let tokenType = TokenType.number(
      isInteger ? .integer(Int(valueAsString)!) : .floatingPoint(Double(valueAsString)!))

    return createToken(type: tokenType)
  }

  private func identifierOrKeyword() -> Token {
    while let next = peek(), next.isAlphaNumeric {
      _ = advance()
    }

    let lexeme = String(source[start..<current])
    if let keyword = Keyword(rawValue: lexeme.uppercased()) {
      return Token(type: .keyword(keyword), lexeme: lexeme, line: line)
    }
    return Token(type: .identifier, lexeme: lexeme, line: line)
  }

  private func createToken(type: TokenType) -> Token {
    return Token(type: type, lexeme: String(source[start..<current]), line: line)
  }

  private func isAtEnd() -> Bool {
    return current >= source.endIndex
  }

}

extension Character {
  public var isAlpha: Bool {
    return ("A"..."Z").contains(self) || ("a"..."z").contains(self) || self == "_"
  }

  public var isAlphaNumeric: Bool {
    return isAlpha || isWholeNumber
  }
}
