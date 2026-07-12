function avaliarSensibilidadeGrafite(planta)
    % Varia o pico inicial positivo (simulando troca do grafite por outros materiais)
    planta = SimulaFalhaChernobyl(planta);
    
    % Fatores multiplicativos do pico de grafite: de 0% (sem grafite) a 150%
    fator_grafite = [0, 0.01, 0.05, 0.2, 0.5, 1];
    picos_potencia = zeros(size(fator_grafite));
    PR_original = planta.PR;
    
    fig_curvas = figure; hold on; grid on; cores = lines(length(fator_grafite));
    
    for k = 1:length(fator_grafite)
        planta.PR = PR_original * fator_grafite(k);
        saida = simularRespostaTemporalReator(planta, 30);
        
        plot(saida.Time, saida.Data, 'Color', cores(k,:), 'LineWidth', 2, ...
            'DisplayName', sprintf('Pico Relativo = %d%%', round(fator_grafite(k)*100)));
        picos_potencia(k) = max(saida.Data);
    end
    xlabel('Tempo (s)'); ylabel('\delta n / n_0'); title('Dinâmica sob Diferentes Geometrias de Deslocador'); legend;
    salvarFigura(gcf, 'Sensibilidade_Grafite_Curvas');
    
    figure;
    plot(fator_grafite * 100, picos_potencia, '-o', 'LineWidth', 2, 'MarkerFaceColor', 'g');
    grid on; xlabel('Pico Inicial Positivo (% do Projeto Original)'); ylabel('Pico Máximo de Potência');
    title('Importância Crítica do Deslocador de Grafite');
    salvarFigura(gcf, 'Sensibilidade_Grafite_Picos');
end