function Gp = obterTFReatividadeExterna(planta)
% Obtem a reatividade externa \delta \pho _{ex}
% Ela foi modelada como uma rampa inicialmente para
% simular seu comportamento de introducao de reatividade

    beta = calculaBeta(planta);
    v = planta.v;
    d = planta.d;
    d1 = planta.d1;
    PR = planta.PR;
    PRN = planta.PRN;

    t1 = d / v; 
    t2 = (d + d1) / v;

    m1 = PR / d;
    m2 = (PRN - PR) / d1;

    delta_m1 = m1;
    delta_m2 = m2 - m1;
    delta_m3 = -m2;

    k1 = delta_m1 * v;
    k2 = delta_m2 * v;
    k3 = delta_m3 * v;

    H_base = tf(1, 1); %%pois a funcao será chamada com uma rampa: 1/s^2

    H1 = k1 * H_base;
    H2 = k2 * H_base;
    H2.InputDelay = t1;
    H3 = k3 * H_base;
    H3.InputDelay = t2;

    Gp = H1 + H2 + H3;
   

end
