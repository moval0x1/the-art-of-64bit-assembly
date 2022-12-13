// How to build
// cl listing1-6.cpp listing1-5.obj

// Listing 1-6

// C++ driver program to demostrate calling printf from assembly
// Need to include stdio.h so this program can call "printf"
#include <stdio.h>

//extern "C" namespace prevents "name mangling" by the C++ compiler
extern "C"{
    // Here is the external funciton, written in ASM
    // that this program will call
    void asmFunc(void);
};

int main(void){
    // Need at least one call to printf in the C program
    // to allow calling it from assembly
    printf("Calling asmFunc:\n");
    asmFunc();
    printf("Returned from asmFunc\n");
}