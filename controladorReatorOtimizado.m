function controlador = controladorReatorOtimizado(requisitos, planta)
%projeta o controlador com ajuste fino numérico

controladorinicial = controladorReatorAnalitico(requisitos.controlador, planta);
Gplanta = obterFTMalhaFechada(planta);
Gm = obterFTMotor(planta, requisitos.motor);

x0 = [controladorinicial.K controladorinicial.Tl controladorinicial.alpha];
opcoes = optimset('Display', 'iter', 'MaxFunEvals', 2000, 'MaxIter', 2000);
J = @(x) custoControlador(requisitos, planta, Gplanta,Gm, x);
otimizacao = fminsearch(J, x0, opcoes);
controlador.K = otimizacao(1);
controlador.Tl = otimizacao(2);
controlador.alpha = otimizacao(3);

end

%implementa a função de custo

function J = custoControlador(requisitos, planta, Gplanta, Gm, parametros)

controladorReator.K = parametros(1);
controladorReator.Tl = parametros(2);
controladorReator.alpha = parametros(3);

s = tf('s');

C = controladorReator.K * (1/s) * ((controladorReator.Tl *s + 1)/(...
    controladorReator.alpha * controladorReator.Tl *s + 1));

Ga = C*Gm*Gplanta;
Gf = feedback(Ga, 1);

banda = bandwidth(Gf);
[~, PM, ~, Wcp] = margin(Ga);

J = (requisitos.controlador.wb - banda)^2 + (requisitos.controlador.PM - PM)^2;

end