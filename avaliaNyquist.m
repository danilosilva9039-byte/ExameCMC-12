function avaliaNyquist()
%traca diagrama de nyquist para diferentes valores de alpha_v
% de modo a observar as diferentes curvas de nyquist e quando
% ela passa a circular o ponto -1 + 0j

planta = obterPlantaReatorNuclear;
[Gtheta, Gv] = obterTFReatividade(planta);
G0 = obterFTReatorPotenciaZero(planta);

beta = calculaBeta(planta);
N0 = planta.N0;
alphatheta = planta.alphatheta;

F = feedback(G0/beta,Gtheta*N0*alphatheta,+1);

L0 = -(N0*(G0/beta)*Gv)/(1 - N0*(G0/beta)*alphatheta*Gtheta);

alpha = 0.002:0.0005:0.005;

figure
hold on

for k=1:length(alpha)
    L = alpha(k)*L0;
    nyquist(L)
end

grid on

end