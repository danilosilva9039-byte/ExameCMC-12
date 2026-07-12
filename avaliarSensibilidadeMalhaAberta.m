% Limpa a bagunça antes de começar
clc; close all;

planta = obterPlantaReator();
planta = SimulaFalhaChernobyl(planta);

picos = 30; % Número de pontos de pico plotados
config.xlimites = [0, 10];       % Limita o tempo
config.ylimites = [-1, 100];    % Limita a amplitude

%% Modificando Coeficiente de Vazios (alpha_v)
config.param_str = 'alphav';
config.titulo_base = 'Efeito da Geração de Vazios (\alpha_v)';
config.label_x = 'Coeficiente de Vazio';
config.func_legenda = @(val) sprintf('\\alpha_v = %.2e', round(val * 10000)/10000);


curvas = linspace(1e-4, planta.alphacritico, 6); % 5 curvas para não poluir
limites.alphav = simularSensibilidadeMalhaAberta(planta, 'alphav', curvas, picos, config);

%% Modificando Velocidade do Atuador Mecânico (v)
config.param_str = 'v';
config.titulo_base = 'Impacto da Velocidade da Haste (v)';
config.label_x = 'Velocidade da Haste (m/s)';
config.func_legenda = @(val) sprintf('v = %.2f m/s', round(val));

curvas = [0.4, 1, 2, 4, 8, 16]; 
limites.v = simularSensibilidadeMalhaAberta(planta, 'v', curvas, picos, config);

%% Modificando Material do Deslocador (Pico de Reatividade Inicial)
config.param_str = 'fator_grafite';
config.titulo_base = 'Efeito do Deslocador de Grafite';
config.label_x = 'Tamanho do Pico Positivo (% do Projeto Original)';
config.func_legenda = @(val) sprintf('Pico de Grafite = %d%%', round(val * 100));

curvas = [0, 0.01, 0.02, 0.05, 0.1, 1]; % Multiplicadores (0% a 150%)
limites.fator_grafite = simularSensibilidadeMalhaAberta(planta, 'fator_grafite', curvas, picos, config);

%% Modificando a Fração de Inserção das Hastes
config.param_str = 'fator_hastes';
config.titulo_base = 'Inserção Parcial das Hastes';
config.label_x = 'Fração de Hastes Inseridas (%)';
config.func_legenda = @(val) sprintf('Hastes Inseridas = %g%%', round(val * 1000)/10);

curvas = [0.005, 0.01, 0.05, 0.1, 1.0];
limites.fator_hastes = simularSensibilidadeMalhaAberta(planta, 'fator_hastes', curvas, picos, config);

%% Display
if ~isnan(limites.alphav)
    fprintf('Coeficiente de Vazio Crítico : %.6f\n', limites.alphav);
else
    fprintf('Coeficiente de Vazio Crítico : [Inconclusivo no intervalo]\n');
end

if ~isnan(limites.v)
    fprintf('Velocidade Crítica : %.2f m/s\n', limites.v);
else
    fprintf('Velocidade Crítica : [Inconclusivo no intervalo]\n');
end

if ~isnan(limites.fator_grafite)
    fprintf('Pico de Grafite Crítico      : %.2f%%\n', limites.fator_grafite * 100);
else
    fprintf('Pico de Grafite Crítico      : [Inconclusivo no intervalo]\n');
end

if ~isnan(limites.fator_hastes)
    fprintf('Inserção Mínima Segura (AZ-5): %.2f%%\n', limites.fator_hastes * 100);
else
    fprintf('Inserção Mínima Segura (AZ-5): [Inconclusivo no intervalo]\n');
end