; How to build
; ml64 /c listing1-5.asm

; Listing 1-5

; A "Hello, world!" program using the C/C++ "printf"
; function to provide the output.
option casemap:none
.data
    ; Note: "10" is a line feed character
    ; Also known as the "C" newline character.
    fmtStr byte "Hello, world!", 10, 0

.code
    ; External declaration so MASM knows about
    ; the C/C++ "printf" function.
    externdef printf:PROC

    ; Here is the "asmFunc" function
    public asmFunc
    asmFunc PROC
        ; "Magic" instruction offered without explanation at this point:
        sub rsp, 56

        ; Here is where we will call the "C" printf function to print
        ; "Hello, world!". Pass the address of the format string
        ; to printf in the RCX register. Use the LEA instruction
        ; to get the address of fmtStr.
        lea rcx, fmtStr
        call printf

        ; Another "magic" instruction that undoes the effect of the
        ; previous one before this procedure returns to its caller.
        add rsp, 56
        ret ; Returns to caller

    asmFunc ENDP
    END