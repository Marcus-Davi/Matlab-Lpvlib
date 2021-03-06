function [] = plota_frequencia(A,Ts,teta,maximo,minimo,precisao,color)             

%Valor M�nimo e M�ximo do Par�metro vari�vel
% The plotting is performed throught the discretization of the scheduling
% parameter
 hold on;
 
 for Parm=minimo:precisao:maximo,
     assign(teta,Parm);
     [MAG,Wn,Z] = ddamp(double(A),Ts);
     [En,ind]=min(Wn);
     Wn=Wn(ind)/(2*pi);
     plot(double(teta),Wn,color,'linewidth',2);
 end

 ylabel('Frequ�ncia (Hz)','fontsize',12,'FontName','arial')
 xlabel('Pot�ncia Ativa (pu)','fontsize',12,'FontName','arial')

 hold off;
 




 