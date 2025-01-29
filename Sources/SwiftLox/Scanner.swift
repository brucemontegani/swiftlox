// Sources/SwiftLox/Scanner.swift

public class Scanner {
  private let source: String
  private var line = 1
  private var current: String.Index
  private var start: String.Index

  public init(source: String) {
    self.source = source
    self.current = source.startIndex
    self.start = source.startIndex
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
    case "!": token = createToken(type: match("=") ? .bangEqual : .bang)
    case "=": token = createToken(type: match("=") ? .equalEqual : .equal)
    case ">": token = createToken(type: match("=") ? .greaterEqual : .greater)
    case "<": token = createToken(type: match("=") ? .lessEqual : .less)
    case "/": token = createToken(type: .star)
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

  private func createToken(type: TokenType) -> Token {
    return Token(type: type, lexeme: String(source[start..<current]), line: line)
  }

  private func isAtEnd() -> Bool {
    return current >= source.endIndex
  }

}
