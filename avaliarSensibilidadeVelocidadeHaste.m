function avaliarSensibilidadeVelocidadeHaste(planta)
    % Avalia o impacto da velocidade do atuador mecânico (motor das hastes)
    planta = SimulaFalhaChernobyl(planta);

    vetor_velocidade = [0.1, 0.4, 1.6, 6.4, 12.8]; % Em m/s
    picos_potencia = zeros(size(vetor_velocidade));
    t_final = 30;
    
    fig_curvas = figure; hold on; grid on; cores = lines(length(vetor_velocidade));
    
    for k = 1:length(vetor_velocidade)
        planta.v = vetor_velocidade(k);
        saida = simularRespostaTemporalReator(planta, t_final);
        
        plot(saida.Time, saida.Data, 'Color', cores(k,:), 'LineWidth', 2, ...
            'DisplayName', sprintf('v = %.1f m/s', planta.v));
        picos_potencia(k) = max(saida.Data);
    end
    xlabel('Tempo (s)'); ylabel('\delta n / n_0'); title('Impacto da Velocidade de Inserção (AZ-5)'); legend;
    salvarFigura(gcf, 'Sensibilidade_VelocidadeHaste_Curvas');
    
    figure;
    plot(vetor_velocidade, picos_potencia, '-o', 'LineWidth', 2, 'MarkerFaceColor', 'r');
    grid on; xlabel('Velocidade da Haste v (m/s)'); ylabel('Pico Máximo de Potência');
    title('Atenuação do Desastre por Motores Mais Rápidos');
    salvarFigura(gcf, 'Sensibilidade_VelocidadeHaste_Picos');
end