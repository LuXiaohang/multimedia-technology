clear;
% read color image into system

pic_gray = imread('picgray.bmp'); 
picd=double(pic_gray)/255;
[row,col]=size(picd);
picd1=reshape(picd,1,row*col);
hist(picd1*255,256);
%graphics=zeros(1,256);
%for i=0:255
%    graphics(1,i+1)=length(find(picd*255==i));
%end
%bar(0:255,graphics,'grouped');
%xlabel('�Ҷ�ֵ');
%ylabel('���ִ���');
%axis([0 255]);
picd=double(pic_gray);
a=mean(picd(:));%ƽ����
b=median(picd(:));%����
picd2=picd(:);
picd2=picd2';
c=mode(picd2);%����
d=max(max(picd))-min(min(picd));%ȫ��
f=std2(picd);%��׼��
e=f^2;%����