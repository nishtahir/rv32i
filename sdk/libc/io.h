#ifndef _IO_H_
#define _IO_H_

#define UART_IO_REG 0x000FF00
#define UART_CSR_REG 0x000FF04
#define GPIO_IO_REG 0x000FF08

typedef struct {
    unsigned char LEDS;
} GPIO_T;

GPIO_T volatile *GPIO_IO = (GPIO_T *) GPIO_IO_REG;

typedef struct {
    unsigned char THR;
    unsigned char RHR;
} UART_IO_T;

UART_IO_T volatile *UART_IO = (UART_IO_T *) UART_IO_REG;

typedef struct {
    unsigned char TX_EN: 1;
    unsigned char RX_EN: 1;
    unsigned char TX_IDLE: 1;
    unsigned char RX_IDLE: 1;
} UART_CSR_T;

UART_CSR_T volatile *UART_CSR = (UART_CSR_T *) UART_CSR_REG;

#endif // MACRO
