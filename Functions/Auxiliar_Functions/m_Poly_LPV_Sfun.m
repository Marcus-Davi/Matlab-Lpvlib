function [sys,x0,str,ts,simStateCompliance] = sfuntmpl(t,x,u,flag,Ts,A,B)
%PARÂMETROS ( Tempo de Amostragem, Denominador LPV, Numerador LPV)
% ATENÇÃO! NUMERADOR E DENOMINADOR DEVEM INCLUIR COEFICIENTES DOS TERMOS
% LIVRES (a0, b0) PARA GENERALIZAÇÃO. A DEPENDÊNCIA PARAMÉTRICA SERVE PARA
% AMBOS B e A. DISCORDÂNICA ENTRE DEPENDENCIAS PARAMÉTRICAS - MATRIZES COM
% NÚMERO DE COLUNAS DIFERENTES - CAUSARÁ ERRO!

% A entrada do sistema deverá ser um vetor de duas dimensões : entrada do
% bloco e entrada do parâmetro. A saída terá sempre uma dimensão.

switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes(Ts,A,B);

  %%%%%%%%%%%%%%%
  % Derivatives %
  %%%%%%%%%%%%%%%
  case 1,
    sys=mdlDerivatives(t,x,u);

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2,
    sys=mdlUpdate(t,x,u,A,B);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  case 3,
    [sys]=mdlOutputs(t,x,u,A,B);

  %%%%%%%%%%%%%%%%%%%%%%%
  % GetTimeOfNextVarHit %
  %%%%%%%%%%%%%%%%%%%%%%%
  case 4,
    sys=mdlGetTimeOfNextVarHit(t,x,u);

  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case 9,
    sys=mdlTerminate(t,x,u);

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end

% end sfuntmpl

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes(Ts,A,B)

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
%
sizes = simsizes;
[Na,~] = size(A);
[Nb,~] = size(B);
[~,N] = size(A); % dependencia paramétrica
[~,NN] = size(B);
if(N ~= NN)
   error('Dependência paramétrica diferentes! Ajeitar matrizes A,B'); 
end
U = zeros(1,Nb); %
Y = zeros(1,Na); % 
sizes.NumContStates  = 0;
sizes.NumDiscStates  = length(Y) + length(U); %memória do sistema!
sizes.NumOutputs     = 1; % [y]
sizes.NumInputs      = 2; % [u, theta]
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);

%
% initialize the initial conditions
%
x0  = zeros(1,sizes.NumDiscStates);

%
% str is always an empty matrix
%
str = [];

%
% initialize the array of sample times
%
ts  = [Ts 0];


% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'DisallowSimState' < Error out when saving or restoring the model sim state
simStateCompliance = 'UnknownSimState';

% end mdlInitializeSizes

%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u)

sys = [];

% end mdlDerivatives

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u,A,B) %Aqui a entrada está uma amostra atrasada

[Na,~] = size(A);
[Nb,~] = size(B);
[~,N] = size(A); %se N = 1 -> Nao ha dependencia

Y = x(1:Na);
U = x(Na+1:end);
if(Nb>1)
U(2) = u(1);
end
p = ones(N,1);

%Computa parametros e constitui vetor [1 p p^2 ...]
for i=1:N-1
  p(i+1) = u(2)^i;
end

%Alguns filtros
if(Na==1 && Nb>1)
    Y(1) = ((B(2:end,:)*p)'*U(2:end))* (A(1,:)*p);
elseif(Nb==1 && Na>1)
    Y(1) = (-(A(2:end,:)*p)'*Y(2:end))* (A(1,:)*p) + u(1)*B(1,:)*p;
elseif(Nb==1 && Na==1)
else % (Na > 1 && Nb > 1)
    Y(1) = (-(A(2:end,:)*p)'*Y(2:end) + (B(2:end,:)*p)'*U(2:end))* (A(1,:)*p);
end


%Atualiza
for i=Na:-1:2
   Y(i) = Y(i-1); 
end

for i=Nb:-1:2
   U(i) = U(i-1); 
end


sys = [Y;U]; %memoriza estados. Evita uso problemático de globals.

% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function [sys]=mdlOutputs(t,x,u,A,B)

%aqui implementamos a leitura na entrada porque está atualizada %(feedthrough)
[Na,~] = size(A);
[Nb,~] = size(B);
[~,N] = size(B); %se N = 1 -> Nao ha dependencia

p = ones(N,1);


for i=1:N-1
  p(i+1) = u(2)^i;
end

sys = x(1) + u(1)*B(1,:)*p; %b0 -> Feedthrough;

% end mdlOutputs

%
%=============================================================================
% mdlGetTimeOfNextVarHit
% Return the time of the next hit for this block.  Note that the result is
% absolute time.  Note that this function is only used when you specify a
% variable discrete-time sample time [-2 0] in the sample time array in
% mdlInitializeSizes.
%=============================================================================
%
function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;

% end mdlGetTimeOfNextVarHit

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u)

sys = [];

% end mdlTerminate
