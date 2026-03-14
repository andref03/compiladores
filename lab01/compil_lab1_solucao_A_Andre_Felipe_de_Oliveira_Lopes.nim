import strutils
import re

var code = readFile("compil_lab1_amostra_B_Andre_Felipe_de_Oliveira_Lopes.nim")

# tratamento de símbolos para garantir que sejam isolados como tokens separados
# SYMBOLS
for c in [":", ",", ";", "(", ")", "[", "]", "."]:
  code = code.replace(c, " " & c & " ")

# NEWLINE
code = code.replace("\n", " NEWLINE ")

# saída
let output = open("compil_lab1_resposta_C_Andre_Felipe_de_Oliveira_Lopes.txt", fmWrite)

# laço principal de tokenização
for token in code.splitWhitespace():

    case token
        of "NEWLINE":
            output.writeLine("NEWLINE \\n")

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

        else:
            if token.match(re"^([0-9]+\.[0-9]*|\.[0-9]+)([eE][+-]?[0-9]+)?$"):
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
