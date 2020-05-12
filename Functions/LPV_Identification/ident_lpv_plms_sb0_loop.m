function Theta_k = ident_lpv_plms_sb0_loop(y,u,p,Ts,Na,N,alpha_max,alpha_min,grafico,loop)             
% Algorithm for Identification of input-output discrete-time LPV models with polynomial dependence on scheduling parameters
% Authors: Fabrício Gonzalez Nogueira / Walter Barra Jr. 
% Date: 31/05/2011

%Input-output collected data y(k), u(k) and p(k)
% y = Plant output
% u = Plant input
% p = Parameter-varying
% Ts = Sample Time
% Na = Nb = Model Order - Na and Nb
% N = Polynomial Functions Order 

[T,Pontos] = size(y);

Nb=Na;
N=N+1; 

n = Na+Nb; % Number of parametric functions to be identified

Theta_k = zeros(n,N);% Matrix of Estimated Parameters at time k

% Least Means Square Algorithm (LMS)

k=Na+1;

FiY = zeros(Na,Pontos);
FiU = zeros(Na,Pontos);

iteracoes = T-k;
passos = round([(iteracoes/10)+k:(iteracoes/10):iteracoes+k]);
contador = 1;

% display(' ');
% display('--------------------------------------------------------------------');
% display('|     Programa para Identificação de Modelos LPV  (P-LMS)          |');
% display('--------------------------------------------------------------------');
% display(sprintf('Pontos de Operação: %g',Pontos));
% display(sprintf('Ordem dos polinômios A e B (Na=Nb): %g',Na));
% display(sprintf('Ordem da função paramétrica (N-1): %g',N-1));
% display(' ');
% display('Estimação Iniciada...');

cont_loop = 1;
id = zeros(1,loop);

tic
while k<T,
    
    % Fi(k) = [-y(k-1)... -y(k-Na) | u(k) ... u(k-Nb) ]

    for i=1:Na,
        FiY(i,:) = [-y(k-i,:)];
    end

    for i=1:Nb,
        FiU(i,:) = [u(k-i,:)];
    end
   
    Fi_k = [FiY; FiU];
    
    % Pi(k) = [1 p(k) .. p(k)^(N-1)]
     for i=1:N,
        Pi_k(i,:) = [(p(k,:)).^(i-1)];        
    end
    
    % Regressor Matrix - I/O data and parameter trajectories
    % 
   
    for i=1:Pontos,
        Psi_k(:,:,i)= Fi_k(:,i)*Pi_k(:,i)';
    end
   
    for i=1:Pontos,
        %E(k,i)= y(k,i)- trace(Theta_k'*Psi_k(:,:,i));
        E(i)= y(k,i)- trace(Theta_k'*Psi_k(:,:,i));
    end
    
    alpha = alpha_max - (((k+T*(cont_loop-1))/(loop*T))*(alpha_max-alpha_min));
    %alpha = alpha_max - ((k/T)*(alpha_max-alpha_min));
    
    for i=1:Pontos,
        inc_p(:,:,i) = alpha*E(i)*Psi_k(:,:,i);
    end

    inc = inc_p(:,:,1);
    for i=2:Pontos,
        inc = inc+inc_p(:,:,i);
    end
    
    Theta_k1 = Theta_k + inc;  % atualiza a matriz de parâmetros atual
            
    Theta_k = Theta_k1;  % armazena parâmetros atual

    if grafico=='plota2', 
        Theta(:,:,k) = Theta_k;
    end
        
    k=k+1;
    
    if(k==T),
        Modelo = [Theta_k((1:Na),1:N); zeros(1,N); Theta_k((Na+1:Na+Nb),1:N)];
        for i=1:Pontos,
            id(cont_loop,i) = valida_mod_LPV(y(:,i),u(:,i),p(:,i),Modelo,Ts,Na,N-1,'plota0');
        end
        display(sprintf('Loop: %g | Alpha: %.5g | Desempenho: %.5g o/o | %.5g o/o | %.5g o/o | ',cont_loop, alpha, id(cont_loop,1),id(cont_loop,2),id(cont_loop,3)));
        if(cont_loop~=loop),
            k = Na+1;
        end
        %Theta_k = zeros(n,N);
        cont_loop = cont_loop+1;
    end
    
    if k == (passos(contador)),
        %display(sprintf('Concluído: %i o/o ',contador*10))
        contador = contador+1;
    end

    
end

if grafico=='plota2', 
    figure
    hold on
    for i=1:Pontos
        plot(E(:,i)','b');
    end
    hold off
end

%Evolution of the Parameters During Estimation 

if grafico=='plota2', 
    l=1;
    figure
    hold on

    P= [];
    for i=1:n,
        for j=1:N,
            P(l,:) = Theta(i,j,:);
            plot(P(l,:))
            l=l+1;
        end
    end
    hold off
end

Theta_k = [Theta_k((1:Na),1:N); zeros(1,N); Theta_k((Na+1:Na+Nb),1:N)];
