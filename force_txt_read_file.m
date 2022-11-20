
% This program will open force-distance files saved from the JPK software
% (originally in .force format) as .txt files containing all information
% for force rupture data.

% addToolbarExplorationButtons(gcf) 

if exist('PN','var')
    [file,path] = uigetfile([PN(1:end-4) '.txt']);
    if length(path)>5
        PN = [path file];
    end
else
    [file,path] = uigetfile('*.txt');
    if length(path)>5
        PN = [path file];
    end
end


if isequal(file,0)
   at=1;
else
   disp(fullfile(path,file));
end

fn = fopen(PN,'r');

nline = 1;
nBlock = 1;
tline = fgetl(fn);
while ischar(tline)
    k = strfind(tline,'fancyNames:');
    if isempty(k)
    else
        break;
    end
    tline = fgetl(fn);
    nline = nline+1;
end
Names = tline(15:end);



while ischar(tline)
    k = strfind(tline,'units:');
    if isempty(k)
    else
        break;
    end
    tline = fgetl(fn);
    nline = nline+1;
end
Units = tline(10:end);


% find the start and the end of the data block
dc = 0;
isblock = 0;
block_index = 0;
tline = fgetl(fn);
nline = nline+1;
while ischar(tline)
    k = strfind(tline,'#');
    if isempty(k)
        if (isblock==0)&&(block_index == 0)
            isblock = 1;
            block_index = 1;
            A = zeros(3e6,length(str2num(tline)));
            dc = 1;
            A(dc,:) = str2num(tline);
        else
            if length(tline)>0
                dc = dc + 1;
                A(dc,:) = str2num(tline);
            end
            if dc>3e6
                disp('Warning. Large data. May be slow.')
            end
        end
    else
        if isblock == 1
            isblock = 0;
%             break;
        end
    end
    tline = fgetl(fn);
    nline = nline+1;
end
A = A(1:dc,:);

N1 = nline;

% disp(['Lines read from the file: ' num2str(nline)])
while ischar(tline)
    tline = fgetl(fn);
    nline = nline+1;
end
% disp(['Total number of lines in the file: ' num2str(nline)])
if nline>N1+1
    disp('WARNING. Not all Data imported!!!')
end


disp('Names')
disp(Names)
disp('Units')
disp(Units)
fclose(fn);
t = A(:,13);
x = A(:,1);
y = A(:,1);
%x and y refer to the columns plotted. These are the values for trap 2
%(moving trap)

figure
%plot(t,x*1e9);
%hold on
%plot(t,(y-mean(y))*1e9)
%addToolbarExplorationButtons(gcf)

% Selecting data to display for either Trap 1 or Trap 2, depending on which
% was used for the experiment. For Trap 2 data (as provided in 
% example...txt file), to plot x and y contributions:

%for Trap 1
%plot(A(:,14),A(:,1)); % x contribution 
%hold on
%plot(A(:,14),A(:,2)); % y contribution (main)
%hold on
%plot(A(:,12),A(:,3));
%hold on
%plot(A(:,13),A(:,4));
%plot(A(:,13),A(:,14))

%for Trap 2
plot(A(:,14),A(:,4)); % x contribution
hold on
plot(A(:,14),A(:,5)); % y contribution (main)
%hold on
%hold on
%plot(A(:,13),A(:,5));
%hold on

% Display data:

title('Force of rupture (pN) as a function of displacement (m)','FontSize',20)
xlabel('Displacement (m)','FontSize',14) 
ylabel('Force of rupture (pN)','FontSize',14)
%ylim([-0.000000000002 0.000000000014])
%xlim([0.000006 0.000008])
%xlim([27 47]) %needs to be 38 seconds in total
%legend({'X signal 2','Y signal 2'},'Location','southwest')
%legend({'X signal 1','Y signal 1'},'Location','southwest')

%plot(t,(A(:,5)-mean(A(:,5)))*1e9-00)
%plot(t,(A(:,6)-mean(A(:,6)))*1e9-00)
