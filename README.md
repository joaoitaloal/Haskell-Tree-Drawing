# Haskell Tree Drawing

Esse repositório contém minha implementação do programa da seção 3.4.7 do livro "Concepts, Techniques, and Models of Computer Programming by Peter Van Roy Seif Haridi", como parte da cadeira de Linguagens de Programação da UFC.

A implementação, feita em Haskell, pode ser encontrada em ./main.hs, ela contém os detalhes e explicações da implementação como comentários no código.

Adicionalmente, este repositório contém, na pasta ./interface, uma implementação de uma interface gráfica que desenha de fato as árvores calculadas na seção 3.4.7 do livro, também em Haskell, utilizando a biblioteca h-raylib. O desenho gráfico não era parte da cadeira portanto o código não está tão bem explicado quanto o resto.

Por último, a pasta ./c contém uma implementação em c++, usando ponteiros, que utilizei para reescrever o código Oz de forma que eu entendesse melhor, e a pasta ./oz contém o próprio algoritmo do livro.

## Rodando a interface

Para compilar e rodar a interface é necessário ter o GHC e o cabal-installer instalados, recomendo utilizar o [GHCup](https://www.haskell.org/ghcup/) , que baixa tudo que você vai precisar de uma vez.

Tendo tudo instalado, entre na pasta interface e compile o programa:

```bash
cd interface
cabal update
cabal build
```

O comando ``cabal update`` demora um pouco na primeira vez.
Após isso, rode o programa com:

```bash
cabal run
```
