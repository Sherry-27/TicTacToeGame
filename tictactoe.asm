.model small
.stack 100h

.data
    new_line db 13, 10, "$"
    
    game_draw db "_|_|_", 13, 10
              db "_|_|_", 13, 10
              db "_|_|_", 13, 10, "$"    
              
    game_pointer db 9 DUP(?)  
    win_flag db 0
    player db "0$"
    
    game_over_message db "GAME OVER", 13, 10, "$"
    game_start_message db "GAME START", 13, 10, "$"
    player_message db "PLAYER $"   
    win_message db " WINS!$", 13, 10   
    type_message db "TYPE A POSITION: $"

.code
start:
    ; set segment registers
    mov ax, @data
    mov ds, ax

    ; game start
    call set_game_pointer
    
main_loop:  
    call clear_screen   
    lea dx, game_start_message 
    call print
    
    lea dx, new_line
    call print
    
    lea dx, player_message
    call print
    lea dx, player
    call print  
    
    lea dx, new_line
    call print    
    
    lea dx, game_draw
    call print    
    
    lea dx, new_line
    call print    
    
    lea dx, type_message    
    call print
    
    ; read draw position                   
    call read_keyboard
    sub al, 49  ; adjust to 0-based index         
    mov bh, 0
    mov bl, al
    call update_draw
    call check
    
    ; check if game ends                   
    cmp win_flag, 1
    je game_over
    
    call change_player
    jmp main_loop

change_player:   
    lea si, player
    xor byte ptr ds:[si], 1
    ret

update_draw:
    mov bl, game_pointer[bx]
    mov bh, 0
    lea si, player
    cmp ds:[si], "0"
    je draw_x
    cmp ds:[si], "1"
    je draw_o

draw_x:
    mov cl, "X"
    jmp update

draw_o:
    mov cl, "O"
    jmp update

update:
    mov ds:[bx], cl
    ret

check:
    call check_line
    call check_column
    call check_diagonal
    ret

check_line:
    ; (check logic for winning rows)
    ret

check_column:
    ; (check logic for winning columns)
    ret

check_diagonal:
    ; (check logic for winning diagonals)
    ret

game_over:        
    call clear_screen
    lea dx, game_over_message 
    call print
    
    lea dx, new_line
    call print
    
    lea dx, game_draw
    call print
    
    lea dx, new_line
    call print
    
    lea dx, player_message
    call print
    lea dx, player
    call print
    
    lea dx, win_message
    call print
    jmp $

set_game_pointer:
    lea si, game_draw
    lea bx, game_pointer
    mov cx, 9
loop_1:
    cmp cx, 6
    je add_1
    cmp cx, 3
    je add_1
    jmp add_2

add_1:
    add si, 1
    jmp add_2

add_2:
    mov ds:[bx], si
    add si, 2
    inc bx
    loop loop_1
    ret

print:
    mov ah, 9
    int 21h
    ret

clear_screen:
    mov ah, 0
    int 10h
    ret

read_keyboard:
    mov ah, 1
    int 21h
    ret

end start
