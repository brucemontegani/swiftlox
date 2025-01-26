// Sources/SwiftLox/Scanner.swift

public class Scanner {
  private let source: String
  private var tokens: [Token] = []
  private var tokenStartPos = 0
  private var sourceCurrentPos = 0
  private var line = 1
  private var errors: [ScannerError] = []
  private var current: String.Index
  private var start: String.Index

  public struct ScannerError: Error {
    public let line: Int
    public let message: String
  }

  public init(source: String) {
    self.source = source
    self.current = source.startIndex
    self.start = source.startIndex
  }

  public func scanTokens() -> (tokens: [Token], errors: [ScannerError]) {
    while !isAtEnd {
      start = current
      scanToken()
    }

    tokens.append(Token(type: .eof, lexeme: "", line: line))
    return (tokens, errors)
  }

  private func scanToken() {
    let c = advance()

    switch c {
    case "(": addToken(.leftParen)
    case ")": addToken(.rightParen)
    case "{": addToken(.leftBrace)
    case "}": addToken(.rightBrace)
    case ",": addToken(.comma)
    case ".": addToken(.dot)
    case "-": addToken(.minus)
    case "+": addToken(.plus)
    case ";": addToken(.semiColon)
    case "*": addToken(.star)
    case " ", "\t": break
    default:
      errors.append(
        ScannerError(line: line, message: "unexpected character: \(c)")
      )
    }
  }

  private func advance() -> Character {
    let character = source[current]
    current = source.index(after: current)  // Move to the next character
    return character
  }

  private func nextCharacter() -> Character {
     return source[source.index(after: current)]
  }

  private func addToken(_ type: TokenType) {
    let text =
      String(source[start..<current])

    tokens.append(Token(type: type, lexeme: text, line: line))
  }

  private var isAtEnd: Bool {
    return current == source.endIndex
  }
}
