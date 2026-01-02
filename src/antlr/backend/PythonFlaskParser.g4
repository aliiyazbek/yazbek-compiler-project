parser grammar PythonFlaskParser;

options {
    tokenVocab = PythonFlaskLexer;
}

// Program entry point
program: NEWLINE* (statement NEWLINE+)* statement? NEWLINE* EOF;

// Statements
    statement
        : importStatement
        | assignmentStatement
        | decoratedFunction
        | functionDefinition
        | ifStatement
        | forStatement
        | returnStatement
        | expressionStatement
        ;

// Import statement: from flask import Flask, render_template, ...
importStatement
    : FROM IDENTIFIER IMPORT importList
    ;

importList
    : IDENTIFIER (COMMA IDENTIFIER)*
    ;

// Assignment: variable = expression
assignmentStatement
    : IDENTIFIER ASSIGN expression
    ;

// Function definition
functionDefinition
    : DEF IDENTIFIER LPAREN parameterList? RPAREN COLON NEWLINE functionBody
    ;

parameterList
    : parameter (COMMA parameter)*
    ;

parameter
    : IDENTIFIER
    ;

functionBody
    : (statement NEWLINE+)+
    ;

// Decorated function (Flask routes)
decoratedFunction
    : (decorator NEWLINE+)+ functionDefinition
    ;

decorator
    : AT expression
    ;

// If statement
ifStatement
    : IF expression COLON NEWLINE (statement NEWLINE+)+
      elifStatement*
      elseStatement?
    ;

elifStatement
    : ELIF expression COLON NEWLINE (statement NEWLINE+)+
    ;

elseStatement
    : ELSE COLON NEWLINE (statement NEWLINE+)+
    ;

// For loop
forStatement
    : FOR IDENTIFIER IN expression COLON NEWLINE (statement NEWLINE+)+
    ;

// Return statement
returnStatement
    : RETURN expression?
    ;

// Expression statement
expressionStatement
    : expression
    ;

// Expressions
expression
    : primary                                           # PrimaryExpression
    | expression DOT IDENTIFIER                         # MemberAccessExpression
    | expression LBRACKET expression RBRACKET           # IndexAccessExpression
    | expression LPAREN argumentList? RPAREN            # FunctionCallExpression
    | NOT expression                                    # NotExpression
    | expression op=(STAR | SLASH) expression           # MultiplicativeExpression
    | expression op=(PLUS | MINUS) expression           # AdditiveExpression
    | expression op=(LT | GT | LTE | GTE) expression    # ComparisonExpression
    | expression op=(EQ | NEQ) expression               # EqualityExpression
    | expression AND expression                         # AndExpression
    | expression OR expression                          # OrExpression
    ;

primary
    : IDENTIFIER                                        # IdentifierPrimary
    | STRING                                            # StringLiteral
    | INTEGER                                           # IntegerLiteral
    | FLOAT                                             # FloatLiteral
    | TRUE                                              # BooleanLiteral
    | FALSE                                             # BooleanLiteral
    | NONE                                              # NoneLiteral
    | listLiteral                                       # ListPrimary
    | dictLiteral                                       # DictPrimary
    | LPAREN expression RPAREN                          # ParenthesizedExpression
    ;

// List literal: [1, 2, 3]
listLiteral
    : LBRACKET (expression (COMMA expression)*)? RBRACKET
    ;

// Dictionary literal: {"key": value, ...}
dictLiteral
    : LBRACE (keyValuePair (COMMA keyValuePair)*)? RBRACE
    ;

keyValuePair
    : (STRING | IDENTIFIER) COLON expression
    ;

// Function arguments
argumentList
    : argument (COMMA argument)*
    ;

argument
    : IDENTIFIER ASSIGN expression  # KeywordArgument
    | expression                    # PositionalArgument
    ;
