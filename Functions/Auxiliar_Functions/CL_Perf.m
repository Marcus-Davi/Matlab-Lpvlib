function [Pd] = CL_Perf(Tr,MaxOvershoot,Ts)

% --------   Closed loop performance specification  ----------
[Wo,Qsi]=omega_dmp(Tr,MaxOvershoot);
Hc = tf([Wo^2],[1  2*Wo*Qsi Wo^2]);
% --------   Sampling rate definition  ----------
% Sample time ( 0.25 < WoTs < 1.5 ) - minimal value with 1 decimal digit
%Ts = round((0.25/Wo)*10)/10;
% --------   Discretization of desired polynomial  ----------
Hd = c2d(Hc,Ts,'zoh');  % Discretized desired CL polynomial
[Bd,Pd]=tfdata(Hd,'v');
%Polos_d = roots(Ad);
%Pd = poly([Polos_d(1) Polos_d(2)]);