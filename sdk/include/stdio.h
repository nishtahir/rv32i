#ifndef __STDIO__
#define __STDIO__

#ifndef EOF
    #define EOF (-1)
#endif

int putchar(char c);
int putint(int c);
int puts(char *str);
int printf (const char * str, ...);

#endif
