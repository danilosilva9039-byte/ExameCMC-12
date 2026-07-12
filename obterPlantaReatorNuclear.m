function planta = obterPlantaReatorNuclear()

% Serve para obter os parâmetros do Reator para aplicação no sistema de controle
% Parametros determinados por meio dos dados disponibilizados pelo relatório
% da União Soviética que buscava relatar as causas do acidente que ocorreu 
% em Chernobyl

planta.keff = 1;
planta.N0 = 3.2*(10^9); % Em watts
planta.alphav = 2*(10^-4);% estimado por modelos numéricos nos computadores de chernobyl
planta.alphacritico = 0.025;% estimado por modelos numéricos nos computadores de chernobyl
planta.alphatheta = -1.2*(10^-5); % estimado por modelos numéricos nos computadores de chernobyl
planta.beta = [ 0.00021 , 0.00142 , 0.00127 , 0.00256 , 0.00074 , 0.00027];
planta.lambda = [ 0.0124 , 0.0305 , 0.111 , 0.301 , 1.14 , 3.01 ];
planta.Lambda = 10^(-3); % em segundos, incerteza razoavel 
planta.ktheta = 900; % Valor em Kelvin             
planta.kv = 1; %valor médio, por simplificacao     
planta.Tv = 2; %em segundo, valor médio, por simplificacao
planta.Ttheta = 5; %em segundo, valor médio
planta.n = 0.8; %modelo teórico de escoamento turbulento da equação de Dittus-Boelter
planta.W0 = (4.8*(10^4))/3600; %Em m/s, medido na usina
planta.v = 0.4; % em m/s, velocidade de inserção das hastes de controle
planta.d = 1.25; % em metros, Distância percorrida pela haste até o pico de reatividade
planta.d1 = 5.75; % em metros, distância entre o pico positivo até a inserção total
planta.PRN = -2*calculaBeta(planta); % pico de reatividade proveniente do boro
planta.PR = 0.5*calculaBeta(planta); % Pico de Reatividade


end
