function GF = obterFTReatividadeDeRealimentacao(planta)
% Obtem a função de transferêcnai da reatividade de realimenta¸c˜ao total combinada (GF (s)) 
%gerada pelo aquecimento do combustível e geração de vazios

	s = tf('s');

	[Gtheta, Gv] = obterFTReatividade(planta);
    GF = planta.alphatheta * Gtheta + planta.alphav * Gv;
     	

end
