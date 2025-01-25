public enum TokenType: Equatable {
  case leftParen, rightParen, leftBrace, rightBrace
  case comma, dot, minus, plus, semiColon, slash, star
  case number(NumberLiteral)
  case eof
  // We'll add more token types as needed
}

public enum NumberLiteral: Equatable {
  case integer(Int)
  case floatingPoint(Double)
}

public struct Token: CustomStringConvertible {
  public let type: TokenType
  public let lexeme: String
  public let line: Int

  public init(type: TokenType, lexeme: String, line: Int) {
    self.type = type
    self.lexeme = lexeme
    self.line = line
  }

  public var description: String {
    switch type {
    case .number(let value):
      switch value {
      case .integer(let intValue):
        return "number ( \(lexeme) ) \(intValue)"
      case .floatingPoint(let doubleValue):
        return "number ( \(lexeme) ) \(doubleValue)"
      }
    case .eof:
      return "eof ( \(lexeme) )"
    default:
      return "\(type) ( \(lexeme) )"
    }

  }
}
