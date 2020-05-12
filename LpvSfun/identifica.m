clear; close all;clc
load('dados_boost_prbs.mat');
Na = 1;
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

ident_lpv_lms_sb0_loop(y,u,p,Ts,Na,N,1.5,0.1,' ',20)
% ident_lpv_plms_sb0_loop(y,u,p,Ts,Na,N,1.5,0.001,' ',20)

