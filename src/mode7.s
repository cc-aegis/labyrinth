include lib/thread.s
include lib/math.s
include labyrinth.s

CAMERA:
CAMERA.x:
    dw #0.0
CAMERA.y:
    dw #2.0
CAMERA.z:
    dw #0.0
CAMERA.r:
    dw #0

get_at(f16,f16)->Color:
    ftoi [#-4] [#-4]
    ftoi [#-3] [#-3]

    add [#-4] #480
    add [#-3] #480

    mov r0 [#-4]
    shr r0 #3
    push r1
    mov r1 [#-3]
    shr r1 #3
    shl r1 #7
    or r0 r1
    pop r1

    and [#-4] #7
    and [#-3] #7
    shl [#-3] #3
    or [#-3] [#-4]

    lookup r0 TILEMAP
    lookup r0 TILES
    lookup r0 [#-3]
    ret

; s    c    y  x  mapx mapz dx dz color
; [#7] [#8] r1 r2 r3   r4   r5 r6 r7
render_map():
    pusht r1 r2
    pusht r3 r4
    pusht r5 r6
    push r7
    add rs #2

    mov rd #0
    ctx #0 #1

    ; s, c = sin(CAMERA.r), -cos(CAMERA.r)
    read r1 CAMERA.r
    push r1
    call sin(i16)->f16
    mov [#7] r0
    push r1
    call cos(i16)->f16
    mov [#8] #0.0
    fsub [#8] r0
    sub rs #2

    ; for y in range(76):
    mov r1 #65 ; #75
render_map().loop1body:
    mov r2 r1
    add r2 #30 ; #20
    ctx #2 r2

    ; inv_iy: r6 = cam.y / float(y + 1) * PIXEL_FOV
    read r6 CAMERA.y
    utof r7 r1
    fadd r7 #3.0 ; #1.0
    fdiv r6 r7
    fmul r6 #48.0

    ; ix = -64.0 * INV_PIXEL_FOV
    ; mapx = (ix * c - s) * inv_iy + cam.x
    ; mapz = (ix * s + c) * inv_iy + cam.z
    mov r3 #-1.3333333333
    mov r4 r3
    fmul r3 [#8]
    fsub r3 [#7]
    fmul r3 r6
    read r5 CAMERA.x
    fadd r3 r5
    fmul r4 [#7]
    fadd r4 [#8]
    fmul r4 r6
    read r5 CAMERA.z
    fadd r4 r5

    ; dx = INV_PIXEL_FOV * c * inv_iy
    ; dz = INV_PIXEL_FOV * s * inv_iy
    fmul r6 #0.020833333333
    mov r5 r6
    fmul r5 [#8]
    fmul r6 [#7]

    ; for x in range(128):
    mov r2 #127
render_map().loop2body:
    ctx #1 r2

    ; color = ...
    pusht r3 r4
    call get_at(f16,f16)->Color
    sub rs #2
    mov r7 r0

    ; surf.set_at((x, y + 20), color)
    ctx #3 r7
    send

    ; mapx += dx
    ; mapz += dz
    fadd r3 r5
    fadd r4 r6

render_map().loop2cond:
    jrnzdec r2 render_map().loop2body

render_map().loop1cond:
    jrnzdec r1 render_map().loop1body

    sub r2 #3
    pop r7
    popt r5 r6
    popt r3 r4
    popt r1 r2
    ret

Mode7::main():
Mode7::main().loop:
    call render_map()
    mov rd #0
    ctx #0 #2
    send
    read r0 CAMERA.r
    add r0 #200
    write CAMERA.r r0
    call thread::next()
    jmp Mode7::main().loop
    ret