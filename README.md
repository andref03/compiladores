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
