
Fhead = [26	19.5	25.4	23.9	22	31	8	39	39	13.5	35	35	45	37	30	40	23	32	29.5	15	20	23	31	20	25	30	36	30	26	25	28.6	29.1	31	17.5	26.3	17.9	26.8	18.5	20.8	25	22.3	16.2	13.8	15.5	29	25	20	20	35	30	21.2	24	15.47	21.78	17.5	15.8	28	35	25	30	22	23	9.2	28	30.8	30	19	12	12.4	33	12.6	6	24.8	24.3	20.2	22.6	19.5	32.2	28.1	33.3	33.23	19.88	14.7	19.9	24.2	14.7	26.66	11.4	15.3];
Fhinge = [15	26	20	22.8	14.6	10.6	17.2	6.7	15	15.6	17.5	20.8	19.8	20.3	23.72	28.46	24.98	18.39	17.11	24.24	13.4];
global L10 L20 D x0

v = 0.16;   % loading rate (microns/second)
L20 = 16.32;  % first DNA contour length (microns), persistence length is assumed 50 nm
L10 = 8;   % second DNA contour length (microns), persistence length is a parameter in findFandL (change for ssDNA)
delta = 1.6;   % force parameter (nm)
Ntrials = 1000;
T = zeros(Ntrials,1);
Fd = zeros(Ntrials,1);
N = 1000;
dt = 0.1;           % time step (seconds)

k0 = 2.1e-3; % detachemnt rate (inverse seconds)
F = zeros(N,1);
L = zeros(N,1);
ypos = zeros(N,1);
options = optimoptions('fsolve','Algorithm','levenberg-marquardt','Display','none');  


tic
hw = waitbar(0,'Please wait... ');

ee = rand(Ntrials,1)*1.6+8;   % this is from experimental distribution measured by Martina
for j=1:Ntrials
    r = rand(N,1);
    x = 0;
    ddx = zeros(N,1);      % displacement with respect to the center of DNA
    
    params = zeros(N,4);
    startt = [0 ee(j) 0 0];
    for i=1:N
        if ddx(i)>ee(j)/3
            ddx(i)=ee(j)/3;
        end
        x = x + dt*v;       % new position
        ypos(i) = x;
        
        fun = @findFandL;
        D = ee(j);
        x0 = x;
        t0 = startt;
        t = fsolve(fun,t0,options);
        params(i,:) = t;
        startt = t;
        F(i) = t(3);
        k = k0*exp(F(i)*delta/4.14);
        p = -log(1-r(i))/k;
        if p<= dt
            break
        end
    end
%     plot(ypos(1:5000),F(1:5000))
    T(j) = i*dt;
    Fd(j) = F(i);
        waitbar(j/Ntrials,hw);
end
toc
close(hw)
e = 1:2:50;
n = histc(Fd,e);
n = n/max(n);

nhead = histc(Fhead,e);
nhead = nhead/max(nhead);
nhinge = histc(Fhinge,e);
nhinge = nhinge/max(nhinge);


figure
hold on
plot(e,n)
plot(e,nhead)
plot(e,nhinge)
legend('simulated','head','hinge')

