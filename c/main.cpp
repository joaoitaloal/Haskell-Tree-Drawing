#include <iostream>
#include <string>
#include <vector>
#define SCALE 30

using namespace std;

class Tree
{
    public:
        string key;
        int value;
        Tree* left;
        Tree* right;

        int* x; // Ponteiros pra simular as Dataflow Variables
        int* y; // Ponteiros pra simular as Dataflow Variables

        Tree(){
            string key = "";
            value = 0;
            left = nullptr;
            right = nullptr;

            x = new int; *x = -1;
            y = new int; *y = -1;
        }

        Tree(string key_, bool has_left, bool has_right){
            key = key_;
            value = 0;
            left = has_left ? new Tree(key_+"_left_subtree", false, false) : nullptr;
            right = has_right ? new Tree(key_+"_right_subtree", false, false) : nullptr;

            x = new int; *x = -1;
            y = new int; *y = -1;
        }

        ~Tree(){
            delete left;
            delete right;

            delete x;
            delete y;
        }
};

// Tem muita coisa que poderia ser melhor aqui(tipo não usar um else no fim ali), 
// mas foi feito assim pra traduzir a versão do oz o mais fielmente que eu consegui
void DepthFirst(Tree* tree, int level, int left_lim, int* root_x, int* right_lim){
    // case tree
    if(tree->right == nullptr && tree->left == nullptr){
        *tree->x = *root_x = *right_lim = left_lim;
        *tree->y = SCALE*level;
    }else if(tree->left != nullptr && tree->right == nullptr){
        tree->x = root_x; // Essa parte não funciona exatamente que nem no oz por falta das Dataflow Variables, mas acho que os ponteiros são uma simulação fiel o suficiente
        *tree->y = SCALE*level;
        DepthFirst(tree->left, level+1, left_lim, root_x, right_lim);
    }else if(tree->left == nullptr && tree->right != nullptr){
        // Os comentários do caso de cima valem aqui também
        tree->x = root_x;
        *tree->y = SCALE*level;
        DepthFirst(tree->right, level+1, left_lim, root_x, right_lim);   
    }else if(tree->left != nullptr && tree->right != nullptr){
        int *l_root_x = new int, *l_right_lim = new int, *r_root_x = new int, r_left_lim;
    //in
        *tree->y = SCALE*level;

        // Chama pro filho esquerdo
        DepthFirst(tree->left, level+1, left_lim, l_root_x, l_right_lim);
        
        r_left_lim = (*l_right_lim)+SCALE; // Limite esquerdo do filho direito = um pouco pra direita(scale) do limite direto do filho esquerdo
        
        // Chama pro filho direito, com o limite esquerdo que a gente calculou ali em cima
        DepthFirst(tree->right, level+1, r_left_lim, r_root_x, right_lim);

        // Por ultimo, a posição horizontal da árvore atual é a média da posição horizontal dos dois filhos,
        // além disso, root_x também será o mesmo valor, já que temos que mandar isso pra cima para as outras chamadas recursivas usarem.
        *tree->x = *root_x = ((*l_root_x)+(*r_root_x))/2;

        // O certo seria deletar esses inteiros mas por causa da simulação das Dataflow variables não podemos fazer isso
        //delete l_root_x; delete l_right_lim; delete r_root_x; 
    }
}

int main(){
    /* 
        Esse código foi feito usando ponteiros para simular as Dataflow Variables do oz,
        porém essa simulação não é tão fiel, o maior problema é que nós não podemos deletar
        os inteiros que alocamos na memória, já que esses inteiros estão sendo usados por outras
        partes do código como valor, para esse código pequeno funciona mas obviamente não é
        uma simulação perfeita de Dataflow Variables, já que temos vazamento de memória.
    */ 

    /*
              1
           2     3 
         4   |  | |
        | |

    */
    /*Tree tree1("1", false, false);
    Tree* tree2 = new Tree("2", false, true);
    Tree* tree3 = new Tree("3", true, true);
    Tree* tree4 = new Tree("4", true, true);*/

        /*
              1
           2     3 
         4

    */
    Tree tree1("1", false, false);
    Tree* tree2 = new Tree("2", false, false);
    Tree* tree3 = new Tree("3", false, false);
    Tree* tree4 = new Tree("4", false, false);

    tree2->left = tree4;
    tree1.left = tree2;
    tree1.right = tree3;

    vector<Tree*> trees = {&tree1, tree2, tree3, tree4}; 

    int *root_x = new int, *right_lim = new int;
    DepthFirst(&tree1, 1, SCALE, root_x, right_lim);
    //delete root_x;  // Não podemos deletar esse int pois o x da tree1 está ligada a ele
    //delete right_lim;

    for(Tree* tree : trees){
        cout << "Tree" << tree->key << ":{ X: " << *tree->x << " Y: " << *tree->y << " }" << endl;
    }

    return 0;
}
