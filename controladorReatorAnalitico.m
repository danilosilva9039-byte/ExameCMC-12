function controlador = controladorReatorAnalitico(requisitos, planta)
%projeta o controlador com base nos requisitos pedidos

    s = tf('s');
    Gplanta = obterFTMalhaFechada(planta);

    %considera-se a dinâmica do motor rápida i.e Gm = 1

    Ga = Gplanta / s;

    funcao_erro = @(K) erro_banda(K, Ga, requisitos.wb);

    palpite_inicial = 1;

    % O fzero vai variar o K até que a funcao_erro seja zero
    [K_encontrado, fval, exitflag] = fzero(funcao_erro, palpite_inicial);

    controlador.K = K_encontrado;

    %Gc = 1/(s*planta.L + planta.R);
    Ga = Ga*controlador.K;
    [~, PM, ~, Wcp] = margin(Ga);

    phimax = requisitos.PM - PM; %poderia adicionar uma gordurinha, mas
    % não adicionei para mostrar que o sistema já atende muito bem aos
    %requisitos sem isso

    controlador.alpha = (1 - sind(phimax))/(1 + sind(phimax));
    controlador.Tl = 1/Wcp/sqrt(controlador.alpha);


end

%calcula o erro da banda passante para posteriormente ser usada em fzero
function erro = erro_banda(K, G, wb)
    if K <= 0
        erro = 1e6; 
        return;
    end

    try
        Gf = feedback(K * G, 1);
        
        if any(~isfinite(Gf.Numerator{1})) || any(~isfinite(Gf.Denominator{1}))
            erro = 1e6;
            return;
        end
        
        if ~isstable(Gf)
            erro = 1e6;
            return;
        end
        
        [mag_wb, ~] = freqresp(Gf, wb);
        mag_wb = abs(squeeze(mag_wb)); % Garante valor real
        
        if isnan(mag_wb) || isinf(mag_wb)
            erro = 1e6;
            return;
        end
        
        erro = mag_wb - (sqrt(2)/2); % mag_0 = 1
        
    catch
        % Se qualquer erro ocorrer no cálculo (ex: singularidade), retorna erro alto
        erro = 1e6;
    end
end


% IA me ajudou a criar a funcao de como calcular numericamente essa o valor de K
% pois não da pra resolver analiticamente |Gf (jωb)|= (1/sqrt(2)) *Gf (0)
% pois a planta tem ordem 9 !





    % %% 4. Exibição dos Resultados
    % if exitflag > 0
    %     fprintf('==================================================\n');
    %     fprintf('Sucesso! O ganho K calculado é: %.4f\n', K_encontrado);
    %     fprintf('==================================================\n');
    % 
    % % Testando e plotando para comprovar o resultado
    %     Gf = feedback(K_encontrado * Ga, 1);
    % 
    %  % Calcula numericamente a banda passante real do sistema projetado
    %     wb_real = bandwidth(Gf);
    %     fprintf('Banda passante obtida com esse K: %.4f rad/s\n', wb_real);
    % 
    % % Plot do diagrama de Bode para validação visual
    %     figure;
    %     bode(Gf);
    %     grid on;
    %     title(['Diagrama de Bode em Malha Fechada com K = ' num2str(K_encontrado)]);
    % else
    %      warning('Não foi possível encontrar um K que satisfaça a condição.');
    % end