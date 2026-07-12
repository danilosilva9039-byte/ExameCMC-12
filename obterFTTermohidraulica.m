function [Gtheta, Gv] = obterFTTermohidraulica(planta)
    % FTs de aquecimento do combustível (Gtheta) e geração de vazios (Gv)
    s = tf('s');
    
    Gtheta = planta.ktheta / (1 + planta.Ttheta * s);
    Gv = planta.kv / (1 + planta.Tv * s);
end