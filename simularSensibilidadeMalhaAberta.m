function simularSensibilidadeMalhaAberta(planta, param_str, val_curvas, val_picos, config)
    % Se val_picos não for fornecido, usa a mesma matriz das curvas
    if nargin < 4 || isempty(val_picos)
        val_picos = val_curvas;
    end
    
    t_final = 100;
    limite_explosao = 1000; % 1000x a potência nominal considera divergência
    C = 0.5; % Constante de Fronteira

    % Junta as duas matrizes e remove duplicatas para evitar simular 2x o mesmo valor
    todos_vals = unique([val_curvas(:); val_picos(:)]');
    
    picos_validos = [];
    vals_validos = [];
    
    fig_tempo = figure('Name', ['Temporal - ' config.titulo_base], 'NumberTitle', 'off', 'Position', [100, 100, 800, 500]);
    hold on; grid on;
    cores = lines(length(val_curvas));
    idx_cor = 1;
    
    for k = 1:length(todos_vals)
        val = todos_vals(k);
        
        % MATLAB injeta o valor na variável certa a partir da string
        planta.(param_str) = val;
        
        % Roda o simulador encapsulado em try-catch
        % Isso blinda o código caso a explosão seja tão violenta que o Simulink desista
        try
            saida = simularRespostaTemporalReator(planta, t_final);
            y = saida.Data;
            t = saida.Time;
            pico_max = max(y);
        catch
            y = inf;
            t = 0;
            pico_max = inf;
        end
        
        % 1. Plot das curvas
        if ismember(val, val_curvas)
            if isinf(pico_max) % Se o solver quebrou, cria uma linha reta indicando explosão
                plot(t, max(ylim), 'Color', cores(idx_cor,:), 'LineWidth', 2, 'LineStyle', '--', ...
                     'DisplayName', sprintf([config.formato_legenda ' (Erro Solver)'], val));
            else
                % Transformação symlog: Linear perto de zero, log para valores grandes
                y_trans = sign(y) .* log10(1 + abs(y)/C);
                
                plot(t, y_trans, 'Color', cores(idx_cor,:), 'LineWidth', 2, ...
                    'DisplayName', config.func_legenda(val));
            end
            idx_cor = idx_cor + 1;
        end
        
        % 2. Picos das curvas estáveis
        if ismember(val, val_picos)
            if pico_max < limite_explosao
                picos_validos = [picos_validos, pico_max];
                vals_validos = [vals_validos, val];
            end
        end
    end
    
    % Ajustes do Eixo Y do Gráfico Temporal
    ticks_reais = [-100, -10, -1, 0, 1, 10, 100, 1000];
    ticks_trans = sign(ticks_reais) .* log10(1 + abs(ticks_reais)/C);
    % Trava os limites reais de -1 a 1000 aplicando a mesma transformação BiLog
    limite_inferior = sign(-1) * log10(1 + abs(-1)/C);
    limite_superior = sign(1000) * log10(1 + abs(1000)/C);
    ylim([limite_inferior, limite_superior]);
    set(gca, 'YTick', ticks_trans, 'YTickLabel', string(ticks_reais));
    
    xlabel('Tempo (s)', 'FontSize', 12);
    ylabel('Variação Relativa (\delta n / n_0) [Escala BiLog]', 'FontSize', 12);
    title(['Dinâmica Temporal: ' config.titulo_base], 'FontSize', 14);
    legend('Location', 'best');
    salvarFigura(fig_tempo, ['Temp_' config.param_str]);
    
    % Gráfico de Potência Máxima (se alguma curva estabilizar)
    if ~isempty(picos_validos)
        fig_pico = figure('Name', ['Picos - ' config.titulo_base], 'NumberTitle', 'off');
        plot(vals_validos, picos_validos, '-o', 'LineWidth', 2, 'MarkerFaceColor', 'b');
        grid on;
        xlabel(config.label_x, 'FontSize', 12);
        ylabel('Pico Máximo Estável (\delta n / n_0)', 'FontSize', 12);
        title(['Estabilidade de Pico: ' config.titulo_base], 'FontSize', 14);
        salvarFigura(fig_pico, ['Pico_' config.param_str]);
    else
        disp(['[Aviso] Nenhum ponto estável encontrado para ' param_str '. O reator sempre explodiu. Gráfico de picos ignorado.']);
    end
end