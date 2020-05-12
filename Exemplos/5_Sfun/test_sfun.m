clear ; close all;clc
s = tf('s');
W_n = 4;
Ts = 0.1;
Qsi = 0.3;
Qsi_2 = 0.1;
H1 = W_n^2/(s^2 + 2*Qsi*W_n*s + W_n^2);
H2 = W_n^2/(s^2 + 2*Qsi_2*W_n*s + W_n^2);


H1z = c2d(H1,Ts); %Rn
H2z = c2d(H2,Ts); %Rn2

%calcula dependencia LPV baseado nas TFs discretas

M = [1 Qsi;1 Qsi_2];
b1 = inv(M)*[H1z.Num{1}(2); H2z.Num{1}(2)];
b2 = inv(M)*[H1z.Num{1}(3); H2z.Num{1}(3)];

a1 = inv(M)*[H1z.Den{1}(2); H2z.Den{1}(2)];
a2 = inv(M)*[H1z.Den{1}(3); H2z.Den{1}(3)];

B = [0 0;b1';b2']
A = [1 0;a1';a2']

load('Identificado.mat')

A_ident = Modelo.A;
B_ident = Modelo.B;

Tsim=200;
sim('LPV_Simula_SFUN')
%% Armazena
t = d_in.time;
u = d_in.data;
y = v_out.data;
p = p_out.data;
y_id = id_out.data;
save('dados.mat','t','u','y','p','Ts')
%% Plota
close all
subplot(3,1,1)
plot(t,y);
subplot(3,1,2)
plot(t,u)
subplot(3,1,3)
plot(t,p)

figure
plot(t,y);hold on;
plot(t,y_id);
grid on;
legend('Planta','Identificado')