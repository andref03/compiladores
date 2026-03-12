import strutils
import re

var code = readFile("compil-lab1-amostra-B-Andre-Felipe-de-Oliveira-Lopes.nim")

# tratamento de símbolos para garantir que sejam isolados como tokens separados
# COLON
for c in [":", ",", ";", "(", ")", "[", "]"]:
  code = code.replace(c, " " & c & " ")

# NEWLINE
code = code.replace("\n", " NEWLINE ")

# saída
let output = open("compil-lab1-resposta-C-Andre-Felipe-de-Oliveira-Lopes.txt", fmWrite)

# laço principal de tokenização
for token in code.splitWhitespace():

    if token == "NEWLINE":
        output.writeLine("NEWLINE \\n")

    elif token == ":":
        output.writeLine("COLON ", token)

    elif token == ",":
        output.writeLine("COMMA ", token)

    elif token == ";":
        output.writeLine("SEMICOLON ", token)

    elif token == "(":
        output.writeLine("LPAREN ", token)

    elif token == ")":
        output.writeLine("RPAREN ", token)

    elif token == "[":
        output.writeLine("LBRACKET ", token)

    elif token == "]":
        output.writeLine("RBRACKET ", token)

    elif token == "=":
        output.writeLine("ASSIGN ", token)
    
    elif token.match(re"^([0-9]+\.[0-9]*|\.[0-9]+)([eE][+-]?[0-9]+)?$"):
        output.writeLine("NUM_FLOAT ", token)

    elif token.match(re"^[0-9]+([eE][+-]?[0-9]+)?$"):
        output.writeLine("NUM_INT ", token)

    elif token.match(re"^[a-zA-Z][a-zA-Z0-9_]*$"):
        if token in ["type", "object", "proc", "if", "int", "elif", "else", "while", "return", "var", "not", "and", "or", "mod"]:
            output.writeLine("KEYWORD ", token)
        else:
            output.writeLine("ID ", token)

output.close()

echo "Tokenização concluída!"
