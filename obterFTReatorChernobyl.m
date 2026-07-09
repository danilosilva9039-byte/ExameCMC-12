function Gc = obterFTReatorChernobyl(planta)
%Obtem a funcao de transferencia do Reator
%usado em chernobyl. Esse reator possuia 

beta = calculaBeta(planta);

G0 = obterFTReatorPotenciaZero(planta);

[Gtheta, Gv] = obterTFReatividade(planta);

Gc = feedback((1/beta)*G0, planta.N0 *(planta.alphav * ...
    Gv + planta.theta * Gtheta), +1);


end