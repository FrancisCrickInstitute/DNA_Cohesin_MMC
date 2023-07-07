
Fhead = [26	19.5	25.4	23.9	22	31	8	39	39	13.5	35	35	45	37	30	40	23	32	29.5	15	20	23	31	20	25	30	36	30	26	25	28.6	29.1	31	17.5	26.3	17.9	26.8	18.5	20.8	25	22.3	16.2	13.8	15.5	29	25	20	20	35	30	21.2	24	15.47	21.78	17.5	15.8	28	35	25	30	22	23	9.2	28	30.8	30	19	12	12.4	33	12.6	6	24.8	24.3	20.2	22.6	19.5	32.2	28.1	33.3	33.23	19.88	14.7	19.9	24.2	14.7	26.66	11.4	15.3];
Fhinge = [15	26	20	22.8	14.6	10.6	17.2	6.7	15	15.6	17.5	20.8	19.8	20.3	23.72	28.46	24.98	18.39	17.11	24.24	13.4];
FCChlow =[20	25	25	25	25	20	25	10	25	23	35	25	45	40];
FCChhigh = [65	65	75	73	64	69	70	70	60	75	80];
FheadCC = [19	20	22	42	22	30	35	25	25	31	23	8	20	28	16	36	9	45	33	35	21];

v = 0.16;   % loading rate (microns/second)
L0 = 16.32;  % DNA contour length (microns), persistence length is assumed 50 nm
Ntrials = 2000;
T = zeros(Ntrials,1);
Fd = zeros(Ntrials,1);
N = 10000;
dt = 0.05;           % time step (seconds)

% First interface 
delta = 1.23;   % force parameter (nm)
k0 = 0.0027; % detachemnt rate (inverse seconds)
% delta = 0.8;   % force parameter (nm)
% k0 = 2e-5; % detachemnt rate (inverse seconds)

% Second interface
delta2 = 0.8;   % force parameter (nm)
k02 = 2e-5; % detachemnt rate (inverse seconds)

% delta2 = 1.23;   % force parameter (nm)
% k02 = 0.0027; % detachemnt rate (inverse seconds)


% delta = 1.23;   % force parameter (nm)
% k0 = 0.0022; % detachemnt rate (inverse seconds)
% 
% 
% for two sets of molecules ri=1 for two interfaces, r=2 for one interface

% ri = randi(2,Ntrials,1);
% ri = ones(Ntrials,1);
ri = binornd(1,0.45,Ntrials,1);



F = zeros(N,1);
F1 = zeros(N,1);
F2 = zeros(N,1);
L1 = zeros(N,1);
L2 = zeros(N,1);
ypos = zeros(N,1);

ee = (rand(Ntrials,1)*1.6+8);   % this is from experimental distribution measured by Martina
ddx = randn(Ntrials,1)*0.2; % relative displacement with respect to the center of DNA. Distribution from Matina's data

for j=1:Ntrials
    r = rand(N,2);
    x = 0;

    L10 = L0*(0.5-ddx(j));
    L20 = L0*(0.5+ddx(j));
    for i=1:N
        x = x + dt*v;       % new position
        ypos(i) = x;
        L1(i) = sqrt((ee(j)*(0.5-ddx(j)))^2 + x*x);
        L2(i) = sqrt((ee(j)*(0.5+ddx(j)))^2 + x*x);
        if L1(i)>=0.9999999999999*L10
            L1(i) = 0.9999999999999*L10;
        end
        if L2(i)>=0.9999999999999*L20
            L2(i) = 0.9999999999999*L20;
        end
        F1(i) = 0.0828*(0.25/(1-L1(i)/L10)/(1-L1(i)/L10)-0.25+L1(i)/L10);  % new force in pN
        F2(i) = 0.0828*(0.25/(1-L2(i)/L20)/(1-L2(i)/L20)-0.25+L2(i)/L20);  % new force in pN
        alpha = atan(x/ee(j)/(0.5-ddx(j)));
        beta = atan(x/ee(j)/(0.5+ddx(j)));
        Fx = F2(i)*cos(pi/2-beta) + F1(i)*cos(pi/2-alpha);
        Fy = F2(i)*sin(pi/2-beta) - F1(i)*sin(pi/2-alpha);
        F(i) = sqrt(Fx*Fx+Fy*Fy);
%         if ri(j)==1
            k = k0*exp(F(i)*delta/4.14);
            p = -log(1-r(i,1))/k;
            if p<= dt
                break
            end
            k = k02*exp(F(i)*delta2/4.14);
            p = -log(1-r(i,2))/k;
            if p<= dt
                break
            end
%         else
%             k = k02*exp(F(i)*delta2/4.14);
%             p = -log(1-r(i,2))/k;
%             if p<= dt
%                 break
%             end
%         end
    end
    T(j) = i*dt;
%     plot(dt*(1:i),F(1:i))
    if i<N
        Fd(j) = F(i);
    else
        Fd(j) = 9e99;
    end
end
e = 1:2:100;
n = histc(Fd,e);
n = n/sum(n);
e=e';
mn = sum(e.*n);
sn = sqrt(sum(n.*(e-mn).*(e-mn)));



nhead = histc(Fhead,e);
nhead = nhead/max(nhead);

nhinge = histc(Fhinge,e);
nhinge = nhinge/max(nhinge);

nhinge = histc(FheadCC,e);
nhinge = nhinge/max(nhinge);


n = n/max(n);
figure
hold on
n = movmean(n,5);
n = n/max(n);
plot(e,n)
plot(e,nhead)
plot(e,nhinge)
% plot(e,nc)
legend('simulated','head','hinge')

