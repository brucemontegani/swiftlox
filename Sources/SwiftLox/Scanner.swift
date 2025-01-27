// Sources/SwiftLox/Scanner.swift

public class Scanner {
  private let source: String
  private var tokens: [Token] = []
  private var tokenStartPos = 0
  private var sourceCurrentPos = 0
  private var line = 1
  private var errors: [ScannerError] = []
  private var startToken: String.Index
  private var currentIndex: String.Index
  private var nextIndex: String.Index

  public struct ScannerError: Error {
    public let line: Int
    public let message: String
  }

  public init(source: String) {
    self.source = source
    self.startToken = source.startIndex
    self.currentIndex = source.startIndex
    self.nextIndex = source.startIndex
  }

  public func scanTokens() -> (tokens: [Token], errors: [ScannerError]) {
    while !isAtEnd {
      startToken = currentIndex
      scanToken()
    }

    tokens.append(Token(type: .eof, lexeme: "", line: line))
    return (tokens, errors)
  }

  private func scanToken() {
    let c = getCharacter(at: currentIndex)

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

    currentIndex = getNextIndex()

  }

  private func getNextIndex() -> String.Index {
    return source.index(after: currentIndex)
  }

  private func getCharacter(at index: String.Index) -> Character {
    return source[index]
  }

  private func addToken(_ type: TokenType) {
    let text =
      String(source[startToken...currentIndex])

    tokens.append(Token(type: type, lexeme: text, line: line))
  }

  private var isAtEnd: Bool {
    return currentIndex == source.endIndex
  }
}
