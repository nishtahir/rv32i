#include<stdio.h>

volatile unsigned int *gpio = (unsigned int*) 0x000800;
volatile unsigned int *gpio1 = (unsigned int*) 0x000804;
volatile unsigned int *gpio2 = (unsigned int*) 0x000808;

int main(void) {
    putchar('h');
    putchar('e');
    putchar('l');
    putchar('l');
    putchar('o');
    putchar(' ');
    putchar('w');
    putchar('o');
    putchar('r');
    putchar('l');
    putchar('d');
    putchar('!');

    for(;;) {
        
    }
}