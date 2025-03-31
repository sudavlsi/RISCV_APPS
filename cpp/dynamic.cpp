#include <stdint.h>

// Assume the UART is mapped to this address
#define UART0_BASE_ADDR 0x10000000

// UART register offsets (these will depend on your hardware)
#define UART0_TXFIFO 0x00
#define UART0_LSR     0x14

// UART Line Status Register (LSR)
#define UART_LSR_THRE (1 << 5) // Transmitter Holding Register Empty


class Student {
private:
    const char* name;
    int rollNumber;

public:
    // Constructor
    Student(const char* n, int r) : name(n), rollNumber(r) {}

 };

 void main() {
    // Initialize UART (if needed; depends on your hardware)

    // Create a Student object
    Student student("John Doe", 101);

    // Display the student's information
    //student.display();

    // Infinite loop (since this is bare metal, the program doesn't exit)
    while (1) {
        // Do nothing, just loop forever
    }
}

