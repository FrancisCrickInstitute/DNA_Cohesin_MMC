
% This program will open a tiff stack and read basic information. It needs
% to be run prior to running the clicl_stack program to load the desired
% image stack.
% http://www.matlabtips.com/how-to-load-tiff-stacks-fast-really-fast/
% stack is saved in A(x,y,frame) type double

if exist('PN','var')
    [fn,pn] = uigetfile('*.tif','Choose your tiff stack',PN);
else
    [fn,pn] = uigetfile('*.tif','Choose your tiff stack');
end
if (length(fn)<2)&&(length(pn)<2)
    error('canceled')
end
global PN
PN = [pn fn];
FileTif=PN;
tic
warning('off','MATLAB:tifflib:TIFFReadDirectory:libraryWarning')
InfoImage=imfinfo(FileTif);
mImage=InfoImage(1).Width;
nImage=InfoImage(1).Height;
NumberImages=length(InfoImage);
FinalImage=zeros(nImage,mImage,NumberImages,'uint16');
TifLink = Tiff(FileTif, 'r');
for i=1:NumberImages
   TifLink.setDirectory(i);
   FinalImage(:,:,i)=TifLink.read();
end
TifLink.close();
toc
A=double(FinalImage);
szA = size(A);

 PN1 = strrep(PN,'.tif','_roi.txt');
 if exist(PN1,'file')
    aMT = load(PN1);
 end
