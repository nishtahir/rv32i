volatile unsigned int *gpio = (unsigned int*) 0x000800;
volatile unsigned int *gpio1 = (unsigned int*) 0x000804;
volatile unsigned int *gpio2 = (unsigned int*) 0x000808;

int main(void) {
    *gpio = 1;
    *gpio1 = 2;
    *gpio2 = 3;

    for(;;) {
        
    }
}