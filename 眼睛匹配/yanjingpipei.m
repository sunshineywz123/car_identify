clc;clear
%%
%基本处理
src=imread('ab2.jpg');
% src=rgb2gray(src);
%%
% src=imcrop(src);
% imwrite(src,'7.jpg');
%%
subplot(2,2,1)
imshow(src);
temp=imread('ab1.jpg');
% temp=rgb2gray(temp);
subplot(2,2,2)
imshow(temp);
%%
[src_height,src_width]=size(src);
[temp_height,temp_width]=size(temp);
%%
%匹配结果黑色区域为眼睛
I=pipei(src,temp);
I=I/max(max(I));
subplot(2,2,3)
imshow(I,[]);
%%
% I0=im2bw(I,0.06);
% subplot(1,2,1)
% imshow(I0,[]);
% se=strel('disk',3);
% I1=imopen(I0,se);
% subplot(1,2,2)
% imshow(I1,[]);
%%
% 找到值最小点
min=min(min(I));
[x,y]=find(I==min);
im_box=src(1:src_height,1:src_width);
% im_box(x:x-1+temp_height,y:y-1+temp_width)=255;
subplot(2,2,4)
imshow(im_box);
rectangle('Position',[y,x,temp_width,temp_height],'EdgeColor','b','LineWidth',3);
%%
%问题：
%虽然眼睛区域较黑
%但过多区域被匹配出来了
%匹配程度无参可调

