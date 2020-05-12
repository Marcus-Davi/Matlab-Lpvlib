clear; clc; close all

%Exemplo de projeto de controlador RST LPV
%I) Carrega modelo da planta
%II) Especifia��o de desempenho para o sistema em MF
%III) Projeta Controladores RST fixos
%IV) Projeta Controladore LPV
%V) Simula�ao do sistema LPV em MF
%VI) Compara��o entre polos de MF com controladores LTI e LPV

%Define par�metro externo incerto
sdpvar teta
minimo = 0.1; % teta E [0.1 0.9]
maximo = 0.9;

% I) ==== CARREGA MODELO LPV ====

Ts=0.05;  % Intervalo de amostragem
%Carrega Modelo LPV armazenado no arquivo .txt
arq_mod_LPV = 'Modelo_LPV_exemplo.txt'; %Modelo_LPV.txt Original

[B_LPV,A_LPV] = carrega_planta_lpv(arq_mod_LPV,teta);
d=0; % discrete time delay
% B_LPV e A_LPV s�o polin�mios dependentes de teta

% ----------------- Resposta ao Degrau --------------------
figure
% plota resposta ao degrau do modelo LPV para diferentes valores de teta
plota_degrau(B_LPV,A_LPV,d,teta,maximo,minimo,0.1,Ts);
title('Resposta ao degrau do modelo LPV para teta=[0.1 0.9]');
figure
% plota polos do modelo LPV para diferentes valores de teta
plota_polos(A_LPV,teta,maximo,minimo,0.01,'Xm'); % polos de MA do modelo LPV
title('Polos do modelo LPV para teta=[0.1 0.9]');
% Planta de 2a ordem com grande vaira�ao param�trica. Notem a grande
% varia�ao dos polos

%% II) ==== ESPECIFICA��O DE DESEMPENHO PARA O SISTEMA EM MF ====

Tr = 0.5;             % tempo de subida em seg. (IMPORTANTE.: Tr>=4*Ts)
MaxOvershoot = 0;   % m�xima ultrapassagem percentual MO%
Pd = CL_Perf(Tr,MaxOvershoot,Ts);  
% Pd cont�m 2 polos dominantes desejados para o sistema em MF

%% III ) ==== PROJETO DE CONTROLADORES RST A PAR�METROS FIXOS ====

% Inclus�o de filtros pr�-fixados nos polin�mios R e S
% S = S'Hs  e R = R'Hr 
Hs = [1 -1];  % A��o integral
Hr = 1;      

% Projeto de controlador RST linear na condi��o de valor de teta  m�nimo
teta_min = minimo;
assign(teta,teta_min);
B_fixo = double(B_LPV);
A_fixo = double(A_LPV);
[R_min,S_min,T_min,Acl_min] = PP(B_fixo,A_fixo,d,Hs,Hr,Pd,Ts);
% A fun��o PP realiza o projeto de controlador RST por aloca��o de polos
% Dependendo da ordem de B e A, polos auxiliares ser�o necess�rios.
% Ex.: [-0.2 -0.3]

% Projeto de controlador RST linear na condi��o de valor de teta m�dio
teta_med = ((maximo-minimo)/2)+minimo;  
assign(teta,teta_med);
B_fixo = double(B_LPV);
A_fixo = double(A_LPV);
[R_med,S_med,T_med,Acl_med] = PP(B_fixo,A_fixo,d,Hs,Hr,Pd,Ts);

% Projeto de controlador RST linear na condi��o de valor de teta m�ximo
teta_max = maximo;
assign(teta,teta_max);
B_fixo = double(B_LPV);
A_fixo = double(A_LPV);
[R_max,S_max,T_max,Acl_max] = PP(B_fixo,A_fixo,d,Hs,Hr,Pd,Ts);

figure 
hold on
plot(roots(Acl_min),'Xb');
plot(roots(Acl_med),'Xr');
plot(roots(Acl_max),'Xk');
title('Polos do sistema em malha-fechada com os controladores fixos')
zgrid;

%% IV ) ==== PROJETO DO CONTROLADOR LPV ====
Nc = 1;  %grau de depend�ncia do controlador LPV em teta
Gama = 0.0001;   % Limitante da norma Hoo - Incerteza n�o-estruturada
% Quanto menor esse valor, mais confinada fica a regi�o de polos de MF
C = Acl_med; %Polin�mio central
% O polin�mio C � um "alvo" para os polos de MF. 
[R_out,S_out] = gain_schd_lpv_RST(B_LPV,A_LPV,teta,d,C,Hr,Hs,Nc,maximo,minimo,Ts,Gama);
% gain_schd_lpv_RST � a fun��o que resolve as PLMIs do problema LPV

salva_controlador('K_LPV_RST.txt',R_out,S_out,Ts);
% salva controlador calculado em arquivo .txt
 
clear R_LPV;
clear S_LPV;
[R_LPV,S_LPV] = carrega_controlador('K_LPV_RST.txt',teta);
% PQ NAO EXPORTAR JÀ COM PRÉ FILTROS ??
R_LPV = convolucao(R_LPV,Hr);
S_LPV = convolucao(S_LPV,Hs);
T_LPV = R_LPV(1)+R_LPV(2)+R_LPV(3); 
% Polinomio T(z,teta) = R(1,teta). Ou seja, igual o ganho est�tico de R.
% Ou seja, T(z,teta) � um ganho que depende de teta. 
% Garante ganho est�tico unit�rio para o sitema de MF

% Plota compara�ao entre os polos de MF e MA do sistema LPV
figure
Acl_LPV=convolucao(A_LPV,S_LPV) + convolucao([zeros(1,d) B_LPV],R_LPV);  %Func. de tranf. de malha fechada 
plota_polos(A_LPV,teta,maximo,minimo,0.01,'Xm');    % polos de MA do modelo LPV
plota_polos(Acl_LPV,teta,maximo,minimo,0.01,'Xc'); % polos de MF do sist. LPV
hold on
plot(roots(C),'Xk')       % polos alvos especificados no polinomio central C
title('Modelo LPV(magenta), polos alvo roots(C(z)) (Preto) e MF com contr. LPV(ciano)')

%% V) SIMULA��O DO SISTEMA LPV

% Simula��o para diversos valores de teta entre [min max]
% Simula��o com seguimento de refer�ncia e rejei��o de dist�rbios
% A amplitude e o tempo dos dist�rbios podem ser ajustados no arquivo simulaRTS_LPV.slx
tsim = 10;   % Tempo de simula��o
figure

 for Parm=minimo:0.1:maximo,
    assign(teta,Parm);
    Tsim = double(T_LPV);
    Bsim = double([zeros(1,d) B_LPV]);
    Asim = double(A_LPV);
    Rsim = double(R_LPV);
    Ssim = double(S_LPV);
    
  %  sim('simula_RST_LPV.slx'); %MATLAB 2017A:

    sim('simula_RST_LPV_2015a.slx');    %MATLAB 2015a:
    
    plot(time,ysim,'r',time,rsim,'k--');
    hold on;
 end
 xlabel('Tempo (segundos)');
 title('Simula��o do sistema ');
 
 grid;    
 hold off;

%% ==== COMPARA��O POLOS DE MF FIXO X MF LPV ====

% Polos de malha fechada com os controladores LTI
figure
Acl_fixo_min_LPV = convolucao(A_LPV,S_min) + convolucao([zeros(1,d) B_LPV],R_min);  
Acl_fixo_med_LPV = convolucao(A_LPV,S_med) + convolucao([zeros(1,d) B_LPV],R_med); 
Acl_fixo_max_LPV = convolucao(A_LPV,S_max) + convolucao([zeros(1,d) B_LPV],R_max); 
plota_polos(Acl_fixo_min_LPV,teta,maximo,minimo,0.005,'Xb');
plota_polos(Acl_fixo_med_LPV,teta,maximo,minimo,0.005,'Xr');
plota_polos(Acl_fixo_max_LPV,teta,maximo,minimo,0.005,'Xk');
% Polos de malha fechada com o controlador LPV
plota_polos(Acl_LPV,teta,maximo,minimo,0.01,'Xc'); % polos de MF do sist. LPV
title('Polos de MF: cont. LTI (azul, vermelho e preto) x LPV(ciano)')
