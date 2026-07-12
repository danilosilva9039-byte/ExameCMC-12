function avaliarSensibilidadeAlphaV(planta)
    % Avalia como a usina se comporta variando o coeficiente de vazios
    
    vetor_alphav = linspace(planta.alphav, planta.alphacritico, 6);
    picos_potencia = zeros(size(vetor_alphav));
    t_final = 30;
    
    fig_curvas = figure('Name', 'Sensibilidade Alpha V (Curvas)', 'NumberTitle', 'off');
    hold on; grid on; cores = lines(length(vetor_alphav));
    
    for k = 1:length(vetor_alphav)
        planta.alphav = vetor_alphav(k);
        saida = simularRespostaTemporalReator(planta, t_final);
        
        plot(saida.Time, saida.Data, 'Color', cores(k,:), 'LineWidth', 2, ...
            'DisplayName', sprintf('\\alpha_v = %.4f', planta.alphav));
        picos_potencia(k) = max(saida.Data);
    end
    xlabel('Tempo (s)'); ylabel('\delta n / n_0');
    title('Dinâmica da Potência sob Diferentes Coeficientes de Vazio'); legend;
    salvarFigura(fig_curvas, 'Sensibilidade_AlphaV_Curvas');
    
    fig_pico = figure('Name', 'Sensibilidade Alpha V (Picos)', 'NumberTitle', 'off');
    % Usa semilogy porque perto do alpha crítico a potência diverge exponencialmente
    semilogy(vetor_alphav, picos_potencia, '-o', 'LineWidth', 2, 'MarkerFaceColor', 'b');
    grid on; xlabel('Coeficiente de Vazio (\alpha_v)'); ylabel('Pico Máximo de Potência (\delta n / n_0)');
    title('Severidade do Acidente em Função da Geração de Vazios');
    salvarFigura(fig_pico, 'Sensibilidade_AlphaV_Picos');
end