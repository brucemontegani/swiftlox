public enum TokenType: CustomStringConvertible, Equatable {
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
  case identifier
  case eof
  case keyword(Keyword)
  // Keywords

  var rawValue: String {
    switch self {
    case .leftParen: return "LEFT_PAREN"
    case .rightParen: return "RIGHT_PAREN"
    case .leftBrace: return "LEFT_BRACE"
    case .rightBrace: return "RIGHT_BRACE"
    case .comma: return "COMMA"
    case .dot: return "DOT"
    case .minus: return "MINUS"
    case .plus: return "PLUS"
    case .semiColon: return "SEMICOLON"
    case .slash: return "SLASH"
    case .star: return "STAR"
    case .less: return "LESS"
    case .equal: return "EQUAL"
    case .greater: return "GREATER"
    case .bang: return "BANG"
    case .lessEqual: return "BANG_EQUAL"
    case .equalEqual: return "EQUAL_EQUAL"
    case .greaterEqual: return "GREATER_EQUAL"
    case .bangEqual: return "BANG_EQUAL"
    case .eof: return "EOF"
    case .comment: return ""
    case .string: return "STRING"
    case .number: return "NUMBER"
    case .identifier: return "IDENTIFIER"
    case .keyword: return "KEYWORD"
    }
  }

  public var description: String {
    switch self {
    case .number(let value):
      switch value {
      case .integer(let intValue):
        return "\(value.rawValue)(\(intValue))"
      case .floatingPoint(let doubleValue):
        return "\(value.rawValue)(\(doubleValue))"
      }
    case .keyword(let keyword):
      return "\(self.rawValue)(\(keyword.rawValue))"
    default:
      return self.rawValue
    }
  }
}

public enum Keyword: String, Equatable {
  case `and` = "AND"
  case `class` = "CLASS"
  case `else` = "ELSE"
  case `false` = "FALSE"
  case `for` = "FOR"
  case `fun` = "FUN"
  case `if` = "IF"
  case `or` = "OR"
  case `print` = "PRINT"
  case `return` = "RETURN"
  case `super` = "SUPER"
  case `this` = "THIS"
  case `true` = "TRUE"
  case `var` = "VAR"
  case `while` = "WHILE"
}

public enum NumberLiteral: Equatable {
  case integer(Int)
  case floatingPoint(Double)

  var rawValue: String {
    switch self {
    case .integer: return "INTEGER"
    case .floatingPoint: return "FLOATING_POINT"
    }
  }

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
    return "Type: \(type), Lexeme: \(lexeme), Line#: \(line)"
  }
}
