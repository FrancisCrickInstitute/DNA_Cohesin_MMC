% this program bootstraps the data to see how well fitting performs on
% smaller data sets
Fhead0 = [26	19.5	25.4	23.9	22	31	8	39	39	13.5	35	35	45	37	30	40	23	32	29.5	15	20	23	31	20	25	30	36	30	26	25	28.6	29.1	31	17.5	26.3	17.9	26.8	18.5	20.8	25	22.3	16.2	13.8	15.5	29	25	20	20	35	30	21.2	24	15.47	21.78	17.5	15.8	28	35	25	30	22	23	9.2	28	30.8	30	19	12	12.4	33	12.6	6	24.8	24.3	20.2	22.6	19.5	32.2	28.1	33.3	33.23	19.88	14.7	19.9	24.2	14.7	26.66	11.4	15.3];
Fhinge0 = [15	26	20	22.8	14.6	10.6	17.2	6.7	15	15.6	17.5	20.8	19.8	20.3	23.72	28.46	24.98	18.39	17.11	24.24	13.4];
FheadL = length(Fhead0);
FhingeL = length(Fhinge0);
global Forces


Ntrials = 1:20;

k0_head = zeros(length(Ntrials), 20);
k0_hinge = zeros(length(Ntrials), 20);

d_head = zeros(length(Ntrials), 20);
d_hinge = zeros(length(Ntrials), 20);

for li=1:5:length(Ntrials)
    for lj=1:3 % 20 trials for each N
        n1 = randperm(FheadL);
        Fhead = Fhead0(n1(1:li));
        n2 = randperm(FhingeL);
        Fhinge = Fhinge0(n2(1:li));
        Forces = Fhead;
        golden_2D_for_bootstrap
        k0_head(li,lj) = k0;
        d_head(li,lj) = delta;
        Forces = Fhinge;
        golden_2D_for_bootstrap
        k0_hinge(li,lj) = k0;
        d_hinge(li,lj) = delta;
    end
    disp(['iter ' num2str(li) ' done'])
end
n1 = 5:5:length(Ntrials);
n2 = 1:3;
k0 = k0_hinge(n1,n2);
d = d_hinge(n1,n2);
k0 = [k0 mean(k0,2) std(k0,0,2)];
d = [d mean(d,2) std(d,0,2)];

