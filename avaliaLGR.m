function avaliaLGR()

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

avaliarReatorChernobyl(planta);
planta.alphav = 0.015;
avaliarReatorChernobyl(planta);

end