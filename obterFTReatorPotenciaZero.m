function G0 = obterMalhaCorrente(planta)
% Obtem a função de transferêcnai do controador do Reator de Potência Zero, que
% relaciona a saída fracionária de potência (δN(s)/N0) com a entrada de reatividade 
% transferencia de malha aberta Ga e fechada Gf da malha de corrente.

s = tf('s');

beta = 0;
for elemento = planta.beta
	beta += elemento;
end

coeficiente = 0*s;

for i = 1:6
	coeficiente += ((planta.b)(i))/beta/(s + (planta.lambda)(i));
end

G0 = 1/s/(planta.Lambda / beta + coeficiente);


end
