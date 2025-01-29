// Sources/SwiftLox/Scanner.swift

public class Scanner {
  private let source: String
  private var line = 1
  private var current: String.Index

  public init(source: String) {
    self.source = source
    self.current = source.startIndex
  }

  public struct ScannerErrors: Error {
    public let errors: [ScanError]
  }

  public struct ScanError: Error {
    public let line: Int
    public let message: String
  }

  public func scanTokens() -> Result<[Token], ScannerErrors> {
    var tokens: [Token] = []
    var errors: [ScanError] = []

    while !isAtEnd() {
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
    case "(": token = Token(type: .leftParen, lexeme: "(", line: line)
    case ")": token = Token(type: .rightParen, lexeme: ")", line: line)
    case "{": token = Token(type: .leftBrace, lexeme: "{", line: line)
    case "}": token = Token(type: .rightBrace, lexeme: "}", line: line)
    case ",": token = Token(type: .comma, lexeme: ",", line: line)
    case ".": token = Token(type: .dot, lexeme: ".", line: line)
    case "-": token = Token(type: .minus, lexeme: "-", line: line)
    case "+": token = Token(type: .plus, lexeme: "+", line: line)
    case ";": token = Token(type: .semiColon, lexeme: ";", line: line)
    case "*": token = Token(type: .star, lexeme: "*", line: line)
    case "!":
      token =
        match("=")
        ? Token(type: .bangEqual, lexeme: "!=", line: line)
        : Token(type: .bang, lexeme: "!", line: line)
    case "=":
      token =
        match("=")
        ? Token(type: .equalEqual, lexeme: "==", line: line)
        : Token(type: .equal, lexeme: "=", line: line)
    case ">":
      token =
        match("=")
        ? Token(type: .greaterEqual, lexeme: ">=", line: line)
        : Token(type: .greater, lexeme: ">", line: line)
    case "<":
      token =
        match("=")
        ? Token(type: .lessEqual, lexeme: "<=", line: line)
        : Token(type: .less, lexeme: "<", line: line)
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

  private func advance() -> Character {
    let char = source[current]
    current = source.index(after: current)
    return char
  }

  private func isAtEnd() -> Bool {
    return current >= source.endIndex
  }

}
