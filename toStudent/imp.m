% read image into system

pic = imread('c-lighthouse.jpg'); % read image
picg = rgb2gray(pic);
picd = double(picg)/255; % translate uint8 into double image format

% end of reading image
% image processing

mid = 50/255 <= picd & picd <= 200/255; % creat a matrix; 1 for satisfying condition; 0 for unsatisfying.
picd = mid .* picd;

% end of image processing
% write martix into image 

picuint8 = uint8(round(picd*255)); % translate double into uint8 image format
imwrite(picuint8,'pictest.jpg','jpg');
figure;imshow(picuint8);
figure;imshow(picg);

% end of writing image