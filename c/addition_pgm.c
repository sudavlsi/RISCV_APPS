#include <stdio.h>

void init();
int main() {
    int num1, num2, sum;
	init();
	num1 = 10;
	num2 = 20;
    sum = num1 + num2;
	#ifndef RISCV
	printf("sum %0d\n",sum);
	#endif
    return sum;
}
void init() {
	int num;
	num = 100;
}

