pic_gray = imread('picgray.bmp');
picd=double(pic_gray)/255;
picdA=picd(1:240,1:320);
picdB=picd(1:240,321:640);
picdC=picd(241:480,1:320);
picdD=picd(241:480,321:640);
picdA = uint8(round(picdA*255));
picdB = uint8(round(picdB*255));
picdC = uint8(round(picdC*255));
picdD = uint8(round(picdD*255));
subplot(2, 2, 1); imshow(picdA);
subplot(2, 2, 2); imshow(picdB);
subplot(2, 2, 3); imshow(picdC);
subplot(2, 2, 4); imshow(picdD);
simAB=corr2(picdA,picdB);
simAC=corr2(picdA,picdC);
simAD=corr2(picdA,picdD);
simBC=corr2(picdB,picdC);
simBD=corr2(picdB,picdD);
simCD=corr2(picdC,picdD);


a=mean(picdD(:));%平均数
b=median(picdD(:));%中数
picdD2=picdD(:);
picdD2=picdD2';
c=mode(picdD2);%众数
d=max(max(picdD))-min(min(picdD));%全距
f=std2(picdD);%标准差
e=f^2;%方差