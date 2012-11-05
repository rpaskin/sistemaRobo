sistemaRobo
===========

Suponha que voc� precisa implementar um rob� controlado pelos seguintes comandos:

```
L - Virar 90 graus para a esquerda
R - Virar 90 graus para a direita
M - Mover um passo para frente
T - Se tele-transportar para uma determinada c�lula 
```

O rob� anda em um plano cartesiano, em um espa�o de tamanho especifico, com quatro dire��es Norte(N), Sul (S), Leste (E), Oeste (W). Ele n�o pode se mover ou tele transportar para fora desse espa�o. O input do problema vem de um arquivo com o seguinte formato:

1a linha: o tamanho do espa�o que o rob� pode usar - X<espa�o>Y
2a linha: localiza��o inicial do rob� e sua dire��o - X<espa�o>Y<espa�o>D
3a linha em diante: comandos do rob� sem separa��o. A exce��o � o comando de teletransporte, que deve ficar em sua pr�pria linha com o seguinte formato - T<espa�o>X<espa�o>Y

Um exemplo (sem os coment�rios):

```
10 10              # o tamanho do espa�o � 10 por 10
2 5 N              # sua localiza��o inicial � (2,5) e a sua dire��o � Norte
LLRRMMMRLRMMM      # um conjunto de comandos
T 1 3              # o rob� se tele transporta para o ponto (1,3)
LLRRMMRMMRM        # um outro conjunto de comandos
```

O resultado final deve ser dado pelo rob� para indicar sua posi��o e para onde ele est� apontando, por exemplo:

```
2 4 E              # na posi��o 2 4, virado para Leste
```

Assuma que a c�lula imediatamente ao norte de (x, y) � (x, y + 1) e a leste � (x+1,y)

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
