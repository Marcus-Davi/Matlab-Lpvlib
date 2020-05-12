function [] = plota_degrau(N,D,d,teta,maximo,minimo,precisao,Ts)             

%Valor M�nimo e M�ximo do Par�metro vari�vel
% The plotting is performed throught the discretization of the scheduling
% parameter
 hold on;
 for Parm=minimo:precisao:maximo,
     assign(teta,Parm);
     SYS = tf(double(N),double(D),Ts,'InputDelay',d);
     step(SYS);
 end
 hold off;

 