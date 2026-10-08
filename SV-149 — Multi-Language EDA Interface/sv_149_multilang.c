#include "svdpi.h"
#include <stdio.h>

DPI_DLLESPEC
int sv149_c_add(int a, int b)
{
    int result = a + b;

    printf("[C] C function: %d + %d = %d\n", a, b, result);

    return result;
}