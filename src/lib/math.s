sin(i16)->f16:
    sub [#-3] #16384
cos(i16)->f16:
    itof [#-3] [#-3]
    fmul [#-3] #0.000015259254737998596
    mov r0 [#-3]
    fadd r0 #0.25
    floor r0
    fadd r0 #0.25
    fsub [#-3] r0
    mov r0 [#-3]
    and r0 #32767
    fsub r0 #0.5
    fmul r0 #16.0
    fmul [#-3] r0
    mov r0 [#-3]
    and r0 #32767
    fsub r0 #1.0
    fmul r0 [#-3]
    fmul r0 #0.225
    fadd r0 [#-3]
    ret