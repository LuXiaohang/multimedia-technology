clear;
% read color image into system

pic = imread('c-light-51x38.jpg'); % read color image
picdouble = double(pic)/255; % translate uint8 into double image format

picdr = picdouble(:,:,1); % Red image domain 
picdg = picdouble(:,:,2); % Green image domain 
picdb = picdouble(:,:,3); % Blue image domain 

% end of reading image
% image processing

t = zeros(size(picdr))*255; % creat a zero matrix with the same size as picdr 
midr = 50/255 <= picdr & picdr <= 200/255; % creat a matrix; 1 for satisfying condition; 0 for unsatisfying.
picdr = midr .* picdr;

midg = 100/255 <= picdg & picdg <= 255/255; % creat a matrix; 1 for satisfying condition; 0 for unsatisfying.
picdg = midg .* picdg;

midb = 0 <= picdb & picdb <= 155/255; % creat a matrix; 1 for satisfying condition; 0 for unsatisfying.
picdb = midb .* picdb;

% end of image processing
% write martix into image 

picdouble(:,:,1) = picdr; % Red image domain 
picdouble(:,:,2) = picdg; % Green image domain 
picdouble(:,:,3) = picdb; % Blue image domain 

picuint8 = uint8(round(picdouble*255)); % translate double into uint8 image format
imwrite(picuint8,'pictest.jpg','jpg');

% end of writing image
% show image 
na = char('Red','Green','Blue');
for i = 1:4
   subplot(2,2,i);
   if(i > 1)
       imt = picuint8;
       imt(:,:,i-1) = t;
       imshow(imt);
       title(['Without ' na(i-1,:)]);
   else
       imshow(picuint8);
       title('True Color Image');
   end   
end
% end of image showing