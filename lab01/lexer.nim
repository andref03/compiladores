import strutils
import re

let code = readFile("compil-lab1-amostra-B-Andre-Felipe-de-Oliveira-Lopes.nim")

for token in code.splitWhitespace():

    let cleanToken = token.strip(chars={',',';','(',')','[',']',':'})

    if cleanToken.match(re"^([0-9]+\.[0-9]*|\.[0-9]+)([eE][+-]?[0-9]+)?$"):
        echo "NUM_FLOAT ", cleanToken

    elif cleanToken.match(re"^[0-9]+([eE][+-]?[0-9]+)?$"):
        echo "NUM_INT ", cleanToken

    elif cleanToken.match(re"^[a-zA-Z_][a-zA-Z0-9_]*$"):
        if cleanToken in ["type", "object", "proc", "if", "int", "elif", "else", "while", "return", "var", "not", "and", "or", "mod"]:
            echo "KEYWORD ", cleanToken
        else:
            echo "ID ", cleanToken

    elif cleanToken == "=":
        echo "ASSIGN ", cleanToken
