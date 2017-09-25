clear;
% read color image into system

pic_rgb = imread('pic.jpg'); %read color img
pic_gray=rgb2gray(pic_rgb);  %change to gray
imshow(pic_gray);            %show gray picture
imwrite(pic_gray,'picgray.bmp'); %save the bmp