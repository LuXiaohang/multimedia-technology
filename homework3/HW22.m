
function [LL LH HL HH]=HW22(pic_rgb)
%pic = imread(name); %read color img
%pic_rgb=double(pic)/255;

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

%一阶小波变换
[LL LH HL HH]=haar_dwt2D(L);
img=[LL LH;HL HH];
%imshow(img);
return;


function [LL LH HL HH]=haar_dwt2D(img)
[m n]=size(img);
for i=1:m
    [L H]=haar_dwt(img(i,:)); %对每一行做变换
    img(i,:)=[L H];
end
for j=1:n
    [L H]=haar_dwt(img(:,j)); %对每一列做变换
    img(:,j)=[L H];
end
LL=mat2gray(img(1:m/2,1:n/2));
LH=mat2gray(img(1:m/2,n/2+1:n));
HL=mat2gray(img(m/2+1:m,1:n/2));
HH=mat2gray(img(m/2+1:m,n/2+1:n));
%LL=img(1:m/2,1:n/2);
%LH=img(1:m/2,n/2+1:n);
%HL=img(m/2+1:m,1:n/2);
%HH=img(m/2+1:m,n/2+1:n);
return;

    function [L H]=haar_dwt(l)
        n=length(l);
        n=n/2;
        L=zeros(1,n);
        H=zeros(1,n);
        for i=1:n
            L(i)=(l(2*i-1)+l(2*i))/sqrt(2);
            H(i)=(l(2*i-1)-l(2*i))/sqrt(2);
        end
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