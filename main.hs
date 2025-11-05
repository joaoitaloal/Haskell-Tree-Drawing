{-
    Uma pequena observação é que no livro o campo key é um literal,
    não sei qual seria o equivalente em haskell portanto usei uma string.
    Além disso val é um "Value", usei Int no lugar por simplicidade mas
    é só um valor satélite então poderia ser qualquer outro tipo.
-}

scale :: Int
scale = 30

--               key    val left right
data Tree = Node String Int Tree Tree | Leaf

--                      (x    y  ) key    val left       right
data TreeCoords = NodeC (Int, Int) String Int TreeCoords TreeCoords | LeafC

-- Calcular as coordenadas da árvore, enquanto a versão do livro modifica a árvore original,
-- achei mais coerente em haskell retornar uma nova estrutura do tipo "TreeCoords".
toTreeCoords :: Tree -> TreeCoords
toTreeCoords tree = fstThree (depthFirst tree 1 scale)

-- Além dessa função ser uma auxiliar para a "toTreeCoords", ela é a implementação de fato
-- da função DepthFirst do livro, a maior parte do código é bem paralelo ao original, comentei o que é diferente.
depthFirst :: Tree -> Int -> Int -> (TreeCoords, Int, Int)
depthFirst Leaf _ leftLim = (LeafC, leftLim, leftLim) -- Esse caso nunca é chamado mas resolvi colocar ele só pra manter a completude da função.

{-
    No livro ele tem dois argumentos passados pra baixo e dois que sobem das chamadas recursivas,
    O que foi feito aqui é muito parecido, a função recebe dois argumentos e retorna a tupla que seriam
    os argumentos passados pra cima, com a diferença que a árvore criada também é passada pra cima.
    
    Além disso o algoritmo do livro utilizam as variáveis dataflow para "pré-ligar" algumas váriaveis
    a esses argumentos passados para cima, isso permite que ele chame o método recursivamente depois
    de ligar as variáveis, já que não tenho essa possibilidade em haskell, simplesmente calculo toda
    a subárvore esquerda, depois a subárvore direita(se elas existem), e ligo os valores depois de calculados.
-}

depthFirst (Node key val Leaf Leaf) level leftLim =
    (NodeC (leftLim, level*scale) key val LeafC LeafC, leftLim, leftLim)

depthFirst (Node key val left Leaf) level leftLim =
    let 
        (left', rootX, rightLim) = depthFirst left (level+1) leftLim
    in 
        (NodeC (rootX, level*scale) key val left' LeafC, rootX, rightLim)

depthFirst (Node key val Leaf right) level leftLim =
    let
        (right', rootX, rightLim) = depthFirst right (level+1) leftLim
    in
        (NodeC (rootX, level*scale) key val LeafC right', rootX, rightLim)

depthFirst (Node key val left right) level leftLim =
    let
        (left', lRootX, lRightLim) = depthFirst left (level+1) leftLim
        rLeftLim = lRightLim+scale
        (right', rRootX, rightLim) = depthFirst right (level+1) rLeftLim
        rootX = (lRootX+rRootX) `div` 2
    in
        (NodeC (rootX, level*scale) key val left' right', rootX, rightLim)

-- Funções auxiliares:

-- Primeiro valor de uma tupla com 3 valores
fstThree :: (a, b, c) -> a
fstThree (a, _, _) = a

-- Transformar a árvore em uma lista pra conseguir visualizar os valores
treeCoordsToList :: TreeCoords -> [(String, Int, Int)]
treeCoordsToList LeafC = []
treeCoordsToList (NodeC (x, y) key _ left LeafC) =
    (key, x, y) : treeCoordsToList left
treeCoordsToList (NodeC (x, y) key _ LeafC right) =
    (key, x, y) : treeCoordsToList right
treeCoordsToList (NodeC (x, y) key _ left right) =
    (key, x, y) : (treeCoordsToList left ++ treeCoordsToList right)

-- Main:

main :: IO ()
main = do
    print (treeCoordsToList (toTreeCoords tree1))

-- Árvores de exemplo:

tree1, tree2, tree3, tree4, tree5 :: Tree
tree1 = Node "1" 1
        (Node "2" 2 
            (Node "4" 4 Leaf Leaf)
            Leaf
        )
        (Node "3" 3 Leaf Leaf)

tree2 = Node "1" 1
        (Node "2" 2 
            (Node "4" 4 Leaf Leaf)
            (Node "5" 5 Leaf Leaf)
        )
        (Node "3" 3
            (Node "6" 6 Leaf Leaf)
            (Node "7" 7 Leaf Leaf)
        )

tree3 = Node "1" 1
        Leaf
        (Node "2" 2
            (Node "3" 3 Leaf Leaf)
            (Node "4" 4 Leaf Leaf)
        )

tree4 = Node "1" 1
        (Node "2" 2
            (Node "4" 4 Leaf Leaf)
            Leaf
        )
        (Node "3" 3
            (Node "5" 5 Leaf Leaf)
            Leaf
        )

tree5 = Node "1" 1 Leaf Leaf
