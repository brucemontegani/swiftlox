public enum TokenType: Equatable {
  case leftParen, rightParen
  case leftBrace, rightBrace
  case comma, dot, minus, plus, semiColon, slash, star
  case bang
  case bangEqual
  case equal, equalEqual
  case greater, greaterEqual
  case less, lessEqual
  case comment
  case string(String)
  case number(NumberLiteral)
  case eof
  // We'll add more token types as needed

  var rawValue: String {
    switch self {
    case .leftParen: return "("
    case .rightParen: return ")"
    case .leftBrace: return "{"
    case .rightBrace: return "}"
    case .comma: return ","
    case .dot: return "."
    case .minus: return "-"
    case .plus: return "+"
    case .semiColon: return ";"
    case .slash: return "/"
    case .star: return "*"
    case .less: return "<"
    case .equal: return "="
    case .greater: return ">"
    case .bang: return "!"
    case .lessEqual: return "<="
    case .equalEqual: return "=="
    case .greaterEqual: return ">="
    case .bangEqual: return "!="
    case .eof: return "eof"
    case .comment: return "comment"
    case .string: return "string"
    case .number: return "number"
    }
  }
}

public enum NumberLiteral: Equatable {
  case integer(Int)
  case floatingPoint(Double)
}

public struct Token: CustomStringConvertible, Equatable {
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
    // case .number(let value):
    //   switch value {
    //   case .integer(let intValue):
    //     return "number ( \(lexeme) ) \(intValue)"
    //   case .floatingPoint(let doubleValue):
    //     return "number ( \(lexeme) ) \(doubleValue)"
    //   }
    case .eof:
      return "eof ( \(lexeme) )"
    default:
      return "\(type) ( \(lexeme) )"
    }

  }
}
