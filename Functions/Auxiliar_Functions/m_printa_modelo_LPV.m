% Modelo = B/A (Arx)
%@args (Matriz do Modelo LPV, Ordem A, Ordem B, Ordem Parametros)

function [] = printa_modelo_lpv(Modelo,Na,Nb,Np)
fprintf('NA = %d, NB = %d,Np = %d\n\n\n',Na,Nb,Np);
A = '1 + ';
for i=1:Na
    A = strcat(A,' (');
    A = strcat(A,num2str(Modelo(i,1)));
   for j=1:Np 
       if(Modelo(i,j+1) > 0)
    A = strcat(A,' +',num2str(Modelo(i,j+1)),'p^',num2str(j)) ;
       else
     A = strcat(A,num2str(Modelo(i,j+1)),'p^',num2str(j)) ;
       end
   end
   A = strcat(A,')','z^',num2str(-i),' + ');
end
A = A(1:end-1);
B = '';
for i=1:Nb
    B = strcat(B,'(');
    B = strcat(B,num2str(Modelo(Na+i+1,1)));
   for j=1:Np 
      if(Modelo(Na+i+1,j+1) > 0)
    B = strcat(B,'+',num2str(Modelo(Na+i+1,j+1)),'p^',num2str(j)) ;
       else
    B = strcat(B,num2str(Modelo(Na+i+1,j+1)),'p^',num2str(j)) ;
       end   

   end
   B = strcat(B,')','z^',num2str(-i),' + ');
end
B = B(1:end-1);
div = repmat('-',1,length(A));
fprintf('\t%s \n M = \t%s \n \t%s\n\n\n',B,div,A);
end
