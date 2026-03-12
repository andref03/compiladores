import strutils
import re

let code = readFile("compil-lab1-amostra-B-Andre-Felipe-de-Oliveira-Lopes.nim")

for token in code.splitWhitespace():
    if token.match(re"^[0-9]+$"):
        echo "NUM_DEC ", token
    elif token.match(re"^[a-zA-Z_][a-zA-Z0-9_]*$"):
        if token in ["type", "object", "proc", "if", "int", "elif", "else", "while", "return", "var", "not", "and", "or", "mod"]:
            echo "KEYWORD ", token
        else:
            echo "ID ", token
    elif token == "=":
        echo "ASSIGN ", token


# palavras-chave: 
# type
# object
# proc
# if
# elif
# else
# while
# return
# var
# not
# and
# or