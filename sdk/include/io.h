#ifndef __IO_H__
#define __IO_H__

#define REG_GPIO_IO 0x800
#define REG_UART_IO 0x804
#define REG_UART_CSR 0x808

typedef struct {
    volatile unsigned char THR : 8;
    volatile unsigned char RHR : 8;
} UART_IO_T;

typedef struct {
    volatile unsigned char TX_SEND : 1;
    volatile unsigned char RX_READ : 1;
    volatile unsigned char TX_BUSY : 1;
    volatile unsigned char RX_BUSY : 1;
} UART_CSR_T;

#define UART_IO ((UART_IO_T *) REG_UART_IO)
#define UART_CSR ((UART_CSR_T *) REG_UART_CSR)


// typedef struct {
//     unsigned char LEDS;
// } GPIO_T;

// extern volatile GPIO_T *GPIO_IO;

// typedef struct {
//     unsigned char TX_EN: 1;
//     unsigned char RX_EN: 1;
//     unsigned char TX_IDLE: 1;
//     unsigned char RX_IDLE: 1;
// } UART_CSR_T;

#endif
