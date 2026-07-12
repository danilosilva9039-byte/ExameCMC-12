function avaliarNyquistCoeficienteVazio(planta)
    % Traça diagrama de Nyquist para diferentes valores de alpha_v
    % Demonstra o momento em que a curva engloba o ponto crítico -1+0j
    
    G0 = obterFTPotenciaZero(planta);
    [Gtheta, Gv] = obterFTTermohidraulica(planta);
    
    G_interna = feedback(G0 / planta.beta_total, planta.N0 * planta.alphatheta * Gtheta, +1);
    L0 = -(planta.N0 * G_interna * Gv);
    
    vetor_alpha = 0.002:0.0005:0.005;
    
    % --- Figura 1: Visão Panorâmica ---
    fig_completo = figure('Name', 'Nyquist Completo', 'NumberTitle', 'off');
    hold on; grid on;
    for k = 1:length(vetor_alpha)
        nyquist(vetor_alpha(k) * L0);
    end
    title('Diagrama de Nyquist - Variação de \alpha_v (Visão Completa)');
    salvarFigura(fig_completo, 'Nyquist_Completo');
    
    % --- Figura 2: Zoom no Ponto Crítico ---
    fig_zoom = figure('Name', 'Nyquist Zoom', 'NumberTitle', 'off');
    hold on; grid on;
    for k = 1:length(vetor_alpha)
        nyquist(vetor_alpha(k) * L0);
    end
    xlim([-2 0.5]); ylim([-1 1]); % Restringe os eixos
    title('Diagrama de Nyquist - Zoom no Ponto Crítico (-1+0j)');
    salvarFigura(fig_zoom, 'Nyquist_Zoom');
end