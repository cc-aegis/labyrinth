mem::alloc<T>(u16)->&T:
    read r0 mem::HEAP
    sub r0 [#-3]
    write mem::HEAP r0
    ret

mem::copy<T>(&T,&T,u16).loop:
    copyitr [#-5] [#-4]
mem::copy<T>(&T,&T,u16):
    jrnzdec [#-3] .loop
    ret

mem::HEAP:
    dw #nullptr