; Listing 2-4

; Demonstrate packed data types
option casemap:none

NULL        =       0
nl          =       10  ; ASCII code for newline
maxLen      =       256

; New data declaration section.
; .const holds data values for read-only constants

.const
    ttlStr          byte    "Listing 2-4", 0
    monthPrompt     byte    "Enter a current month: ", 0
    dayPrompt       byte    "Enter a current day: ", 0
    yearPrompt      byte    "Enter a current year: (last 2 digits only): ", 0

    packed          byte    "Packed data is %04x", nl, 0
    theDate         byte    "The date is %02d/%02d/%02d", nl, 0
    badDayStr       byte    "Bad day values was entered (expected 1-31)", nl, 0
    badMonthStr     byte    "Bad month values was entered (expected 1-12)", nl, 0
    badYearStr      byte    "Bad year values was entered (expected 00-99)", nl, 0

.data
    month           byte    ?
    day             byte    ?
    year            byte    ?
    date            word    ?

    input           byte    maxLen dup (?)

.code
    externdef       printf  :PROC
    externdef       readLine:PROC
    externdef       atoi    :PROC

    ; Return program title to C++ program
    public getTitle
    getTitle PROC
        lea rax, ttlStr
        ret
    getTitle ENDP

    ; Here is a user-written function that reads a numeric value from the user
    
    ;int readNum(char *prompt);

    ; A pointer to a string containing a prompt message is passed in the RCX register
    ; This procedure prints the prompt, reads an input string from the user, then
    ; converts the input string to an integer and returns the integer values in RAX
    readNum PROC
        ; Must set up stack properly (using this "magic" instruction)
        ; before can call any C/C++ functions
        sub rsp, 56

        ; Print the prompt message. Note that the prompt message was passed
        ; to this function in RCX, we are just passing it on to printf
        call printf

        ; Set up arguents for readLine and read a line of thext from the user
        ; Note that readLine returns NULL (0) in RAX if there was an error.
        lea rcx, input
        mov rdx, maxLen
        call readLine

        ; Test for a bad input string
        cmp rax, NULL
        je @badInput

        ; Okay, good input at this point, try converting the string to an integer by calling atoi.
        ; The atoi function returns zero if there was an error, but zero is perfectly fine retur result
        ; so we ignore errors
        lea rcx, input      ; ptr to string
        call atoi           ; Convert to integer

@badInput:
        add rsp, 56         ; Undo stack setup
        ret
    readNum ENDP

    ; Here is the "asmMain" function
    public asmMain
    asmMain PROC
        sub rsp, 56

        ; Read the date from the user. Begin by reading the month
        lea rcx, monthPrompt
        call readNum

        ; Verify the mont is in the range, 1..12
        cmp rax, 1
        jl @badMonth
        cmp rax, 12
        jg @badMonth

        ; Good month, save it for now
        mov month, al       ; 1..12 fits in a byte

        ; Read the day
        lea rcx, dayPrompt
        call readNum

        ; We will be lazy here and verify only that the day is in the range 1-31
        cmp rax, 1
        jl @badDay
        cmp rax, 31
        jg @badDay

        ; Good day, save it for now
        mov day, al         ; 1..31 fits in a byte

        ; Read the year
        lea rcx, yearPrompt
        call readNum

        ; Verify that the year is in the range 00..99
        cmp rax, 0
        jl @badYear
        cmp rax, 99
        jg @badYear

        ; Good year, save it for now
        mov year, al        ; 0..99 fits in a byte

        ; Pac the date into the following bits
        ; 15  14  13  12  11  10  9  8  7  6  5  4  3  2  1  0
        ; m   m   m   m   d   d   d  d  d  y  y  y  y  y  y  y
        ; 12 months, the max number in binary   = 1100
        ; 31 days, the max number in binary     = 0001 1111
        ; 99 years, the max number in binary    = 0110 0011
        ; We are just working with words, 2 bytes

        movzx ax, month
        shl ax, 5
        or al, day
        shl ax, 7
        or al, year
        mov date, ax

        ; Print the packed date
        lea rcx, packed
        movzx rdx, date
        call printf

        ; Unpack the date and print it
        movzx rdx, date
        mov r9, rdx
        and r9, 7fh         ; Keep LO 7 bits (year)
        shr rdx, 7          ; Get day in position
        mov r8, rdx
        and r8, 1fh         ; Keep LO 5 bits
        shr rdx, 5          ; Get month in position
        lea rcx, theDate
        call printf

        jmp @allDone

        ; Come down here if a bad day was entered
@badDay:
        lea rcx, badDayStr
        call printf
        jmp @allDone

        ; Come down here if a bad month was entered
@badMonth:
        lea rcx, badMonthStr
        call printf
        jmp @allDone

        ; Com down here if a bad year was entered
@badYear:
        lea rcx, badYearStr
        call printf
        
@allDone:
        add rsp, 56
        ret         ; Return to caller
    asmMain ENDP
END