import strutils
import re

var code = readFile("compil_lab1_amostra_B_Andre_Felipe_de_Oliveira_Lopes.nim")

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
let output = open("compil_lab1_resposta_C_Andre_Felipe_de_Oliveira_Lopes.txt", fmWrite)

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

        output.writeLine("STRING ", strToken)

    else:

        case token
        of ":":
            output.writeLine("COLON ", token)

        of ",":
            output.writeLine("COMMA ", token)

        of ".":
            output.writeLine("DOT ", token)

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
            output.writeLine("MUL ", token)

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
            if token.match(re"^([0-9]+\.[0-9]*|\.[0-9]+)([eE][+-]?[0-9]+)?$"):
                output.writeLine("NUM_FLOAT ", token)

            elif token.match(re"^[0-9]+([eE][+-]?[0-9]+)?$"):
                output.writeLine("NUM_INT ", token)

            elif token.match(re"^[a-zA-Z][a-zA-Z0-9_]*$"):
                if token in ["type","object","proc","if","int","elif","else","while","return","var","not","and","or","mod"]:
                    output.writeLine("KEYWORD ", token)
                else:
                    output.writeLine("ID ", token)

    i += 1

# fechar escopos restantes no final do arquivo
while indentStack.len > 1:
    discard indentStack.pop()
    output.writeLine("DEDENT")

output.close()

echo "Tokenização concluída!"