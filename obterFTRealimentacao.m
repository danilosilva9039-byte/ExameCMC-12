function GF = obterFTRealimentacao(planta)
    % FT da reatividade total de realimentação combinada (Doppler + Vazios)
    [Gtheta, Gv] = obterFTTermohidraulica(planta);
    
    GF = planta.alphatheta * Gtheta + planta.alphav * Gv;
end