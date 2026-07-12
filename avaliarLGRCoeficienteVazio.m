function avaliarLGRCoeficienteVazio(planta)
    % Avalia o Lugar Geométrico das Raízes parametrizado pelo coeficiente de vazio.
    % A equação característica do núcleo é rearranjada para isolar alpha_v
    % no formato 1 + alpha_v * L0(s) = 0.
    
    G0 = obterFTPotenciaZero(planta);
    [Gtheta, Gv] = obterFTTermohidraulica(planta);
    
    % G_interna isola o feedback natural negativo da temperatura (Doppler)
    G_interna = feedback(G0 / planta.beta_total, planta.N0 * planta.alphatheta * Gtheta, +1);
    
    % L0 é a planta equivalente vista pela variável alpha_v
    L0 = -(planta.N0 * G_interna * Gv); 
    
    fig = figure('Name', 'LGR - Variacao Alpha V', 'NumberTitle', 'off');
    rlocus(L0);
    axis([-1e4 1e4 -1e4 1e4]); % Trava eixos para evitar perda de proporção
    grid on;
    title('Lugar das Raízes parametrizado pelo Coeficiente de Vazio (\alpha_v)');
    
    salvarFigura(fig, 'LGR_Alpha_V');
end