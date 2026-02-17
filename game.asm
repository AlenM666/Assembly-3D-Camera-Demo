format ELF64

section '.text' executable
public _start
extrn printf
extrn InitWindow
extrn SetTargetFPS
extrn WindowShouldClose
extrn BeginDrawing
extrn EndDrawing
extrn ClearBackground
extrn CloseWindow
extrn DisableCursor
extrn UpdateCamera
extrn IsKeyPressed
extrn BeginMode3D
extrn EndMode3D
extrn DrawCube
extrn DrawCubeWires
extrn DrawGrid
extrn DrawRectangle
extrn DrawRectangleLines
extrn DrawText
extrn Fade


_start:
    ;need sub 8 bytes not 32
    push rbp
    mov rbp, rsp
    sub rsp, 8

    ;InitWIndow(800, 450, "raylib...")
    mov edi, SCREEN_WIDTH
    mov esi, SCREEN_HEIGHT
    mov rdx, window_title
    ; lea rdx, [window_title]
    call InitWindow
    

    ;Camera
    ;=====================================================================
    ;Initileze camera 3d structure
    ;camera.positon(10.0, 10.0, 10.0)
    movss xmm0, [float_10]    
    movss [camera], xmm0                    ;position x
    movss [camera + 4], xmm0                ;position y
    movss [camera + 8], xmm0                ;position z

    ;camera.target = (0.0, 0.0, 0.0)
    movss xmm0, [float_0]
    movss [camera + 12], xmm0               ;target.x
    movss [camera + 16], xmm0               ;target.y
    movss [camera + 20], xmm0               ;target.z

    ;camera.up =(0.0, 1.0, 0.0)
    movss xmm0, [float_0]   
    movss [camera + 24], xmm0               ;up.x
    movss xmm0, [float_1]                   ;move 1.0 float to xmm0 
    movss [camera + 28], xmm0               ;up.y
    movss xmm0, [float_0]                   ;move 0.0 float to xmm0 
    movss [camera + 32], xmm0               ;up.z


    ;camera.fovy = 45.0
    movss xmm0, [float_45]
    movss [camera + 36], xmm0               

    ;camera.projection = CAMERA_PERSPECTIVE
    mov dword [camera + 40], CAMERA_PERSPECTIVE
    ;=====================================================================



    ;; Cube
    ;; Cube position  = (0)
    movss xmm0, [float_0]
    movss [cube_position], xmm0             ;pos.x
    movss [cube_position + 4], xmm0         ;pos.y
    movss [cube_position + 8], xmm0         ;pos.z
    ;=====================================================================

    
    ;disable cursor()
    call DisableCursor

    
    ;Set target fps(60)
    mov edi, 60
    call SetTargetFPS



.game_loop:

    ;; while (!WindowShouldClose())
    call WindowShouldClose
    test eax, eax
    jnz .exit_loop
    
    
    ;; UpdateCamera(&camera, CAMERA_FREE)
    lea edi, [camera]
    mov esi, CAMERA_FREE
    call UpdateCamera
    ;=====================================================================

    ;; if IsKeyPressd(key_z)
    mov edi, KEY_Z
    call IsKeyPressed
    test eax, eax
    jz .skip_reset


    ;; camera.target = (0.0, 0.0, 0.0)
    movss xmm0, [float_0] 
    movss [camera + 12], xmm0                   ;target.x
    movss [camera + 16], xmm0                   ;target.y
    movss [camera + 20], xmm0                   ;target.z


.skip_reset:
    ;BeginDrawing()
    call BeginDrawing
    

    ;=====================================================================
    
    ;; ClearBackground(RAYWHIETE)
    mov edi, [color_ray_white]
    call ClearBackground

    ;; BeginMode3D
    ;; Pass camera structure by value (on stack for large structs)
    sub rsp, 48                                     ; allocate space for camera struct (aligned)
    lea rsi, [camera]
    mov rdi, rsp
    mov ecx, 44                                                                        
    rep movsd                                       ; copy camerra to stack
    mov rdi, rsp
    call BeginMode3D
    add rsp, 48


    ;; DrawCube(cubePosition, 2.0f, 2.0f, 2.0f, RED)
    movss xmm0, [cube_position]     ; x
    movss xmm1, [cube_position + 4] ; y
    movss xmm2, [cube_position + 8] ; z
    movss xmm3, [float_2]       ; width
    movss xmm4, [float_2]       ; height
    movss xmm5, [float_2]       ; length
    mov edi, [color_red]        ; color
    call DrawCube
    

    ;; DrawGrid(10, 1.0f)
    mov edi, 20
    movss xmm0, [float_1] 
    call DrawGrid


    ;; EndMode3D
    call EndMode3D
    

    
    ;; Fade(SKYBLUE, 0.5f) - get faded color
    mov edi, [color_skyblue]
    movss xmm0, [float_05]
    call Fade
    mov [temp_color], eax


    ;; DrawRectangle(10, 10, 320, 93, Fade(SKYBLUE, 0.5f))
    mov edi, 10
    mov esi, 10
    mov edx, 320
    mov ecx, 93
    mov r8d, [temp_color]
    call DrawRectangle


    ;; DrawRectangleLines(10, 10, 320, 93, BLUE)
    mov edi, 10
    mov esi, 10
    mov edx, 320
    mov ecx, 93
    mov r8d, [color_blue]
    call DrawRectangleLines


    ;; DrawText("Free camera default controls:", 20, 20, 10, BLACK)
    lea rdi, [text_controls]
    mov esi, 20
    mov edx, 20
    mov ecx, 10
    mov r8d, [color_black]
    call DrawText
    
    ;; DrawText("- Mouse Wheel to Zoom in-out", 40, 40, 10, DARKGRAY)
    lea rdi, [text_zoom]
    mov esi, 40
    mov edx, 40
    mov ecx, 10
    mov r8d, [color_darkgray]
    call DrawText
    
    ;; DrawText("- Mouse Wheel Pressed to Pan", 40, 60, 10, DARKGRAY)
    lea rdi, [text_pan]
    mov esi, 40
    mov edx, 60
    mov ecx, 10
    mov r8d, [color_darkgray]
    call DrawText
    
    ;; DrawText("- Z to zoom to (0, 0, 0)", 40, 80, 10, DARKGRAY)
    lea rdi, [text_reset]
    mov esi, 40
    mov edx, 80
    mov ecx, 10
    mov r8d, [color_darkgray]
    call DrawText

    ;=====================================================================
    ;EndDrawing()
    call EndDrawing

    jmp .game_loop

.exit_loop:
    ;CloseWindow()
    call CloseWindow

    ;return 0
    xor eax, eax
    leave
    ret




section '.data' writeable

;screen setup
SCREEN_WIDTH      =     800
SCREEN_HEIGHT     =     600
window_title:           db "raylib - 3d camera free", 0
;;==========================================================


;Keys
KEY_Z = 90
;;==========================================================


;;colors
color_ray_white:        db 245, 245, 245, 255
color_red:              db 230, 41, 55, 255
color_maroon:           db 190, 33, 55, 255
color_skyblue:          db 102, 191, 255, 255
color_blue:             db 0, 121, 241, 255
color_black:            db 0, 0, 0, 255
color_darkgray:         db 80, 80, 80, 255
;;==========================================================


;float consts
float_10:               dd 10.0
float_0:                dd 0.0  
float_1:                dd 1.0
float_45:               dd 45.0
float_05:               dd 0.5
float_2:                dd 2.0
;;==========================================================


;Camera
CAMERA_PERSPECTIVE          =        0                    ;Camera projection types
CAMERA_ORTHOGRAPHIC         =        1                    ;Camera type
CAMERA_FREE                 =        1
;;==========================================================


; Camera3D structure (44 bytes)
; Vector3 position (12 bytes)
; Vector3 target (12 bytes)
; Vector3 up (12 bytes)
; float fovy (4 bytes)
; int projection (4 bytes)
camera                  rd          44

cube_position           rd          12                      ;Vector3 cubePosition (12 bytes)

temp_color              rd           4                       ;Temporary color storage
;;==========================================================

;;Strings
text_controls db "Free camera default controls:", 0
text_zoom db "- Mouse Wheel to Zoom in-out", 0
text_pan db "- Mouse Wheel Pressed to Pan", 0
text_reset db "- Z to zoom to (0, 0, 0)", 0
;;==========================================================


section '.note.GNU-stack'
