function avaliaLGR()
%avalia o lugar geométrico das raizes
%Devido a problemas de proporcoes na figura
% É difícil de observar o ponto que passa para o semiplano 
% direito, sendo necessário o uso do cursor para perceber
% que houve cruzamento com o eixo imaginário

planta = obterPlantaReatorNuclear;
[Gtheta, Gv] = obterTFReatividade(planta);
G0 = obterFTReatorPotenciaZero(planta);

beta = calculaBeta(planta);
N0 = planta.N0;
alphatheta = planta.alphatheta;

F = feedback(G0/beta,Gtheta*N0*alphatheta,+1);

L = -(N0*(G0/beta)*Gv)/(1 - N0*(G0/beta)*alphatheta*Gtheta);

rlocus(L);
grid on;

%figura com um alpha_v que nao instabiliza o sistema
avaliarReatorChernobyl(planta);

%figura com um alpha_v que instabiliza o sistema
planta.alphav = planta.alphacritico;
avaliarReatorChernobyl(planta);

end