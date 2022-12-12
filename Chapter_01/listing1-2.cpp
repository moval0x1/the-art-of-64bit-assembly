// How to build
// cl listing1-2.cpp listing1-3.obj

// Listing 1-2

// A simple C++ program that call an assembly language function.
// Need to include stdio.h so this program can call "printf".

#include <stdio.h>

// extern "C" namespace prevents "name mangling" https://www.geeksforgeeks.org/extern-c-in-c/

extern "C"{
    // Here's the external function, written in asm
    // that this program will call:

    void asmFunc(void);
}

int main(void){
    printf("Calling asmMain:\n");
    asmFunc();
    printf("Returned from asmMain.\n");
}