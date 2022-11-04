#include <stdio.h>
#include <io.h>

int putchar(char c)
{
    if(c == '\0') {
        return EOF;
    }

    while (UART_CSR->TX_SEND & 1)
    {
    }
    UART_IO->THR = c;
    UART_CSR->TX_SEND = 1;
    return c;
}

int putint(int c) {
    return putchar(c + 48);
}

int puts(char *str)
{
    int i = 0;
    while (str[i])
    {
        putchar(str[i]);
        i++;
    }
    return 1;
}

int printf(const char* str, ...) {
    char *vl = (char *) &str + sizeof str;

	int i = 0, j=0;

    return j;
}