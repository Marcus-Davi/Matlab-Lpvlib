clear; close all;clc
load('dados.mat');
Na = 2;
N = 1;
% p = p./20;
figure
subplot(3,1,1)
plot(t,y);
subplot(3,1,2);
plot(t,u);
subplot(3,1,3);
plot(t,p);
%%
figure
Modelo_MA_LPV = ident_lpv_lms_sb0_loop(y,u,p,Ts,Na,N,0.1,0.001,'plota1',100);
m_salva_planta_lpv_struct('Identificado',Modelo_MA_LPV,Na,N,Ts);

% ident_lpv_plms_sb0_loop(y,u,p,Ts,Na,N,1.5,0.001,' ',20)

