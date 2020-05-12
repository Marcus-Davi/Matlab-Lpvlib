function [] = plota_amortecimento(A,Ts,teta,maximo,minimo,precisao,color)             

%Valor Mínimo e Máximo do Parâmetro variável
% The plotting is performed throught the discretization of the scheduling
% parameter
 hold on;
 for Parm=minimo:precisao:maximo,
     assign(teta,Parm);
     [MAG,Wn,Z] = ddamp(double(A),Ts);
     double(A);
     [En,ind]=min(Z);
     plot(double(teta),En,color,'linewidth',2);
 end
 hold off;
 
 ylabel('Amortecimento Relativo','fontsize',12,'FontName','arial');
 xlabel('Potência Ativa (pu)','fontsize',12,'FontName','arial');



 