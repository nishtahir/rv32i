#include <stdio.h>
#include <io.h>

int putchar(int c)
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

int puts(char *str)
{
    int i = 0;
    while (str[i])
    {
        putchar(str[i]);
        i++;
    }
    return 1;
    // if (str)
    // {
    //     while (*str)
    //     {
    //         putchar(*str++);
    //     }
    // }
    // return 0;
}