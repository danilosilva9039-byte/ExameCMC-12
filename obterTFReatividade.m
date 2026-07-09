function [Gtheta, Gv] = obterTFReatividade(planta)
% Obtem a função de transferência do aquecimento do combustı́vel (G0 (s)) e da geração de vazios
% (Gv (s)) em resposta à variação de potência

	s = tf('s');

	Gtheta = planta.ktheta / (1 + planta.Ttheta * s);
	
     	Gv = planta.kv / (1 + planta.Tv * s);
     	
     	

	

end
