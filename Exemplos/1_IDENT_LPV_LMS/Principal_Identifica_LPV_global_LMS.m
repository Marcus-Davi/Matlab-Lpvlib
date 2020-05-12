% ==== Identifica��o LPV - abordagem global ==== 
clear; clc; close all

Ts = 0.05; % Intervalo de amostragem

% ==== GERAR DADOS DE ENTRADA E SA�DA ===

% MATLAB/Simulink 2017a:
%sim('Gera_dados_global_LMS.mdl');

% MATLAB/Simulink 2015a:
sim('Gera_dados_global_LMS.mdl');

Na = 2; % Ordem do modelo ARX LPV (na=nb)
N = 1; % Ordem dos polin�mios com depend�ncia em p

% Algoritmo LMS de identifica��o LPV 
Modelo_MA_LPV = ident_lpv_lms_sb0_loop(y,u,p,Ts,Na,N,0.5,0.01,'plota1',50);

% Valida��o do modelo LPV identificado (pode ser usado outro conjunto de dados)
valida_mod_LPV(y,u,p,Modelo_MA_LPV,Ts,Na,N,'plota1');

% Salva modelo LPV em um arquivo txt
salva_modelo_lpv('Modelo_LPV_exemplo.txt',Modelo_MA_LPV,Ts,Na,N);

printa_modelo_LPV(Modelo_MA_LPV,Na,Na,N);
maximo = max(p);
minimo = min(p);

%% ------------------------- PLMS LPV ------------------------------

% sim('Gera_dados_local_PLMS.slx');
% Ts = 0.05; % Intervalo de amostragem
% Na = 2; % Ordem do modelo ARX LPV (na=nb)
% N = 1; % Ordem dos polin�mios com depend�ncia em p
% 
% maximo = 0.9;
% minimo = 0.1;
% 
% y=[ymin ymed ymax];
% u=[umin umed umax];
% p=[pmin pmed pmax];
% 
% Modelo_MA_LPV = ident_lpv_plms_sb0_loop(y,u,p,Ts,Na,N,0.5,0.05,'plota0',10);
% 

%% -------- Carrega Modelo LPV Salvo  -------- 
sdpvar teta
[B_LPV,A_LPV] = carrega_planta_lpv('Modelo_LPV_exemplo.txt',teta);

% --- Gr�fico com o p�los do modelo LPV estimado ----------
figure
precisao = 0.01;
plota_polos(A_LPV,teta,maximo,minimo,precisao,'Xm');

% --- Gr�fico com a resposta ao degrau do modelo LPV estimado ----------
figure
plota_degrau(B_LPV,A_LPV,0,teta,maximo,minimo,0.1,Ts)             





