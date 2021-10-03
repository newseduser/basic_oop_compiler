struct tnode* makeLeafNode(int n)
{ 
    struct tnode *temp;
    temp = (struct tnode*)malloc(sizeof(struct tnode));
    temp->op = NULL;
    temp->val = n;
    temp->left = NULL;
    temp->right = NULL;
    return temp;
}

struct tnode* makeOperatorNode(char c,struct tnode *l,struct tnode *r){
    struct tnode *temp;
    temp = (struct tnode*)malloc(sizeof(struct tnode));
    temp->op = malloc(sizeof(char));
    *(temp->op) = c;
    temp->left = l;
    temp->right = r;
    return temp;
}

int current_reg=-1;
int getReg()
{
    if(current_reg<20)
        return ++current_reg;
    else
    {
        printf("Register Overload!");
        exit(0);
    }
    
}
void freeReg()
{
    if(current_reg>-1)
        --current_reg;
    else
    {
        printf("All registers free!");
    }
        
}
int codeGen(struct tnode*,FILE*);

int codeWrite(struct tnode*t,FILE * target_file) {
    fprintf(target_file, "%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d\n",0,2056,0,0,0,0,0,0);
    codeGen(t,target_file);
    fprintf(target_file,"MOV R1,4096\nMOV [R1],R0\nMOV R2,\"Write\"\nPUSH R2\nMOV R2, -2\nPUSH R2\nPUSH R0\nPUSH R0\nPUSH R0\nCALL 0\n");
    fprintf(target_file, "POP R0\nPOP R1\nPOP R1\nPOP R1\nPOP R1\n");
}

int codeGen(struct tnode *t,FILE * target_file){
    if(t->op == NULL)
    {
        // Leaf Node
        // Allocate new number and store the number
        int p=getReg();
        fprintf(target_file,"MOV R%d, %d\n",p,t->val);
        return p;
    }
    else{
        int l,r;
        l = codeGen(t->left,target_file);
        r = codeGen(t->right,target_file);
        switch(*(t->op)){
            case '+' : 
                        fprintf(target_file,"ADD R%d, R%d\n",l,r);
                        freeReg();
                        break;
            case '-' : 
                        fprintf(target_file,"SUB R%d, R%d\n",l,r);
                        freeReg();
                        break;
            case '*' : 
                        fprintf(target_file,"MUL R%d, R%d\n",l,r);
                        freeReg();
                        break;
            case '/' : 
                        fprintf(target_file,"DIV R%d, R%d\n",l,r);
                        freeReg();
                        break;
        }
    }
}
