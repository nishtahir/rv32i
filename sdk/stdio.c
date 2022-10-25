#include <stdio.h>
#include <io.h>


int putchar(int c) {
    UART -> THR = c; 
    return 0;
}