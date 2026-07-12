function avaliarSensibilidadeFracaoHastes(planta)
    % Simula a descida parcial do banco de barras de controle (Fator Multiplicativo)
    planta = SimulaFalhaChernobyl(planta);

    % Fatores: de 20% das barras até 100% das barras
    n_hastes = [1, 5, 10, 50, 100, 200];
    fator_hastes = n_hastes/200; 
    picos_potencia = zeros(size(fator_hastes));
    
    PR_original = planta.PR;
    PRN_original = planta.PRN;
    
    fig_curvas = figure; hold on; grid on; cores = lines(length(fator_hastes));
    
    for k = 1:length(fator_hastes)
        planta.PR = PR_original * fator_hastes(k);
        planta.PRN = PRN_original * fator_hastes(k);
        saida = simularRespostaTemporalReator(planta, 30);
        
        plot(saida.Time, saida.Data, 'Color', cores(k,:), 'LineWidth', 2, ...
            'DisplayName', sprintf('Hastes Inseridas = %g%%', round(fator_hastes(k)*1000)/10));
        picos_potencia(k) = max(saida.Data);
    end
    xlabel('Tempo (s)'); ylabel('\delta n / n_0'); title('Efeito da Quantidade de Hastes Inseridas'); legend('Location', 'best');
    salvarFigura(gcf, 'Sensibilidade_FracaoHastes_Curvas');
    
    figure;
    plot(fator_hastes * 100, picos_potencia, '-o', 'LineWidth', 2, 'MarkerFaceColor', 'k');
    grid on; xlabel('Porcentagem Total do Banco de Hastes (%)'); ylabel('Pico Máximo de Potência');
    title('Efeito da Inserção Parcial de Segurança');
    salvarFigura(gcf, 'Sensibilidade_FracaoHastes_Picos');
end