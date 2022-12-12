; How to build
; ml64 /c listing1-3.asm

; Listing 1-2

; A simple MASM module that contains an empty function
; to be called by the C++ code in Listing 1-2

; The ".code" directive tells MASM that the statements following
; this directive go in the section of memory reserved for machine
; instruction (code)
.code

; The "option casemap:none" statement tells MASM to make 
; all identifiers case-sensitive (rather than mapping them
; to uppercase). This is necessary because C++ identifiers
; are case-sensitive.
option casemap:none

; Here is the "asmFunc" function.
asmFunc PROC
    ; Empty function just returns to C++ code.
    ret ; returns to caller
asmFunc ENDP
END