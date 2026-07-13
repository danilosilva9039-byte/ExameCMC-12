function avaliarReatorChernobylComControlador()
% faz a simulacao para atestar que o sistema
% de chernobyl foi falho

t_final = 100; 
passo = 0.01;
s = tf('s');
t = 0:passo:t_final;

planta = obterPlantaReator;
requisitos = obterRequisitos(); 
beta = planta.beta_total;

% 1. Distúrbio Nulo (Haste de Boro parada)
dpex_array = zeros(size(t));
dpex = timeseries(dpex_array, t);

% 2. Referência em Degrau (Aperta o botão no instante t = 1 segundo)
ref_array = zeros(size(t));
ref_array(t >= 1) = 1; % O sinal pula de 0 para 1 em t=1s
NeutronVarRef = timeseries(ref_array, t);
 

[Gtheta, Gv] = obterFTTermohidraulica(planta);
G0 = obterFTPotenciaZero(planta);
controlador = controladorReatorAnalitico(requisitos.controlador, planta); % a ser substituido pelo otimizado
controlador = controlador.K * (1/s) * ((controlador.Tl *s + 1)/(...
    controlador.alpha * controlador.Tl *s + 1));
motor = obterFTMotor(planta, requisitos.motor);
Gplanta = obterFTMalhaFechada(planta); % mostra atendimento requisitos
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
in = in.setModelParameter('Solver', 'ode15s'); % teste
in = in.setModelParameter('MaxStep', '1e-4');  % teste

simulacao = sim(in);

saida = simulacao.NeutronVar;
    
figure;
plot(saida.Time, saida.Data, 'LineWidth', 2);
grid on;
xlabel('Tempo (s)', 'FontSize', 12);
ylabel('Variação Relativa (\delta n / n)', 'FontSize', 12);
title(['Resposta do Reator a um comando de referência inicial ' ...
    'sem atuação das barras de boro'], 'FontSize', 14);


% 1. A haste passa a agir depois de 10 segundos (Haste de Boro parada)
dpex_array = zeros(size(t));
dpex_array(t >= 10) = -2*beta;    % muda para -2 após 10 s
dpex = timeseries(dpex_array, t);

% 2. Referência em Degrau (Aperta o botão no instante t = 1 segundo)
ref_array = zeros(size(t));
ref_array(t >= 1) = 1; % O sinal pula de 0 para 1 em t=1s
NeutronVarRef = timeseries(ref_array, t);


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
in = in.setModelParameter('Solver', 'ode15s'); % teste
in = in.setModelParameter('MaxStep', '1e-4');  % teste

simulacao = sim(in);

saida = simulacao.NeutronVar;
    
figure;
plot(saida.Time, saida.Data, 'LineWidth', 2);
grid on;
xlabel('Tempo (s)', 'FontSize', 12);
ylabel('Variação Relativa (\delta n / n)', 'FontSize', 12);
title(['Resposta do Reator a um comando de referêncai inicial ' ...
    'com atuação das barras de boro após 10 segundos'], 'FontSize', 14);

figure;
margin(controlador * motor * Gplanta); % mostra atendimento requisitos
grid on;
title(gca, ['Diagrama de Bode para Resposta do Reator a um comando de '...
    'referência inicial sem atuação das barras de boro']);

wb = bandwidth(feedback(controlador * motor * Gplanta, 1));
display(wb)

end