function t = tempo(E,ts)             

n=length(E);
t=[0:ts:(n*ts)];
t=t';
t=t(1:n);

% [rows,columns] = size(y);
% if rows<columns,
%     y=y';
%     u=u';
%     p=p';
% end