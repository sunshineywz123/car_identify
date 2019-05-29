close all;
clear all;
clc;
%%
src=imread('lena.jpg');
src=rgb2gray(src);
[src_height,src_width]=size(src);
subplot(2,2,1)
imshow(src);
%%
% I=imcrop(src);
% imwrite(I,'1.jpg');
%%
% 获取模板
temp=imread('2.jpg'); 
[temp_height,temp_width]=size(temp);
subplot(2,2,2)
imshow(temp);
%%
%直方图分布
%一维数组
H1=histcount(temp);
for i=1:(src_height-temp_height)
    for j=1:(src_width-temp_width)
        H2=histcount(src(i:i-1+temp_height,j:j-1+temp_width));
         d(i,j)=abs(sum(sum(double(H1)-mean(double(H1)).*(double(H2)-mean(double(H2)))))/sqrt(sum(sum((double(H1)-mean(double(H1)))).^2)*sum(sum((double(H2)-mean(double(H2))).^2))));
    end
end
subplot(2,2,3)
imshow(d,[]);
%%
t=max(max(d));
[x1,y1]=find(d==t);
subplot(2,2,4)
imshow(src);
rectangle('Position',[y1,x1,temp_width,temp_height],'EdgeColor','b','LineWidth',3);

