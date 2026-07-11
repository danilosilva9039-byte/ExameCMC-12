function Gm = obterTFMotor(planta)
%obtem a funcao de transferencia do motor
%Como foi mostrado no relatório, o sistema
% de controle projetado instabiliza independente
% dos ganhos. Para mostrar isso definimos
% a FT do motor como unitária para mostrar 
% que mesmo que o motor seja ideal 
% (dinâmica instantânea) o sistema instabiliza
	Gm = tf(1, 1);
end
