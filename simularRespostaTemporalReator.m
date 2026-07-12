function saida = simularRespostaTemporalReator(planta, t_final)
    % Simula a planta termodinâmica no Simulink frente à inserção de reatividade externa.
    % Retorna exclusivamente os dados temporais.

    t = 0:0.01:t_final;
    Gp = obterFTReatividadeExterna(planta);
    [y_tf, t_tf] = impulse(Gp, t);
    dpex = timeseries(y_tf, t_tf);

    [Gtheta, Gv] = obterFTTermohidraulica(planta);
    G0 = obterFTPotenciaZero(planta);

    % Extração dos polinômios para injeção no Simulink
    [numG0, denG0] = tfdata(G0, 'v');
    [numGv, denGv] = tfdata(Gv, 'v');
    [numGtheta, denGtheta] = tfdata(Gtheta, 'v');

    reator_chernobyl = 'ReatorChernobyl';
    load_system(reator_chernobyl);
    in = Simulink.SimulationInput(reator_chernobyl);
    
    % Configuração dos parâmetros
    in = in.setModelParameter('StopTime', num2str(t_final));
    in = in.setModelParameter('Solver', 'ode15s');
    
    % Injeção das variáveis no Workspace da simulação
    in = in.setVariable('dpex', dpex);
    in = in.setVariable('numG0', numG0);
    in = in.setVariable('denG0', denG0);
    in = in.setVariable('numGv', numGv);
    in = in.setVariable('denGv', denGv);
    in = in.setVariable('numGtheta', numGtheta);
    in = in.setVariable('denGtheta', denGtheta);
    in = in.setVariable('planta', planta);
    in = in.setVariable('beta', planta.beta_total); 

    simulacao = sim(in);
    saida = simulacao.NeutronVar;
end