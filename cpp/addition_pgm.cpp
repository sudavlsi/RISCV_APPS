#ifndef RISCV
#include <iostream>
#endif
int main() {
    // Declare two variables to store the numbers
    int num1, num2, sum;

    // Ask the user for input

	num1 =10;
	num2 =20;
    // Perform addition
    sum = num1 + num2;

    // Output the result
#ifndef RISCV
std::cout << "The sum of " << num1 << " and " << num2 << " is " << sum << std::endl;
#endif
    return 0;
}

