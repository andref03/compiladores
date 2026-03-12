import strutils
import re

let code = readFile("compil-lab1-amostra-B-Andre-Felipe-de-Oliveira-Lopes.nim")

for token in code.splitWhitespace():
    if token.match(re"^[0-9]+$"):
        echo "NUM_DEC ", token
    elif token.match(re"^[a-zA-Z_][a-zA-Z0-9_]*$"):
        echo "ID ", token
    elif token == "=":
        echo "ASSIGN ", token
