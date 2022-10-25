#ifndef __IO_H__
#define __IO_H__

#define REG_GPIO_IO 0x800
#define REG_UART_IO 0x804
#define REG_UART_CSR 0x808

typedef struct {
    volatile unsigned char THR;
    volatile unsigned char RHR;
} UART_IO_T;

#define UART ((UART_IO_T *) REG_UART_IO)


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
