import strutils
import re
import tables

var code = readFile("amostra-correcao2.nim")

# armazena informação de indentação antes de processar
let originalLines = code.split("\n")
var indentations: seq[int] = @[]

# conta os espaços no início de cada linha
for line in originalLines:
    var indent = 0
    while indent < line.len and line[indent] == ' ':
        indent += 1
    indentations.add(indent)

# remove as indentações do início das linhas
code = ""
for i, line in originalLines:
    let indent = indentations[i]
    let content = if indent < line.len: line[indent..^1] else: ""
    if i > 0:
        code &= "\n"
    code &= content

# tratamento de símbolos
for c in [":", ",", ";", "(", ")", "[", "]", "*", "."]:
    code = code.replace(c, " " & c & " ")

# tratamento de quebras de linha com marcador de indentação
var newCode = "LINE_INDENT" & $indentations[0] & " "
let codeLines = code.split("\n")

for i, line in codeLines:
    newCode &= line
    if i < codeLines.len - 1:
        newCode &= " NEWLINE LINE_INDENT" & $indentations[i+1] & " "

code = newCode

# saída
let output = open("tokens_entrada.txt", fmWrite)

var tokens = code.splitWhitespace()

# recompor números floats (NUM . NUM)
var processedTokens: seq[string] = @[]
var i = 0

while i < tokens.len:
    if i + 2 < tokens.len and tokens[i+1] == "." and tokens[i].match(re"^[0-9]+$") and tokens[i+2].match(re"^[0-9]+$"):
        processedTokens.add(tokens[i] & "." & tokens[i+2])
        i += 3
    elif i + 2 < tokens.len and tokens[i] == "." and tokens[i+1].match(re"^[0-9]+$") and tokens[i+2].match(re"^[eE][+-]?[0-9]+$"):
        processedTokens.add("." & tokens[i+1] & tokens[i+2])
        i += 3
    else:
        processedTokens.add(tokens[i])
        i += 1

tokens = processedTokens
i = 0

# mapa de palavras-chave
let keywordMap = {
    "type": "KEYWORD_TYPE",
    "object": "KEYWORD_OBJECT",
    "proc": "KEYWORD_PROC",

    "if": "KEYWORD_IF",
    "elif": "KEYWORD_ELIF",
    "else": "KEYWORD_ELSE",
    "while": "KEYWORD_WHILE",
    "return": "KEYWORD_RETURN",

    "var": "KEYWORD_VAR",
    "let": "KEYWORD_LET",

    "int": "KEYWORD_INT",
    "float": "KEYWORD_FLOAT",
    "bool": "KEYWORD_BOOL",
    "string": "KEYWORD_STRING",

    "true": "KEYWORD_TRUE",
    "false": "KEYWORD_FALSE",

    "seq": "KEYWORD_SEQ",
    "array": "KEYWORD_ARRAY",

    "not": "KEYWORD_NOT",
    "and": "KEYWORD_AND",
    "or": "KEYWORD_OR",
    "mod": "KEYWORD_MOD"
}.toTable()

# controle de escopo por indentação
var indentStack: seq[int] = @[0]

# laço principal de tokenização
while i < tokens.len:

    let token = tokens[i]

    # tratamento de quebra de linha
    if token == "NEWLINE":
        output.writeLine("NEWLINE")

    # tratamento de indentação / escopo
    elif token.startsWith("LINE_INDENT"):
        let indentStr = token.replace("LINE_INDENT", "")
        let currentIndent = parseInt(indentStr)
        let lastIndent = indentStack[^1]

        if currentIndent > lastIndent:
            indentStack.add(currentIndent)
            output.writeLine("INDENT")
        elif currentIndent < lastIndent:
            while indentStack.len > 1 and indentStack[^1] > currentIndent:
                discard indentStack.pop()
                output.writeLine("DEDENT")

    # tratamento de strings
    elif token.startsWith("\""):

        var strToken = token

        while not strToken.endsWith("\"") and i+1 < tokens.len:
            i += 1
            strToken &= " " & tokens[i]

        output.writeLine("STRING")

    else:

        case token
        of ":":
            output.writeLine("COLON")

        of ",":
            output.writeLine("COMMA")

        of ".":
            output.writeLine("DOT")

        of ";":
            output.writeLine("SEMICOLON")

        of "(":
            output.writeLine("LPAREN")

        of ")":
            output.writeLine("RPAREN")

        of "[":
            output.writeLine("LBRACKET")

        of "]":
            output.writeLine("RBRACKET")

        of "=":
            output.writeLine("ASSIGN")

        of "+":
            output.writeLine("PLUS")

        of "-":
            output.writeLine("MINUS")

        of "*":
            output.writeLine("MUL")

        of "/":
            output.writeLine("DIV")

        of "%":
            output.writeLine("MOD")

        of "<":
            output.writeLine("LT")

        of ">":
            output.writeLine("GT")

        of "<=":
            output.writeLine("LE")

        of ">=":
            output.writeLine("GE")

        of "==":
            output.writeLine("EQ")

        of "!=":
            output.writeLine("NE")

        of "+=":
            output.writeLine("PLUS_ASSIGN")

        of "-=":
            output.writeLine("MINUS_ASSIGN")

        else:
            if token.match(re"^([0-9]+\.[0-9]*|\.[0-9]+)([eE][+-]?[0-9]+)?$"):
                output.writeLine("NUM_FLOAT")

            elif token.match(re"^[0-9]+([eE][+-]?[0-9]+)?$"):
                output.writeLine("NUM_INT")

            elif token.match(re"^[a-zA-Z][a-zA-Z0-9_]*$"):
                if token in keywordMap:
                    output.writeLine(keywordMap[token], "")
                else:
                    output.writeLine("ID")

    i += 1

# fechar escopos restantes no final do arquivo
while indentStack.len > 1:
    discard indentStack.pop()
    output.writeLine("DEDENT")

output.close()

echo "Tokenização concluída!"