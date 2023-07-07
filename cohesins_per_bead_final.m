% coh_per_bead_2.m
% If p(N) is probability of having N cohesins per DNA and
% p(B) is B the probability of having B beads per DNA
% What is the probability of having N cohesins per bead? 


% number of DNA molecules
N = 10000;

% efficiency of the bead/cohesin interaction 
lambda = 0:0.001:0.7;
% lambda = 0.045;
bead_fraction = zeros(size(lambda));
cohesins_per_bead = zeros(size(lambda));


for k=1:length(lambda)
    % number cohesins per DNA
    pn1 = poissrnd(1.8,N,1);  % monomers (from experiment)
    pn2 = poissrnd(0.5,N,1);  % dimers  (from experiment)

    % number of beads per DNA
    pb = zeros(size(pn1));

    % number of cohesins per bead
    pc = zeros(size(pn1));


    r1 = rand(N,100);
    r2 = rand(N,1);
    r3 = rand(N,1);

    % probability of bead binding
    ic = 0;
    for i=1:N
        % if there is at least one cohesin on DNA bind a bead with
        % probability lambda
        if r2(i)<pn1(i)*lambda(k)
            % bead attached to this DNA
            pb(i) = 1;
            ic = ic + 1;
            pc(ic) = 1;
            % if there are more cohesins on the bead bind them in two
            % cases. If they are closer than 1 micron, bind them with 100%
            % probability (all DNA is ~8 microns). If there are further
            % away, bind with probability lambda
            for j=1:pn1(i)-1
                if (r1(i,j)<lambda(k))||(r3(i)<1/8)
                    pc(ic) = pc(ic) + 1;
                end
            end
        elseif pn1(i)==0  % if no monomers (~25% cases) assume it is a dimer and bind a bead with probability 2*lambda
            if r2(i)<2*lambda(k)
                pb(i) = 1;
                ic = ic + 1;
                pc(ic) = 2;
            end
        end
    end
    % pc is the distribution of the number of cohesins per bead
    pc = pc(1:ic);
    bead_fraction(k) = sum(pb)/length(pb);
    cohesins_per_bead(k) = sum(pc(pc<2))/length(pc);
    at=1;
end

figure
subplot(2,1,1)
plot(lambda,bead_fraction)
hold on
plot(lambda,cohesins_per_bead)
xlabel('lambda - probability of a bead binding cohesin')
legend('bead fraction','fraction of beads with 1 cohesin')
grid on
subplot(2,1,2)
plot(bead_fraction,cohesins_per_bead,'.')
xlabel('number of beads per DNA')
ylabel('fraction of beads with 1 cohesin')
grid on


% Calculate for optimized lambda
% number of DNA molecules
N = 10000;

% efficiency of the bead/cohesin interaction 
lambda = 0.045;
bead_fraction = zeros(size(lambda));
cohesins_per_bead = zeros(size(lambda));

for k=1:length(lambda)
    % number cohesins per DNA
    pn1 = poissrnd(1.8,N,1);  % monomers (from experiment)
    pn2 = poissrnd(0.5,N,1);  % dimers  (from experiment)

    % number of beads per DNA
    pb = zeros(size(pn1));

    % number of cohesins per bead
    pc = zeros(size(pn1));

    r1 = rand(N,100);
    r2 = rand(N,1);
    r3 = rand(N,1);

    % probability of bead binding
    ic = 0;
    for i=1:N
        % if there is at least one cohesin on DNA bind a bead with
        % probability lambda
        if r2(i)<pn1(i)*lambda(k)
            % bead attached to this DNA
            pb(i) = 1;
            ic = ic + 1;
            pc(ic) = 1;
            % if there are more cohesins on the bead bind them in two
            % cases. If they are closer than 1 micron, bind them with 100%
            % probability (all DNA is ~8 microns). If there are further
            % away, bind with probability lambda
            for j=1:pn1(i)-1
                if (r1(i,j)<lambda(k))||(r3(i)<1/8)
                    pc(ic) = pc(ic) + 1;
                end
            end
        elseif pn1(i)==0  % if no monomers (~25% cases) assume it is a dimer and bind a bead with probability 2*lambda
            if r2(i)<2*lambda(k)
                pb(i) = 1;
                ic = ic + 1;
                pc(ic) = 2;
            end
        end
    end
    % pc is the distribution of the number of cohesins per bead
    pc = pc(1:ic);
    bead_fraction(k) = sum(pb)/length(pb);
    cohesins_per_bead(k) = sum(pc(pc<2))/length(pc);
    at=1;
end

figure
[n,x]=hist(pc,25);
n=n/sum(n);
bar(x,n);
xlabel('Number of cohesins per bead')
ylabel('Probabiliy')

