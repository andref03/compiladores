import strutils
import re

let code = readFile("compil-lab1-amostra-B-Andre-Felipe-de-Oliveira-Lopes.nim")
let output = open("compil-lab1-resposta-C-Andre-Felipe-de-Oliveira-Lopes.txt", fmWrite)

for token in code.splitWhitespace():

    let cleanToken = token.strip(chars={',',';','(',')','[',']',':'})

    if cleanToken.match(re"^([0-9]+\.[0-9]*|\.[0-9]+)([eE][+-]?[0-9]+)?$"):
        output.writeLine("NUM_FLOAT ", cleanToken)

    elif cleanToken.match(re"^[0-9]+([eE][+-]?[0-9]+)?$"):
        output.writeLine("NUM_INT ", cleanToken)

    elif cleanToken.match(re"^[a-zA-Z][a-zA-Z0-9]*$"):
        if cleanToken in ["type", "object", "proc", "if", "int", "elif", "else", "while", "return", "var", "not", "and", "or", "mod"]:
            output.writeLine("KEYWORD ", cleanToken)
        else:
            output.writeLine("ID ", cleanToken)

    elif cleanToken == "=":
        output.writeLine("ASSIGN ", cleanToken)

output.close()

echo "Tokenização concluída!"
