#include<stdio.h>
int main (void)
{ 
	int count = 10, x;
	int *p;

	p = &count;
	x = *p;
	printf ("count = %i, x = %i\n", count, x);

	return 0;
}
