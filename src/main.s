start:
    mov rs STACK
    call main()
    exit

include mode7.s

main():
    dbg #42
    call Mode7::main()
    ret

STACK: