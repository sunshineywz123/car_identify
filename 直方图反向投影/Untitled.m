clear;clc;close;
n=4;
a=imread('Test.jpg');
a1=a(1:450,:,:);
%%
temp_a=a1;
subplot(2,2,1)
imshow(a1)
subplot(2,2,1)
imshow(temp_a)
%% 找到颜色范围
r=a1(:,:,1);
g=a1(:,:,2);
b=a1(:,:,3);
r1=r>180 & r<255;
g1=g>50 & g<130;
b1=b>55 & b<140;
img_merge=r1.*g1.*b1; %三色区域融合的二值图
subplot(2,2,2)
imshow(img_merge)

%% 通过联通点来找物体位置
CC = bwconncomp(img_merge);
object_con=CC.PixelIdxList{1}
%% 确定物体所在位置
im_box=zeros(size(r));
im_box(object_con)=1;
[rows,cols]=find(im_box);
min_row=min(rows);
max_row=max(rows);
min_col=min(cols);
max_col=max(cols);
im_box(min_row:max_row,min_col:max_col)=1;
subplot(2,2,3)
imshow(im_box);
%%
subplot(2,2,4)
% new_img=a1(min_row:max_row,min_col:max_col,:);
% imshow(new_img) 
imshow(a1);
rectangle('Position',[min_col,min_row,max_col-min_col,max_row-min_row],'EdgeColor','b','LineWidth',3);
