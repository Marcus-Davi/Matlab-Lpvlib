% ==== Identificação LPV - abordagem global ==== 
clear; clc;

Ts = 0.05; % Intervalo de amostragem

% ==== GERAR DADOS DE ENTRADA E SAÍDA ===

% MATLAB/Simulink 2017a:
%sim('Gera_dados_local_PLMS.slx');

% MATLAB/Simulink 2015a:
sim('Gera_dados_local_PLMS_2015a.slx');

Na = 2; % Ordem do modelo ARX LPV (na=nb)
N = 1; % Ordem dos polinômios com dependência em p

%Concatena dados de entrada e saída
y=[ymin ymed ymax];
u=[umin umed umax];
p=[pmin pmed pmax];
% Algoritmo PLMS de identificação LPV local
Modelo_MA_LPV = ident_lpv_plms_sb0_loop(y,u,p,Ts,Na,N,1,0.001,'plota0',8);

% Validação do modelo LPV identificado (pode ser usado outro conjunto de dados)
%valida_mod_LPV(y(:,1),u,p,Modelo_MA_LPV,Ts,Na,N,'plota1');

% Salva modelo LPV em um arquivo txt
salva_modelo_lpv('Modelo_LPV.txt',Modelo_MA_LPV,Ts,Na,N);

maximo = max(max(p));
minimo = min(min(p));

% -------- Carrega Modelo LPV Salvo  -------- 
sdpvar teta
[B_LPV,A_LPV] = carrega_planta_lpv('Modelo_LPV.txt',teta);

% --- Gráfico com o pólos do modelo LPV estimado ----------
figure
precisao = 0.01;
plota_polos(A_LPV,teta,maximo,minimo,precisao,'Xm');

% --- Gráfico com a resposta ao degrau do modelo LPV estimado ----------
figure
plota_degrau(B_LPV,A_LPV,0,teta,maximo,minimo,0.1,Ts)             





