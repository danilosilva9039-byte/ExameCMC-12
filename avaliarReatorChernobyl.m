function avaliarReatorChernobyl(planta)
% faz a simulacao para atestar que o sistema
% de chernobyl foi falho

t_final = 30; 
passo = 0.01;
s = tf('s');
t = 0:passo:t_final;

%planta = obterPlantaReatorNuclear;
beta = calculaBeta(planta);

%define a entrada como sendo em funcao da 
%insercao de reatividade externa
Gp = obterTFReatividadeExterna(planta);
[y_tf, t_tf] = lsim(Gp, t, t);
dpex = timeseries(y_tf, t_tf);


[Gtheta, Gv] = obterTFReatividade(planta);
G0 = obterFTReatorPotenciaZero(planta);

[numG0, denG0] = tfdata(G0, 'v');
[numGv, denGv] = tfdata(Gv, 'v');
[numGtheta, denGtheta] = tfdata(Gtheta, 'v');


reator_chernobyl = 'ReatorChernobyl';
load_system(reator_chernobyl);

in = Simulink.SimulationInput(reator_chernobyl);
in = in.setModelParameter('StopTime', num2str(t_final));
in = in.setVariable('dpex', dpex);
in = in.setVariable('numG0', numG0);
in = in.setVariable('denG0', denG0);
in = in.setVariable('numGv', numGv);
in = in.setVariable('denGv', denGv);
in = in.setVariable('numGtheta', numGtheta);
in = in.setVariable('denGtheta', denGtheta);
in = in.setVariable('planta', planta);
in = in.setVariable('beta', beta);
in = in.setModelParameter('Solver', 'ode15s');

simulacao = sim(in);

saida = simulacao.NeutronVar;
    
figure;
plot(saida.Time, saida.Data, 'LineWidth', 2);
grid on;
xlabel('Tempo (s)', 'FontSize', 12);
ylabel('Variação Relativa (\delta n / n)', 'FontSize', 12);
title('Resposta do Reator à Inserção de Reatividade', 'FontSize', 14);



end