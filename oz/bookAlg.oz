% Estrutura Tree:
% <Tree> ::= tree(key:<Literal> val:<Value> left: <Tree> right: <Tree>)
% | leaf

declare Scale DepthFirst
Scale=30
% Os argumentos iniciais são Level = 1 && LeftLim = Scale
proc {DepthFirst Tree Level LeftLim ?RootX ?RightLim}
    case Tree
    of tree(x:X y:Y left:leaf right:leaf ...) then
        % Caso em que o nó não tem filhos

        X=RootX=RightLim=LeftLim 
        Y=Scale*Level % A coordenada Y sempre é calculada assim, pois depende apenas do nivel do nó na árvore
    [] tree(x:X y:Y left:L right:leaf ...) then
        X=RootX
        Y=Scale*Level
        {DepthFirst L Level+1 LeftLim RootX RightLim}
    [] tree(x:X y:Y left:leaf right:R ...) then
        X=RootX
        Y=Scale*Level
        {DepthFirst R Level+1 LeftLim RootX RightLim}
    [] tree(x:X y:Y left:L right:R ...) then
        LRootX LRightLim RRootX RLeftLim
    in
        Y=Scale*Level
        {DepthFirst L Level+1 LeftLim LRootX LRightLim}
        RLeftLim=LRightLim+Scale
        {DepthFirst R Level+1 RLeftLim RRootX RightLim}
        X=RootX=(LRootX+RRootX) div 2
    end
end

% Algoritmo de visita genérico
declare DepthFirst
proc {DepthFirst Tree}
    case Tree
    of tree(left:L right:R ...) then
        {DepthFirst L}
        {DepthFirst R}
    [] leaf then
        skip
    end
end

% Extender o registro Tree com as coordenadas
declare AddXY
fun {AddXY Tree}
    case Tree
    of tree(left:L right:R ...) then
        {Adjoin Tree
            tree(x:_ y:_ left:{AddXY L} right:{AddXY R})}
    [] leaf then
        leaf
    end
end
