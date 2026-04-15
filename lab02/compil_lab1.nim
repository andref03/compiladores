import strutils
import re
import tables

var code = readFile("amostra-correcao2.nim")

# armazena informação de indentação antes de processar
let originalLines = code.split("\n")
var indentations: seq[int] = @[]

# conta os espaços no início de cada linha
# linhas vazias não devem alterar a pilha de indentação
for line in originalLines:
    if line.strip().len == 0:
        indentations.add(-1)
        continue

    var indent = 0
    while indent < line.len and line[indent] == ' ':
        indent += 1
    indentations.add(indent)

# remove as indentações do início das linhas
code = ""
for i, line in originalLines:
    let indent = indentations[i]
    let content =
        if indent < 0:
            ""
        elif indent < line.len:
            line[indent..^1]
        else:
            ""
    if i > 0:
        code &= "\n"
    code &= content

# tratamento de símbolos
for c in [":", ",", ";", "(", ")", "[", "]", "*", ".", "@", "^"]:
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

# recompor números floats e notação científica
var processedTokens: seq[string] = @[]
var i = 0

while i < tokens.len:
    if i + 2 < tokens.len and
       tokens[i+1] == "." and
       tokens[i].match(re"^[0-9]+$") and
       tokens[i+2].match(re"^[0-9]+([eE][+-]?[0-9]+)?$"):
        processedTokens.add(tokens[i] & "." & tokens[i+2])
        i += 3
    elif i + 2 < tokens.len and
         tokens[i] == "." and
         tokens[i+1].match(re"^[0-9]+$") and
         tokens[i+2].match(re"^[eE][+-]?[0-9]+$"):
        processedTokens.add("." & tokens[i+1] & tokens[i+2])
        i += 3
    elif i + 1 < tokens.len and
         tokens[i].match(re"^[0-9]+$") and
         tokens[i+1].match(re"^[eE][+-]?[0-9]+$"):
        processedTokens.add(tokens[i] & tokens[i+1])
        i += 2
    elif tokens[i].match(re"^[+-][a-zA-Z][a-zA-Z0-9_]*$"):
        processedTokens.add($tokens[i][0])
        processedTokens.add(tokens[i][1..^1])
        i += 1
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
    "inc": "KEYWORD_INC",
    "dec": "KEYWORD_DEC",

    "int": "KEYWORD_INT",
    "int64": "KEYWORD_INT64",
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
    "mod": "KEYWORD_MOD",
    "div": "KEYWORD_DIV"
}.toTable()

# controle de escopo por indentação
var indentStack: seq[int] = @[0]

# laço principal de tokenização
while i < tokens.len:

    let token = tokens[i]

    # tratamento de quebra de linha
    if token == "NEWLINE":
        output.writeLine("NEWLINE \\n")

    # tratamento de indentação / escopo
    elif token.startsWith("LINE_INDENT"):
        let indentStr = token.replace("LINE_INDENT", "")
        let currentIndent = parseInt(indentStr)
        if currentIndent < 0:
            i += 1
            continue

        let lastIndent = indentStack[^1]

        if currentIndent > lastIndent:
            indentStack.add(currentIndent)
            output.writeLine("INDENT INDENT")
        elif currentIndent < lastIndent:
            while indentStack.len > 1 and indentStack[^1] > currentIndent:
                discard indentStack.pop()
                output.writeLine("DEDENT DEDENT")

    # tratamento de strings
    elif token.startsWith("\""):

        var strToken = token

        while not strToken.endsWith("\"") and i+1 < tokens.len:
            i += 1
            strToken &= " " & tokens[i]

        output.writeLine("STRING ", strToken)

    else:

        case token
        of ":":
            output.writeLine("COLON ", token)

        of ",":
            output.writeLine("COMMA ", token)

        of ".":
            output.writeLine("DOT ", token)

        of "@":
            output.writeLine("AT ", token)

        of ";":
            output.writeLine("SEMICOLON ", token)

        of "(":
            output.writeLine("LPAREN ", token)

        of ")":
            output.writeLine("RPAREN ", token)

        of "[":
            output.writeLine("LBRACKET ", token)

        of "]":
            output.writeLine("RBRACKET ", token)

        of "=":
            output.writeLine("ASSIGN ", token)

        of "+":
            output.writeLine("PLUS ", token)

        of "-":
            output.writeLine("MINUS ", token)

        of "*":
            output.writeLine("MULT ", token)

        of "^":
            output.writeLine("CARET ", token)

        of "/":
            output.writeLine("DIV ", token)

        of "%":
            output.writeLine("MOD ", token)

        of "<":
            output.writeLine("LT ", token)

        of ">":
            output.writeLine("GT ", token)

        of "<=":
            output.writeLine("LE ", token)

        of ">=":
            output.writeLine("GE ", token)

        of "==":
            output.writeLine("EQ ", token)

        of "!=":
            output.writeLine("NE ", token)

        of "+=":
            output.writeLine("PLUS_ASSIGN ", token)

        of "-=":
            output.writeLine("MINUS_ASSIGN ", token)

        else:
            if token.match(re"^(([0-9]+\.[0-9]*)|(\.[0-9]+)|([0-9]+))([eE][+-]?[0-9]+)?$") and
               (token.contains(".") or token.contains("e") or token.contains("E")):
                output.writeLine("NUM_FLOAT ", token)

            elif token.match(re"^[0-9]+$"):
                output.writeLine("NUM_INT ", token)

            elif token.match(re"^[a-zA-Z][a-zA-Z0-9_]*$"):
                if token in keywordMap:
                    if token in ["int", "int64", "float", "bool", "string"] and
                       i + 1 < tokens.len and tokens[i+1] == "(":
                        output.writeLine("ID ", token)
                    else:
                        output.writeLine(keywordMap[token], " ", token)
                else:
                    output.writeLine("ID ", token)

    i += 1

# fechar escopos restantes no final do arquivo
while indentStack.len > 1:
    discard indentStack.pop()
    output.writeLine("DEDENT DEDENT")

output.writeLine("$ $")

output.close()

echo "Tokenização concluída!"
