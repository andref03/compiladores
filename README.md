# Compiladores

Este repositório reúne as atividades desenvolvidas durante a disciplina de **Compiladores**, do curso de **Ciência da Computação — IFNMG**.

Durante a disciplina, cada atividade prática (lab) aborda uma etapa do processo de construção de compiladores, como **análise léxica**, dentre outros.

A linguagem escolhida para as atividades, através de sorteio, foi a linguagem de programação **Nim**.

Documentação oficial da linguagem:
https://nim-lang.org/docs/

---

# Preparando o ambiente

## Instalação do Nim

Para executar os programas deste repositório é necessário instalar o compilador **Nim**.

### Linux / WSL

Execute o comando abaixo no terminal:

```bash
curl https://nim-lang.org/choosenim/init.sh -sSf | sh
```

Após a instalação, adicione o Nim ao `PATH` caso ainda não tenha sido configurado:

```bash
export PATH=$HOME/.nimble/bin:$PATH
```

Verifique se a instalação foi concluída corretamente:

```bash
nim --version
```

Se a instalação estiver correta, o terminal exibirá a versão do compilador Nim.

---

# Atividades (Labs)

Cada pasta `labXX` corresponde a um laboratório desenvolvido durante a disciplina.

---

## Lab01

### Objetivo

O **Lab01** consiste na implementação de um **analisador léxico (lexer)** para a linguagem Nim.

Um analisador léxico é responsável por:

* Ler um arquivo contendo código fonte
* Identificar as **unidades léxicas (tokens)** presentes no programa
* Gerar uma saída onde cada linha representa um token encontrado

Cada linha da saída segue o formato:

```
CLASSE_DO_TOKEN lexema
```

Exemplo:

```
KEYWORD var
ID x
ASSIGN =
NUM_INT 10
```

---

### Como executar

1. Acesse a pasta do laboratório:

```bash
cd lab01
```

2. Execute o programa:

```bash
nim r compil_lab1_solucao_A_Andre_Felipe_de_Oliveira_Lopes.nim
```

O programa irá ler o arquivo de amostra:

```
compil-lab1-amostra-B-Andre-Felipe-de-Oliveira-Lopes.nim
```

e imprimir no terminal os **tokens identificados no código fonte**, dentro do arquivo de resposta:

```
compil_lab1_resposta_C_Andre_Felipe_de_Oliveira_Lopes.txt
```

---

## Lab02

### Objetivo

O **Lab02** consiste na implementação de um **analisador sintático LR(1)** para a linguagem Nim.

Nesta etapa, o laboratório utiliza a sequência de tokens gerada previamente pelo analisador léxico para:

* Validar se a entrada segue a gramática definida
* Aplicar a tabela LR(1) durante o processo de análise
* Construir a estrutura de parse a partir dos símbolos reconhecidos

Os arquivos principais utilizados pelo laboratório são:

* `gramatica.conf`: define a gramática da linguagem
* `tabela_lr1.conf`: contém a tabela LR(1)
* `entrada_parser.txt`: arquivo de entrada com os tokens do programa

---

### Como executar

1. Acesse a pasta do laboratório:

```bash
cd lab02
```

2. Gere o arquivo de tokens de entrada:

```bash
nim r compil_lab1.nim
```

3. Compile o analisador sintático:

```bash
g++ -std=c++17 parserLR/src/*.cpp -o parserLR/bin/parserLR
```

4. Execute o parser LR(1):

```bash
./parserLR/bin/parserLR gramatica.conf tabela_lr1.conf < entrada_parser.txt > saida 2>&1
```

O resultado da execução será gravado no arquivo:

```
saida
```
