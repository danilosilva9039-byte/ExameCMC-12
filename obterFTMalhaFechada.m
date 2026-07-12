function Gplanta = obterFTMalhaFechada(planta)
    % FT que representa a planta nominal em malha fechada termodinâmica
    G0 = obterFTPotenciaZero(planta);
    [Gtheta, Gv] = obterFTTermohidraulica(planta);
    B = obterFTRealimentacao(planta);

    A = planta.alphav * Gv + planta.n * planta.alphatheta * Gtheta;

    Gplanta = minreal(A / (B * (1 - (planta.beta_total / (B * G0)))));
end