function planta = obterPlantaReatorNuclear()

% Serve para obter os parâmetros do Reator para aplicação no sistema de controle
% Parametros determinados por meio dos dados disponibilizados pelo relatório
% da União Soviética que buscava relatar as causas do acidente que ocorreu 
% em Chernobyl

planta.keff = 1;
planta.alphav = 1;
planta.alphatheta = 1;
planta.beta = [1, 1, 1, 1, 1, 1];
planta.lambda = [1, 1, 1, 1, 1, 1];
planta.Lambda = 1;
planta.ktheta = 1;
planta.kv = 1;
planta.Tv = 1;
planta.Ttheta = 1;
planta.N0 = 1;
planta.n = 1;
planta.W0 = 1;


end
