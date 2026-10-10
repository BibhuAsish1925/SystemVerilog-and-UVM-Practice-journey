#include <stdio.h>

int sv146_c_add(int a, int b)
{
    printf("C function: received a=%d b=%d\n", a, b);

    return a + b;
}