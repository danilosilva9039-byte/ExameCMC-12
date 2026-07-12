function Gplanta = obterFTPlanta(planta)
%obtem a funcao de transferencia que representa a planta
    G0 = obterFTReatorPotenciaZero(planta);
    [Gtheta, Gv] = obterFTReatividade(planta);
    beta = calculaBeta(planta);

    A = planta.alphav * Gv + planta.n * planta.alphatheta * Gtheta;
    B = obterFTReatividadeDeRealimentacao(planta);

    Gplanta = A/(1 - (beta/B/G0))/(B);

    Gplanta = minreal(Gplanta);

end