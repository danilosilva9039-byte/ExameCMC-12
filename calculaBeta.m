function beta = calculaBeta(planta)

%calcula o valor de beta

	beta = 0;
	for elemento = planta.beta
		beta += elemento;
	end
end
