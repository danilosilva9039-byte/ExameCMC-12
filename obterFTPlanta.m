function Gplanta = obterFTPlanta(planta)
%obtem a funcao de transferencia que representa a planta
    G0 = obterFTReatorPotenciaZero(planta);
    [Gtheta, Gv] = obterTFReatividade(planta);
    beta = calculaBeta(planta);

    A = planta.alphav * Gv + planta.n * planta.alphatheta * Gtheta;
    B = planta.alphav * Gv + planta.alphatheta* Gtheta;

    Gplanta = A/(1 - (beta/B/G0))/(B);

    Gplanta = minreal(Gplanta);

end