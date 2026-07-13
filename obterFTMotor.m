function Gm = obterFTMotor(planta, requisitos)
%obtem a funcao de transferencia do motor
%Como foi mostrado no relatório, o sistema
% de controle projetado instabiliza independente
% dos ganhos. Para mostrar isso definimos
% a FT do motor como unitária para mostrar 
% que mesmo que o motor seja ideal 
% (dinâmica instantânea) o sistema instabiliza
	s = tf('s');

    Km = planta.vazaomotor; 
    Taum = planta.taumotor;
    
    % Planta de Malha Aberta do Motor
    % É fictícia mas factível pois é razoável
    % modelar um motor qualquer com um ganho 
    % e um tempo característica causada pela inércia
    Gbomba = Km / (Taum * s + 1);

    wm = requisitos.wb;

    %define os ganhos para que atenda aos requisitos 
    Kp = (wm * Taum) / Km;
    Ki = wm / Km;

    Cmotor = Kp + Ki / s;

    Gm = feedback(Cmotor * Gbomba, 1);
    
    %cancela os possíveis zeros e polos
    Gm = minreal(Gm);
end
