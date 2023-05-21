clc
close all 
clear
img = imread("C:\Users\26748\Desktop\lena.png");
img_gray = rgb2gray(img);
figure
imshow(img_gray);
t1 = graythresh(img_gray);
img_bin = imbinarize(img_gray,t1);
figure
imshow(img_bin);

[rows,cols] = size(img_gray);
nums = rows*cols;
figure
[count, x] = imhist(img_gray);
bar(x, count);

Cumulation = cumsum(count);
i = (0:255)';

pp = count ./ nums;
m1 = i.*pp;
m1 = cumsum(m1);

mg = mean(mean(img_gray));

p = Cumulation ./ nums;

var1 = (p.*mg-m1).^2./(p.*(1-p));

[value,index] = max(var1);

graythresh1 = (index-1)/255;