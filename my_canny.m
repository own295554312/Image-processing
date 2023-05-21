clc
close all
clear

img = imread("C:\Users\26748\Desktop\微信图片_20230402130705.jpg");
figure
imshow(img)

%% matlab的canny
img_gray = im2gray(img);
img_canny = edge(img_gray,"canny");
figure
imshow(img_canny)
title("matlab_canny")

img_e = mycanny(img,0.5);
figure
imshow(img_e,[])
title("my_canny")

function img_edge = mycanny(img,a)

[rows,cols,s] = size(img);

if s ~=1
img_gray = double(im2gray(img));
else
img_gray = double(img);
end

img_gray = img_gray/255;

%高斯模糊
sigma = 2;
img_gua = imgaussfilt(img_gray,sigma);

x = [-1,0,1];
y = [-1;0;1];
%x方向一阶导数
D_x = imfilter(img_gua,x,'conv');
%y方向一阶导数
D_y = imfilter(img_gua,y,'conv');

%计算梯度的方向与幅值
sita = zeros(rows,cols);
m =  zeros(rows,cols);
for r = 1:rows
    for c = 1:cols
%        sita(r,c) = atan(D_x(r,c)/D_y(r,c));
         sita(r,c) = atand(D_y(r,c)/D_x(r,c));
         m(r,c) = (D_x(r,c)^2+D_y(r,c)^2)^0.5;
    end
end

flag = zeros(rows,cols);

for r = 1:rows
    for c = 1:cols
        data = sita(r,c);
        five = zeros(5,1);
        dre = [abs(data-0), abs(data-45), abs(data-90), abs(data+45), abs(data+90)];
        [~,min_index] = min(dre);
        five(min_index) = 1;
        sita(r,c) = [0, 45, 90, -45, 90]*five;
    end
end


for r = 2:rows-1
    for c = 2:cols-1
        dim_drc = sita(r,c);
        dim_m = m(r,c);

        switch dim_drc
            case 0
                check = [m(r,c-1),m(r,c),m(r,c+1)];
            case 90
                check = [m(r-1,c),m(r,c),m(r+1,c)];
            case -45
                check = [m(r-1,c+1),m(r,c),m(r+1,c-1)];
            case 45
                check = [m(r-1,c-1),m(r,c),m(r+1,c+1)];
        end

        if dim_m == max(check)
            flag(r,c) = 1;
        end
    end
end

%确定双阈值
low = 0.1*a*graythresh(m);
hight = 2*low;

for r = 1:rows
    for c = 1:cols
        
        if flag(r,c) == 1 && m(r,c)>hight
           flag(r,c) = 1;
        end
        if flag(r,c) == 1 && m(r,c)<low
           flag(r,c) = 0;
        end
        if flag(r,c) == 1 && ((m(r,c)>low)&&(m(r,c)<hight))
           flag(r,c) = 0.5;
        end
    end
end


for r = 2:rows-1
    for c = 2:cols-1
        if flag(r,c) == 0.5
            count_0 = 0;
            count_1 = 0;
            for k = r-1:r+1
                for l = c-1:c+1
                    if flag(k,l) == 0
                        count_0 = count_0 + 1;
                    elseif flag(k,l) == 1
                        count_1 = count_1 + 1;
                    end
                end
            end
            if count_0 > count_1
                flag(r,c) = 0;
            end
            
            if count_0 <= count_1
                flag(r,c) = 1;
            end

        end
    end
end

img_last = img_gua.*flag;

img_edge = img_last;
end









