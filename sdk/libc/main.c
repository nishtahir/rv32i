#include <io.h>

int main() {
    GPIO_IO->LEDS &= 1;
    UART_IO->THR = 'A';
    UART_IO->RHR = 'B';
}