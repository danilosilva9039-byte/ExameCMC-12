function avaliarRespostaTemporalDesastre(planta)
    % Plota a resposta temporal isolada do reator sob as condições atuais da planta
    
    t_final = 30;
    saida = simularRespostaTemporalReator(planta, t_final);
    
    fig = figure('Name', 'Resposta Temporal do Desastre', 'NumberTitle', 'off');
    plot(saida.Time, saida.Data, 'LineWidth', 2);
    grid on;
    xlabel('Tempo (s)', 'FontSize', 12);
    ylabel('Variação Relativa (\delta n / n_0)', 'FontSize', 12);
    title('Resposta do Reator à Inserção de Reatividade (Efeito Botão AZ-5)', 'FontSize', 14);
    
    salvarFigura(fig, 'Simulacao_Temporal_Simples');
end