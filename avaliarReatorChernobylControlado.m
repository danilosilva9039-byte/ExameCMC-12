function avaliarReatorChernobylControlado()
% faz a simulacao para atestar que o sistema
% de chernobyl foi falho

t_final = 10; 
passo = 0.01;
s = tf('s');
t = 0:passo:t_final;

planta = obterPlantaReatorNuclear;
requisitos = obterRequisitos(planta); 
beta = calculaBeta(planta);

atuador = 1; % a ser alterado
[y_tf, t_tf] = step(atuador, t); % a ser alterado
dpex = timeseries(y_tf, t_tf);

valorRef = 1/s; % a ser alterado
[y_tf, t_tf] = step(valorRef, t); % a ser alterado
NeutronVarRef = timeseries(y_tf, t_tf);
 

[Gtheta, Gv] = obterTFReatividade(planta);
G0 = obterFTReatorPotenciaZero(planta);
controlador = controladorReator(planta, requisitos);
motor = obterTFMotor();

[numG0, denG0] = tfdata(G0, 'v');
[numGv, denGv] = tfdata(Gv, 'v');
[numGtheta, denGtheta] = tfdata(Gtheta, 'v');
[numC, denC] = tfdata(controlador, 'v');
[numGm, denGm] = tfdata(motor, 'v');


reator_chernobyl_controlado = 'ReatorChernobylControlado';
load_system(reator_chernobyl_controlado);

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

simulacao = sim(in);

saida = simulacao.NeutronVar;
    
figure;
plot(saida.Time, saida.Data, 'LineWidth', 2);
grid on;
xlabel('Tempo (s)', 'FontSize', 12);
ylabel('Variação Relativa (\delta n / n)', 'FontSize', 12);
title(['Resposta do Reator à Inserção de Reatividade e ' ...
    'ao valor de reatividade de referência'], 'FontSize', 14);



end