start:
    mov rs STACK
    call main()
    ret

main():
    dbg #42
    ret

STACK: