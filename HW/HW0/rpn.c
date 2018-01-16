// work with Minyang Tie
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef struct CELL *LIST;
 
struct CELL {
  int val;
  LIST next;
};
LIST stack;
void push(int val) {
  LIST c = (LIST) malloc(sizeof(struct CELL));
  if (c) {
    c->val = val;
    c->next = stack;
    stack = c;
  } else { exit(1); }
}

int pop(){
  LIST c = stack;
  if(c) {
    stack=stack->next;
    int i = c->val;
    free(c);
    return i;}
  else {
    printf("stack is empty\n");
    exit(1);}
}

int main(){
  int a,b,c;
  char enter[500];
  stack =NULL;
  LIST temp;
  do{
    scanf("%s",enter);
    a = atoi(enter);
    if(a!=0 || strcmp(enter, "0")==0)
       push(atoi(enter));
    else{
      switch(*enter){
      
      case '+':
	if(stack && stack->next){
	  b= pop();
	  c= pop();
	  push(b+c);}
	else{
	  printf("dc: stack empty\n");
	}
	break;
      case '-': 
	if(stack && stack->next){
	  b= pop();
	  c= pop();
	  push(b-c);}
	else{
	  printf("dc: stack empty\n");
	}
	break;
      case '*':  
	if(stack && stack->next){
	  b= pop();
	  c= pop();
	  push(b*c);}
	else{
	  printf("dc: stack empty\n");
	}
	break;
      case '/': 
	if(stack && stack->next){
	  b= pop();
	  c= pop();
	  push(b/c);}
	else{
	  printf("dc: stack empty\n");
	}
	break;
      case 'f':
	temp=stack;
	while(temp){
	  printf("%d\n", temp->val );
	  temp=temp->next;
	}
	break;
      case 'c': 
	stack = NULL;
	break;
      case 'q': 
	break;
      }
    }
  }
    while(*enter !=EOF && *enter != 'q');
  free(stack);
  return 0;
}
