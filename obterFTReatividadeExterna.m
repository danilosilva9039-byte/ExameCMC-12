function Gp = obterFTReatividadeExterna(planta)
    % Modelagem do distúrbio de inserção das hastes com atrasos de transporte
    s = tf('s');
    H_base = 1/s^2; % Modelo por interpolação linear

    % Tempos de atraso baseados na geometria e velocidade da haste
    t1 = planta.d / planta.v; 
    t2 = (planta.d + planta.d1) / planta.v;

    % Inclinações das rampas (k = delta_m * v) consolidadas
    k1 = (planta.PR / planta.d) * planta.v;
    k2 = ((planta.PRN - planta.PR) / planta.d1 - planta.PR / planta.d) * planta.v;
    k3 = -((planta.PRN - planta.PR) / planta.d1) * planta.v;

    % Aplicação dos ganhos e atrasos
    H1 = k1 * H_base;
    
    H2 = k2 * H_base;
    H2.InputDelay = t1;
    
    H3 = k3 * H_base;
    H3.InputDelay = t2;

    Gp = H1 + H2 + H3;
end