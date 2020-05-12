%@params
%arquivo = file name and path
%R= sdisplayed polynomial R
%S = sdisplayed polynomial S
%T = sdisplayed polynomial T
%N = RST-parameter dependency
%Ts = Sampling Time
%ex: m_salva_controlador_rst_struct('RST',sdisplay(R_LPV),sdisplay(S_LPV),sdisplay(T_LPV),Nc,Ts)
function [] = salva_controlador_rst_struct(arquivo,R,S,T,N,Ts) %Entram strings
[~,Nr] = size(R);
[~,Ns] = size(S);
Nt = 1;
format = '%f ';
for i=1:N
    if(i==1)
    anexa = '%f*teta';
    else
    anexa = strcat('%f*teta^',int2str(i));
    end
    format = strcat(format, anexa);
end


poly_r = [];
poly_s = [1 zeros(1,N)]; %mônico
% poly_t = [];
for i=1:Nr
   scan = sscanf(R{i},format);
   poly_r = [poly_r;scan'];
end

for i=2:Ns %ñ precisa ser mônicidade (?)
   scan = sscanf(S{i},format);
   poly_s = [poly_s;scan'];
end

poly_t = (sscanf(T{1},format))';

RST_LPV.R = poly_r;
RST_LPV.S = poly_s;
RST_LPV.T = poly_t;
RST_LPV.Ts = Ts;

save(arquivo,'RST_LPV');
end