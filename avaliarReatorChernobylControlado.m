function avaliarReatorChernobylControlado()
    % Faz a simulacao varrendo ordens de grandeza do ganho K do controlador
    % Para mostrar que o sistema instabiliza nao importa o qual
    % agressivo/atuante é o controlador

    t_final = 10; 
    passo = 0.01;
    s = tf('s');
    t = 0:passo:t_final;

    planta = obterPlantaReatorNuclear();
    planta = SimulaFalhaChernobyl(planta);
    beta = calculaBeta(planta);

    Gp = obterTFReatividadeExterna(planta);
    [y_dpex, t_dpex] = lsim(Gp, t, t); 
    dpex = timeseries(y_dpex, t_dpex);

    valorRef = tf(1, 1); 
    [y_ref, t_ref] = step(valorRef, t); 
    NeutronVarRef = timeseries(y_ref, t_ref);

    [Gtheta, Gv] = obterTFReatividade(planta);
    G0 = obterFTReatorPotenciaZero(planta);

    [numG0, denG0] = tfdata(G0, 'v');
    [numGv, denGv] = tfdata(Gv, 'v');
    [numGtheta, denGtheta] = tfdata(Gtheta, 'v');

    Gm = obterTFMotor(planta);
    [numGm, denGm] = tfdata(Gm, 'v'); 

    reator_chernobyl_controlado = 'ReatorChernobylControlado';
    load_system(reator_chernobyl_controlado);

    K_valores = logspace(-3, 3, 7);
    cores = lines(length(K_valores)); 
    tempos_falha = zeros(length(K_valores), 1);

    figure;
    hold on; grid on;

    for i = 1:length(K_valores)
        K = K_valores(i);
        
        numC = K;
        denC = 1;

        in = Simulink.SimulationInput(reator_chernobyl_controlado);
        in = in.setModelParameter('StopTime', num2str(t_final));
        
        in = in.setVariable('dpex', dpex);
        in = in.setVariable('NeutronVarRef', NeutronVarRef);
        in = in.setVariable('numG0', numG0);
        in = in.setVariable('denG0', denG0);
        in = in.setVariable('numGv', numGv);
        in = in.setVariable('denGv', denGv);
        in = in.setVariable('numC', numC);
        in = in.setVariable('denC', denC);
        in = in.setVariable('numGm', numGm);
        in = in.setVariable('denGm', denGm);
        in = in.setVariable('numGtheta', numGtheta);
        in = in.setVariable('denGtheta', denGtheta);
        in = in.setVariable('planta', planta);
        in = in.setVariable('beta', beta);
        
        %A IA deu uma boa ajudada para desenvolver essa parte gŕafica abaixo
        in = in.setModelParameter('Solver', 'ode15s');
        in = in.setModelParameter('MaxStep', '1e-4'); 
        
        try
            simulacao = sim(in);
            saida = simulacao.NeutronVar;
            
            potencia_total = 1 + saida.Data;
            semilogy(saida.Time, potencia_total, 'Color', cores(i,:), ...
                 'LineWidth', 2, 'DisplayName', sprintf('K = %.1e', K));
        catch ME
            textoErro = ME.message;
            if ~isempty(ME.cause)
                for c = 1:length(ME.cause)
                    textoErro = [textoErro, ' ', ME.cause{c}.message];
                end
            end
            
            tempoFalha = regexp(textoErro, 'at time ([\d\.eE\+\-]+)', 'tokens');
            
            if ~isempty(tempoFalha)
                t_f = str2double(tempoFalha{1}{1});
                tempos_falha(i) = t_f;
                
                try
                    t_seguro = t_f * 0.995; 
                    in_seguro = in.setModelParameter('StopTime', num2str(t_seguro));
                    simulacao_seguro = sim(in_seguro);
                    saida_seguro = simulacao_seguro.NeutronVar;
                    
                    potencia_total = 1 + saida_seguro.Data;
                    semilogy(saida_seguro.Time, potencia_total, 'Color', cores(i,:), ...
                         'LineWidth', 2, 'DisplayName', sprintf('K = %.1e (Falha em %.3fs)', K, t_f));
                catch

                end
            end
        end
    end

    xlabel('Tempo (s)', 'FontSize', 12);
    ylabel('Potência Relativa Total (N / N_0) - Escala Log', 'FontSize', 12);
    title({'Trajetórias de Divergência do Reator (Motor Ideal)'; ...
           'Crescimento Exponencial para Múltiplos Ganhos K'}, 'FontSize', 14);
    
    limite_x = max(tempos_falha(tempos_falha > 0));
    if isempty(limite_x) || limite_x == 0; limite_x = 2; end
    xlim([0 limite_x * 1.1]); 
    
    legend('Location', 'best', 'FontSize', 10);
    hold off;
end