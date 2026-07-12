function planta = SimulaFalhaChernobyl(planta)
    %A falha de chernobyl foi causada por uma alteracao
    % do coeficiente do vazio - alpha_v - ocasionadas
    % por fenomenos fisicos
    
    % valor representativo
    planta.alphav = planta.alphacritico;
    
end