#!/usr/bin/perl -w
#Sistema Robô
#
#Suponha que você precisa implementar um robô controlado pelos seguintes comandos:
#
#L - Virar 90 graus para a esquerda
#R - Virar 90 graus para a direita
#M - Mover um passo para frente
#T - Se tele-transportar para uma determinada célula 
#
#O robô anda em um plano cartesiano, em um espaço de tamanho especifico, com quatro direções Norte(N), Sul (S), Leste (E), Oeste (W). Ele não pode se mover ou tele transportar para fora desse espaço. O input do problema vem de um arquivo com o seguinte formato:
#
#1a linha: o tamanho do espaço que o robô pode usar - X<espaço>Y
#2a linha: localização inicial do robô e sua direção - X<espaço>Y<espaço>D
#3a linha em diante: comandos do robô sem separação. A exceção é o comando de teletransporte, que deve ficar em sua própria linha com o seguinte formato - T<espaço>X<espaço>Y
#
#Um exemplo (sem os comentários):
#
#10 10              # o tamanho do espaço é 10 por 10
#2 5 N              # sua localização inicial é (2,5) e a sua direção é Norte
#LLRRMMMRLRMMM      # um conjunto de comandos
#T 1 3              # o robô se tele transporta para o ponto (1,3)
#LLRRMMRMMRM        # um outro conjunto de comandos
#
#O resultado final deve ser dado pelo robô para indicar sua posição e para onde ele está apontando, por exemplo:
#
#2 4 E              # na posição 2 4, virado para Leste
#
#Assuma que a célula imediatamente ao norte de (x, y) é (x, y + 1) e a leste é (x+1,y)
#
# Usage:
# $ ./des4.pl des4.txt
# 2 1 W
#
# Imprimindo detalhes:
# $ ./des4.pl des4.txt verbose
# 
### LINE 3 = [LLRRM]
### Estava para N, cmd [L], agora para W
### Estava para W, cmd [L], agora para S
### Estava para S, cmd [R], agora para W
### Estava para W, cmd [R], agora para N
### Estava em 2, 5, N, cmd [M], agora em 2, 6, N
### Estava em 2, 6, N, cmd [M], agora em 2, 7, N
### Estava em 2, 7, N, cmd [M], agora em 2, 8, N
### Estava para N, cmd [R], agora para E
### Estava para E, cmd [L], agora para N
### Estava para N, cmd [R], agora para E
### Estava em 2, 8, E, cmd [M], agora em 3, 8, E
### Estava em 3, 8, E, cmd [M], agora em 4, 8, E
### Estava em 4, 8, E, cmd [M], agora em 5, 8, E
### LINE 4 = [T 1 3]
### Estava em 5,8,E, cmd [T 1 3], agora em 1,3,E
### LINE 5 = [LM]
### Estava para E, cmd [L], agora para N
### Estava em 3, 1, W, cmd [M], agora em 2, 1, W
############# POSICAO FINAL ############ x=2, y=1, direcao=W
#2 1 W
#
# by Ronnie Paskin 2012.10.3

use strict;

open FILE, $ARGV[0] or die $!;
my @lines = <FILE>;
my $line;

our $verbose = $ARGV[1]? 1 : 0;

# Primeira linha = tamanho do mapa (x,y)
$line = shift @lines;
chomp $line;
$line =~ m/(\d+)\D(\d+)/;
our @grid = ($1, $2);
print "## Tamanho do mapa: ".join(" x ",@grid)."\n" if ($verbose);

# segunda linha = localizacao inicial (x,y,direcao)
$line = shift @lines;
chomp $line;
$line =~ m/(\d+)\D(\d+)\s+(\w+)/;

my @location = ($1, $2, $3);
print "## Posicao inicial: ".join(" ",@location)."\n" if ($verbose);

unless (safeCoords($1,$2,2,1,$line)){
    die "** Posicao inicial $1 $2 fora do mapa! O Robo esqueceu o Tardis?\n" if ($verbose);
}

# demais linhas = comandos
#L - Virar 90 graus para a esquerda
#R - Virar 90 graus para a direita
#M - Mover um passo para frente
#T - Se tele-transportar para uma determinada célula 
my $i = 2;
while (@lines){
    my $line = shift @lines;
    chomp $line;
    $i++;
    print "## LINE $i = [$line]\n" if ($verbose);

    my @commands;
    if ($line !~ /^T/) {     # a nao ser que seja um Teletransporte,
                             # separar cada comando

        @commands = split "", $line;
    }
    else {
        @commands = ($line);
    }

    my $j=0;
    while (@commands){
        my $cmd = shift @commands;
        $j++;

        # teletransporte: T X Y
        if ($cmd =~ m/T (\d+) (\d+)/){

            if (safeCoords($1,$2,$i,3,$line)){

                print "## Estava em ".join(" ",@location).", cmd [$cmd]" if ($verbose);

                $location[0] = $1;
                $location[1] = $2;

                print ", agora em ".join(" ",@location)."\n" if ($verbose);
            }
            else {
                die "** Seu robo foi teletransportado para uma dimensao paralela e se perdeu!\n";
            }
        }
        elsif ($cmd =~ m/^(L|R)$/){
            $location[2] = direction($location[2],$cmd);
        }
        elsif ($cmd eq 'M'){
            my @res = step(@location);
            if (safeCoords($res[0],$res[1],$i,$j,$line)){
                @location = @res;
            }
            else {
                die "** Seu robo caiu do mapa em uma dimensao paralela e se perdeu!\n";
            }
        }
    }
}

print <<"" if ($verbose);
############ POSICAO FINAL ############ x=$location[0], y=$location[1], direcao=$location[2]

print join(" ", @location)."\n";




sub safeCoords {
    my ($x, $y, $i, $j, $line) = @_;
    
    if ($x > $grid[0] || $x < 1 || $y > $grid[1] || $y < 1){
        print STDERR "** ERRO ** Linha $i, col $j [$line] - Coordenadas invalidas\n";
        return 0;
    }
    return 1;
}

sub direction {
    my ($dir, $command) = @_;

    # default R - virando para a direita, ou no sentido do relogio
    my %results = (
        'N' => 'E',
        'E' => 'S',
        'S' => 'W',
        'W' => 'N'
    );

    # nao default L - virando para a esquerda, sentido contrario
    if ($command eq 'L'){
        %results = (
            'N' => 'W',
            'W' => 'S',
            'S' => 'E',
            'E' => 'N'
        );
    }

    print "## Estava para $dir, cmd [$command], agora para $results{$dir}\n" if ($verbose);
    
    return $results{$dir};
}

sub step {
    my ($x, $y, $dir) = @_;

    print "## Estava em $x $y $dir, cmd [M]" if ($verbose);

    # Se o passo e' em direcao X, a operacao para novas coordenadas e' (a,b)
    my %results = (
        'N' => [0,1],
        'S' => [0,-1],
        'E' => [1,0],
        'W' => [-1,0]
    );

    my $op = $results{$dir};

    $x += $op->[0];
    $y += $op->[1];

    print ", agora em $x $y $dir\n" if ($verbose);

    return ($x, $y, $dir);
}
