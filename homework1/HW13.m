clear;

pic_gray = imread('picgray.bmp');
picd=double(pic_gray)/128;
picd(find(picd>=1.5))=255;
picd(find(picd>=1&picd<1.5))=128;
picd(find(picd>=0.5&picd<1))=64;
picd(find(picd<0.5))=0;
imwrite(picd,'picd.bmp')


