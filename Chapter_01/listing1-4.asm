; How to build
; ml64 listing1-4.asm /link /subsystem:console /entry:main

; Listing 1-4

; A simple demonstration of a user-defined procedure.
.code

; A simple user-defined procedure that this program can call.
myProc PROC
    ret ; Immediately return to the caller
myProc ENDP

; Here is the "main" procedure

main PROC
    ; Call the user-defined procedure.
    call myProc
main ENDP
END