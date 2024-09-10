.section .data
ValorElemMatriz:
    .string "Digite o elemento A[%i][%i] da matriz: "

LinhasMatriz:
    .string "Quantas linhas/colunas possui a matriz? "

AvisoSegundaMatriz:
    .string "Agora será pego os inputs da segunda matriz \n"

ValorReceba:
    .string "%i"

ValorEntrega:
    .string "%i\n"

Resultado:
        .string "\nResultado:\n"
       
ValorPrint:
        .string "%i "
PulaLinha:
        .string "\n"


.global main
.section .text

main:
    # -4 é tamanho matriz (ocupa 4 bytes)
    # -12 endereco malloc matriz 1 - operando (ocupa 8 bytes)
    # -20 enderec malloc matriz 2 - operando  (ocupa 8 bytes)
    # -28 endereco malloc matriz 3 - matriz resultante (ocupa 8 bytes)

    pushq   %rbp
    movq    %rsp, %rbp
    sub     $48, %rsp

    movq $LinhasMatriz, %rdi
    callq printf


    movq $ValorReceba, %rdi
    leaq -4(%rbp), %rsi
    callq scanf


    movq $0, %rax
    movl -4(%rbp), %esi
    movq $ValorEntrega, %rdi
    callq printf

    movl -4(%rbp), %eax
    imull %eax, %eax
    movslq  %eax, %rdi
    salq $2, %rdi
    movq %rdi, -36(%rbp)

    movq $0, %rax
    movl %edi, %esi
    movq $ValorEntrega, %rdi
    callq printf

    movq -36(%rbp), %rdi

    callq malloc

    movq %rax, -12(%rbp)
    movq -36(%rbp), %rdi

    call malloc

    movq %rax, -20(%rbp)
    movq -36(%rbp), %rdi

    call malloc

    movq %rax, -28(%rbp)

    # preparar input matriz
    # convenção :

    movl -4(%rbp), %edi # tamanho matriz
    movq -12(%rbp), %rsi # começo matriz
    callq pega_input_matriz

    movl -4(%rbp), %edi
    movq -12(%rbp), %rsi
    callq printa_matriz

    # preparar input matriz 2

    movq $AvisoSegundaMatriz, %rdi
    callq printf

    movl -4(%rbp), %edi # tamanho matriz
    movq -20(%rbp), %rsi # começo matriz
    callq pega_input_matriz

    movl -4(%rbp), %edi
    movq -20(%rbp), %rsi
    callq printa_matriz


    movl -4(%rbp), %edi # tamanho matriz
    movq -28(%rbp), %rsi # começo matriz
    callq preenche_zero_matriz

    #movl -4(%rbp), %edi
    #movq -28(%rbp), %rsi
    #callq printa_matriz

    #preparar multiplicação

    movl    -4(%rbp), %edi
    movq    -12(%rbp), %rsi
    movq    -20(%rbp), %rdx
    movq    -28(%rbp), %rcx
    callq multiplicaMatriz


    movl    -4(%rbp), %edi
    movq    -28(%rbp), %rsi
    callq   printa_matriz
    

    movq    -12(%rbp), %rdi
    callq   free

    movq    -20(%rbp), %rdi
    callq   free

    movq    -28(%rbp), %rdi
    callq   free
    

    xor   %eax, %eax
    leaveq  
    retq
   

pega_input_matriz: # -16 é i, e -20 é o j
    # 20 = 3 inteiros (i, j, M)[12] + ponteiro de inteiro A[8]
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $32, %rsp # ?

    movl %edi, -4(%rbp)
    movq %rsi, -12(%rbp)
    movl $0, -16(%rbp)
    movl -4(%rbp), %r10d

.pega_input_matriz_loop:
    movl    -4(%rbp), %eax
    cmpl    %eax, -16(%rbp)
    jge     .pega_input_matriz_loop_end
    movl    $0, -20(%rbp)

.pega_input_matriz_loop2:
    movl     -4(%rbp), %eax
    cmpl     %eax, -20(%rbp)
    jge     .pega_input_matriz_loop_end2

    # jge - se minuendo for maior ou igual, minuendo é o que vem dps

    movq    -16(%rbp), %rsi
    movq    -20(%rbp), %rdx
    movq    $ValorElemMatriz, %rdi
    callq   printf

    movq    $ValorReceba, %rdi
    movl    -16(%rbp), %eax

    imull   -4(%rbp), %eax
    addl    -20(%rbp), %eax
    cltq
    movq    -12(%rbp), %rcx
    leaq    (%rcx, %rax, 4), %rsi
    callq   scanf
    addl    $1, -20(%rbp)
    jmp     .pega_input_matriz_loop2

.pega_input_matriz_loop_end2:
    addl    $1, -16(%rbp)
    jmp     .pega_input_matriz_loop  

.pega_input_matriz_loop_end:
    leaveq  
    retq

printa_matriz:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $32, %rsp
    movl    %edi, -4(%rbp)
    movq    %rsi, -12(%rbp)
    movl    $0, -16(%rbp)
    movl    $0, -20(%rbp)
    movq    $Resultado, %rdi
    callq   printf

.printa_matriz_loop:
    movl    -4(%rbp), %eax
    cmpl     %eax, -16(%rbp)
    jge     .printa_matriz_loop_end
    movl $0, -20(%rbp)

.printa_matriz_loop2:
    movl     -4(%rbp), %eax
    cmpl     %eax, -20(%rbp)
    jge     .printa_matriz_loop_end2

    movl    -16(%rbp), %eax
    imull   -4(%rbp), %eax
    addl    -20(%rbp), %eax
    cltq
    movq    -12(%rbp), %rcx

    movl    (%rcx, %rax, 4), %esi
    movq    $ValorPrint, %rdi
    callq   printf
    addl $1, -20(%rbp)

    jmp .printa_matriz_loop2

.printa_matriz_loop_end2:
    movq    $PulaLinha, %rdi
    callq   printf

    addl    $1, -16(%rbp)
    jmp     .printa_matriz_loop  

.printa_matriz_loop_end:
    leaveq
    retq

                 
multiplicaMatriz:       # indice resultado = i*coluna + j
    pushq   %rbp           # indice matriz1 = i*coluna + k
    movq    %rsp, %rbp     # indice matriz2 = k*coluna + j
    subq    $64, %rsp    # parametros são, Tamanho, endereços m1, m2 e mR, precisa de i, j , k
    movl    %edi, -4(%rbp) # tamanho matrizes
    movq    %rsi, -12(%rbp) # m1 address
    movq    %rdx, -20(%rbp) # m2 address
    movq    %rcx, -28(%rbp) # mR address
    
    # (int i = 0)
    movl    $0, -32(%rbp) # i 

.multiplica_loop_1:
    # i < n
    movl -32(%rbp), %eax
    cmpl -4(%rbp), %eax 
    jge .multiplica_end_1
    
    # j = 0 
    movl $0, -36(%rbp) # j

.multiplica_loop_2:
    # j < n
    movl -36(%rbp), %eax
    cmpl -4(%rbp), %eax
    jge .multiplica_end_2

    # k = 0
    movl $0, -40(%rbp) # j

.multiplica_loop_3:
    movl -40(%rbp), %eax
    cmpl -4(%rbp), %eax 
    jge .multiplica_end_3

    movl    -32(%rbp), %eax
    imull   -4(%rbp), %eax
    addl    -40(%rbp), %eax
    movslq  %eax, %r12 # r12 guardando indice matriz1

    #movq    %r12, %rsi # valor no índice certinho
    #movq    $ValorPrint, %rdi
    #callq   printf

    movl    -40(%rbp), %eax
    imull   -4(%rbp), %eax
    addl    -36(%rbp), %eax
    cltq
    movq    %rax, %r13 # r13 guardando indice matriz2

    #movq    %r13, %rsi # valor no índice certinho
    #movq    $ValorPrint, %rdi
    #callq   printf

    movl    -32(%rbp), %eax
    imull   -4(%rbp), %eax
    addl    -36(%rbp), %eax
    cltq
    movq    %rax, %r14 # r14 guardando indice matrizR

    #movq    %r14, %rsi # valor no índice certinho
    #movq    $ValorPrint, %rdi
    #callq   printf

    movq    -12(%rbp), %rcx # m1
    movq    %r12, %rax
    leaq    (%rcx, %rax, 4), %r12

    #movl    (%r12), %esi # valor no índice certinho
    
    #movq    $ValorPrint, %rdi
    #callq   printf

    #movl    (%r12), %esi # valor no índice certinho
    #movq    $ValorPrint, %rdi
    #callq   printf


    movq    -20(%rbp), %rcx # m2
    movq    %r13, %rax
    leaq    (%rcx, %rax, 4), %r13

    #movl    (%r13), %esi # valor no índice certinho
    #movq    $ValorPrint, %rdi
    #callq   printf
    

    movq    -28(%rbp), %rcx # mR
    movq    %r14, %rax
    leaq    (%rcx, %rax, 4), %r14 

    movl    (%r12), %eax
    imull   (%r13), %eax
    addl    %eax ,(%r14) 

    #movl    (%r14), %esi # valor no índice certinho
    #movq    $ValorPrint, %rdi
    #callq   printf

    addl    $1, -40(%rbp)


    jmp     .multiplica_loop_3


.multiplica_end_3:
    addl $1, -36(%rbp)
    jmp .multiplica_loop_2


.multiplica_end_2:
    addl $1, -32(%rbp)
    jmp .multiplica_loop_1

.multiplica_end_1:
    leaveq
    retq

preenche_zero_matriz: # -16 é i, e -20 é o j
    # 20 = 3 inteiros (i, j, M)[12] + ponteiro de inteiro A[8]
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $32, %rsp 

    movl %edi, -4(%rbp)
    movq %rsi, -12(%rbp)
    movl $0, -16(%rbp)
    movl -4(%rbp), %r10d

.preenche_zero_matriz_loop:
    movl    -4(%rbp), %eax
    cmpl    %eax, -16(%rbp)
    jge .preenche_zero_matriz_loop_end
    movl    $0, -20(%rbp)

.preenche_zero_matriz_loop2:
    movl     -4(%rbp), %eax
    cmpl     %eax, -20(%rbp)
    jge     .preenche_zero_matriz_loop_end2
 

    movq    -16(%rbp), %rsi
    movq    -20(%rbp), %rdx
    
    movl    -16(%rbp), %eax

    imull   -4(%rbp), %eax
    addl    -20(%rbp), %eax
    cltq
    movq    -12(%rbp), %rcx
    leaq    (%rcx, %rax, 4), %rsi
    movq    $0, (%rsi)       # não sei se deveria ser movq ...

    addl    $1, -20(%rbp)
    jmp     .preenche_zero_matriz_loop2

.preenche_zero_matriz_loop_end2:
    addl    $1, -16(%rbp)
    jmp     .preenche_zero_matriz_loop  

.preenche_zero_matriz_loop_end:
    leaveq  
    retq
