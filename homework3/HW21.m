
function haha=HW21(name)
clear;
pic = imread('nontextured1.jpg'); %read color img
pic_rgb=double(pic)/255;

XYZ=rgb2xyz(pic_rgb); %Convert to XYZ

WhitePoint=[95.0456,100,108.8754];
WhitePointU=(4*WhitePoint(1))./(WhitePoint(1)+15*WhitePoint(2)+3*WhitePoint(3));
WhitePointV=(9*WhitePoint(2))./(WhitePoint(1)+15*WhitePoint(2)+3*WhitePoint(3));
U=(4*XYZ(:,:,1))./(XYZ(:,:,1)+15*XYZ(:,:,2)+3*XYZ(:,:,3));
V=(9*XYZ(:,:,2))./(XYZ(:,:,1)+15*XYZ(:,:,2)+3*XYZ(:,:,3));
Y=XYZ(:,:,2)/WhitePoint(2);
L=116*f(Y)-16;
LUV(:,:,1)=L;
LUV(:,:,2)=13*L.*(U-WhitePointU);
LUV(:,:,3)=13*L.*(V-WhitePointV);
[row,col]=size(L);
L1=reshape(L,1,row*col);
%分别用hist和bar函数画直方图
%graphics=zeros(1,100);
%for i=0:99
%    graphics(1,i+1)=length(find(round(L)==i));
%end
%bar(0:99,graphics);
%xlabel('L值');
%ylabel('出现次数');
hist(L1,100);
return;

function XYZ=rgb2xyz(image)
r=image(:,:,1);
g=image(:,:,2);
b=image(:,:,3);
i=(r>=0.04045);
r1=((r+0.055)/1.055).^2.4.*i;
r2=r/12.92.*~i;
r=r1+r2;
i=(g>=0.04045);
g1=((g+0.055)/1.055).^2.4.*i;
g2=g/12.92.*~i;
g=g1+g2;
i=(b>=0.04045);
b1=((b+0.055)/1.055).^2.4.*i;
b2=b/12.92.*~i;
b=b1+b2;
r=r*100;
g=g*100;
b=b*100;
XYZ(:,:,1)=r*0.4124+g*0.3576+b*0.1805;
XYZ(:,:,2)=r*0.2126+g*0.7152+b*0.0722;
XYZ(:,:,3)=r*0.0193+g*0.1192+b*0.9505;
return;

function fY=f(Y)
i=(Y>=0.008856);
y1=Y.^(1/3).*i;
y2=((7.787*Y)+(16/116)).*~i;
fY=y1+y2;
return;