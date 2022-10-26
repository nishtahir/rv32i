#include <stdio.h>
#include <io.h>

int putchar(int c)
{
    while (UART_CSR -> TX_BUSY & 1)
    {
    }
    UART_IO -> THR = c;
    UART_CSR -> TX_SEND = 1;
    return 0;
}