% f=@(x,y) sqrt(3*(x-0.5)*4*(y-0.1)); % enter the function
% code from https://iopscience.iop.org/article/10.1088/1757-899X/577/1/012175

f=@(x,y) One_DNAs_fun([x y]); % enter the function (d, k0)
% a1 = 0; % lower bound for variable x
% b1 = 1; % upper bound for variable x
% a2 = 0; % lower bound for variable y
% b2 = 1; % upper bound for variable y
a1 = 1; % lower bound for variable x
b1 = 2; % upper bound for variable x
a2 = 1e-3; % lower bound for variable y
b2 = 5e-3; % upper bound for variable y
epsilon = 0.00000001;	% termination criteria
tau=double((sqrt(5)-1)/2);  % golden number
k=0; % number of iterations
x1= a1+(1-tau)*( b1- a1); x2= a1+(tau)*( b1- a1);
y1= a2+(1-tau)*( b2- a2); y2= a2+(tau)*( b2- a2);
ek=[x1,y1]; % Point A
fk=[x1,y2]; % Point C
hk=[x2,y1]; % Point B
gk=[x2,y2]; % Point D
fek=f(x1,y1);ffk=f(x1,y2);fhk=f(x2,y1);fgk=f(x2,y2); % function values at points A, B, C and D.
hw = waitbar(0,'Please wait... ');
while sqrt((b1-a1)^2+(b2-a2)^2) > epsilon % termination condition
    k=k+1;
    min1=min([fek,fhk,ffk,fgk]);
    if min1==fek
        b1=x2; b2=y2;
    elseif min1==ffk
        b1=x2; a2=y1;
    elseif min1==fgk
        a1 =x1; a2 =y1;
    elseif min1==fhk
        a1=x1; b2 =y2;
    end
    x1= a1+(1-tau)*( b1- a1); x2= a1+(tau)*( b1- a1);
    y1= a2+(1-tau)*( b2- a2); y2= a2+(tau)*( b2- a2);
    fek=f(x1,y1);ffk=f(x1,y2);fhk=f(x2,y1);fgk=f(x2,y2);
    min1=min([fek,fhk,ffk,fgk]);
    waitbar(k/50,hw);
end
close(hw)
if min1==fek
%     disp(['minimum at the point ' num2str(x1) ' ' num2str(y1)]);
    delta = x1;
    k0 = y1;
elseif min1==ffk
%     disp(['minimum at the point ' num2str(x1) ' ' num2str(y2)]);
    delta = x1;
    k0 = y2;
elseif min1==fhk
%     disp(['minimum at the point ' num2str(x2) ' ' num2str(y1)]);
    delta = x2;
    k0 = y1;
elseif min1==fgk
%     disp(['minimum at the point ' num2str(x2) ' ' num2str(y2)]);
    delta = x2;
    k0 = y2;
end
% disp(['minimum value ' num2str(min1)])
% disp(['number of iterations ' num2str(k)])

