sistemaRobo
===========

Suponha que você precisa implementar um robô controlado pelos seguintes comandos:

```
L - Virar 90 graus para a esquerda
R - Virar 90 graus para a direita
M - Mover um passo para frente
T - Se tele-transportar para uma determinada célula 
```

O robô anda em um plano cartesiano, em um espaço de tamanho especifico, com quatro direções Norte(N), Sul (S), Leste (E), Oeste (W). Ele não pode se mover ou tele transportar para fora desse espaço. O input do problema vem de um arquivo com o seguinte formato:

1a linha: o tamanho do espaço que o robô pode usar - X<espaço>Y
2a linha: localização inicial do robô e sua direção - X<espaço>Y<espaço>D
3a linha em diante: comandos do robô sem separação. A exceção é o comando de teletransporte, que deve ficar em sua própria linha com o seguinte formato - T<espaço>X<espaço>Y

Um exemplo (sem os comentários):

```
10 10              # o tamanho do espaço é 10 por 10
2 5 N              # sua localização inicial é (2,5) e a sua direção é Norte
LLRRMMMRLRMMM      # um conjunto de comandos
T 1 3              # o robô se tele transporta para o ponto (1,3)
LLRRMMRMMRM        # um outro conjunto de comandos
```

O resultado final deve ser dado pelo robô para indicar sua posição e para onde ele está apontando, por exemplo:

```
2 4 E              # na posição 2 4, virado para Leste
```

Assuma que a célula imediatamente ao norte de (x, y) é (x, y + 1) e a leste é (x+1,y)

Para executar o Programa
========================

Requer Perl instalado em #!/usr/bin/perl. Perl vem automaticamente em Mac OSX.

```
./robo.pl comandos.txt 
2 1 W
```

Para maiores detalhes, usar o argumento "verbose"

```
rpaskinmbpx7:sistemaRobo rpaskin$ ./robo.pl comandos.txt verbose
## Tamanho do mapa: 10 x 10
## Posicao inicial: 2 5 N
## LINE 3 = [LLRRMMMRLRMMM]
## Estava para N, cmd [L], agora para W
## Estava para W, cmd [L], agora para S
...
## Estava em 3 1 W, cmd [M], agora em 2 1 W
############ POSICAO FINAL ############ x=2, y=1, direcao=W
2 1 W
```

Para executar outros comandos crie outro arquive e passe-o como parametro, ou
modifique o arquivo de comandos existente.
