
% This program is used to determine the size of the bleaching step from
% single-molecule data. It uses stack images (tiff) opened by the
% load_stack program and allows clicking on individual dots 
% (fluorescently-labelled molecule; left click) and background intensity
% (right click) to determine their brightness. It also takes
% several (6 default) consequetive frames for each clicked dot.
% CA = [950 1500];

% The examples provided are for obtaining a photobleaching trace of the 
% fluorescent molecule. 
% One shows a larger field of view (to distinguish between
% other fluorescent signals) with the fluorescently-labelled molecule in
% question found in the centre of the field of view. The molecule was
% previously identified as active and photobleaching through preliminary
% analysis on FIJI, which confirmed it moving on the DNA.
% The other shows a close-up on the specific molecule.

szA = size(A);
i=0;
S = squeeze(A(:,:,1));
figure
Smin = min(min(S));
Smax = max(max(S));
% S = (S-Smin)/(Smax-Smin)*256;
imagesc(S)

[n,x]=hist(S(:),1000);
%f = fit(x',n','gauss1');
% caxis([f.b1-4*f.c1 f.b1+4*f.c1]);
% caxis([200 2200])
% akZoom;
% colormap gray
hold on
M = [];
Mbg = [];
ic = 0;
icbg = 0;
i=1;
if exist('aMT','var')
    sza = size(aMT);
    for q=1:max(sza)/2
        plot([aMT((q-1)*2+1,1) aMT(q*2,1)],[aMT((q-1)*2+1,2) aMT(q*2,2)],'k');
    end
end
GO = 1;
REGION = 3;
while i<szA(3)
    [x, y, button] = ginput;
    for j=1:max(size(x))
        if button(j)==1
                for k=i:i+GO
                    if (round(y(j))-3>0)&&(round(y(j))+3<szA(1))&&(round(x(j))-3>0)&&(round(x(j))+3<szA(2))
                        x1 = round(y(j))-REGION;
                        x2 = round(y(j))+REGION;
                        y1 = round(x(j))-REGION;
                        y2 = round(x(j))+REGION;
                        q = A(x1:x2,y1:y2,k);
                        ic = ic + 1;
                        M(ic,1) = x(j);
                        M(ic,2) = y(j);
                        M(ic,3) = sum(sum(q));
                        M(ic,4) = i;
                        plot([y1 y1 y2 y2 y1],[x1 x2 x2 x1 x1],'r');
                    end
                end
        elseif button(j)==3
                for k=i:i+GO
                    if (round(y(j))-3>0)&&(round(y(j))+3<szA(1))&&(round(x(j))-3>0)&&(round(x(j))+3<szA(2))
                        x1 = round(y(j))-REGION;
                        x2 = round(y(j))+REGION;
                        y1 = round(x(j))-REGION;
                        y2 = round(x(j))+REGION;
                        q = A(x1:x2,y1:y2,k);
                        icbg = icbg + 1;
                        Mbg(icbg,1) = x(j);
                        Mbg(icbg,2) = y(j);
                        Mbg(icbg,3) = sum(sum(q));
                        Mbg(icbg,4) = i;
                        plot([y1 y1 y2 y2 y1],[x1 x2 x2 x1 x1],'k');
                    end
                end
        end
    end
            pause

            % i = i + 1 will update to the next frame. The value can be
            % changed to any number of frame e.g. + 10 if every tenth frame
            % is analysed.

            i = i + 1;
            cla
            S = squeeze(A(:,:,i));
%             Smin = min(min(S));
%             Smax = max(max(S));
%             S = (S-Smin)/(Smax-Smin)*256;
            imagesc(S)
%             akZoom;
            if exist('aMT','var')
                for q=1:max(sza)/2
                    plot([aMT((q-1)*2+1,1) aMT(q*2,1)],[aMT((q-1)*2+1,2) aMT(q*2,2)],'k');
                end
            end
            title(['frame: ' num2str(i)])
end

% Plotting the results as a histogram or separately plotting the Mtotal
% values only to display the photobleaching trace.

Mtotal = [M(:,3);Mbg(:,3)];
MtotalAV = mean(Mbg(:,3));
Mtotal = Mtotal - MtotalAV;
figure
hist(Mtotal,50)

% szM = size(M);
% Mav = zeros(szM(1)/6,1);
% for j=1:szM(1)/6
%     Mav(j) = sum(M((j-1)*6+1:j*6,3))/6;
% end
