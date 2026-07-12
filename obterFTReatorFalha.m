function Gc = obterFTReatorFalha(planta)
    % FT do reator utilizada para análise de instabilidade do desastre
    % (resposta dn/n0 para um estímulo dp_ex)
    G0 = obterFTPotenciaZero(planta);
    GF = obterFTRealimentacao(planta);

    Gc = feedback((1 / planta.beta_total) * G0, planta.N0 * GF, +1);
end