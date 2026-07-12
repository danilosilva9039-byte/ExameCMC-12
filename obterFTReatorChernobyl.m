function Gc = obterFTReatorChernobyl(planta)
%Obtem a funcao de transferencia do Reator
%usado em chernobyl. Esse reator possuia 

beta = calculaBeta(planta);

G0 = obterFTReatorPotenciaZero(planta);
GF = obterFTReatividadeDeRealimentacao(planta);

Gc = feedback( (1/beta)*G0, planta.N0 * GF, +1 );
s
end