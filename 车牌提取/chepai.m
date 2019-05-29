clc;clear;close all
%%
%基本处理
n=2;
I=imread('1.jpg');
% figure
% subplot(n,n,1)
% imshow(I);
%%
% %裁剪
[row,col,n]=size(I);
I=I(1:round(1/2*row),1:col,1:3);
r=I(:,:,1);
% subplot(n,n,2)
% imshow(I);
%限制
%需要车牌照是的角度，位置差不多
%小区识别是这种情况
%%
%框出车牌区域
%车牌区域
r=I(:,:,1);
g=I(:,:,2);
b=I(:,:,3);
%%
%根据颜色索引该小车区域
r1=r>0&r<40;
g1=g>20&g<65;
b1=b>90&b<170;
im_con=r1.*g1.*b1;
se=strel('disk',3);
im_con=imdilate(im_con,se);
% subplot(n,n,1)
% imshow(im_con);
%%
im=bwconncomp(im_con);
s=im.PixelIdxList{1};
%%
% %框出车牌区域
r=I(:,:,1);
im_box1=zeros(size(r));
im_box1(s)=1;
% subplot(n,n,2)
% imshow(im_box1)
%%
I_kc=kuangchu(I,im_box1);
% figure
% imshow(I_kc);
% imshow(I_bw);
%限制
%因为是以颜色查找，只能是蓝色查找
%还要求车身颜色没有太大干扰
%牌照的光线，曝光等要合适
%车牌污染不是很严重
%其他方法
%边沿检测
%字符查找
%%
th=graythresh(I_kc);
I_bw=im2bw(I_kc,th);
%%
%角度校正
%自适应旋转
theta=auto_xzhuan(I_bw);
I_angle=imrotate(I_kc,theta,'loose');
% subplot(1,2,1)
% imshow(I_angle);
%%
%自适应校正
I_jz=auto_jz(I_angle);
% subplot(1,2,2)
imshow(I_jz);
%%
% 梯形校正
% k=0.87;
% I_jz=txjz(I_angle,k);
% subplot(1,2,2)
% imshow(I_jz);
%限制
%牌照角度要差不多
%不能自适应调节，需要人工测算
%%
%框出车牌区域
%车牌区域
r=I_jz(:,:,1);
g=I_jz(:,:,2);
b=I_jz(:,:,3);
%%
%根据颜色索引该小车区域
r1=r>0&r<40;
g1=g>20&g<65;
b1=b>90&b<200;
im_con=r1.*g1.*b1;
se=strel('disk',2);
im_con=imclose(im_con,se);
% subplot(n,n,2)
% imshow(im_con);
%%
im=bwconncomp(im_con);
s=im.PixelIdxList{1};
%%
%框出车牌区域
im_box2=zeros(size(r));
im_box2(s)=1;
% subplot(n,n,3)
% imshow(im_box2);
%%
%框出车牌区域
I_jz=kuangchu(I_jz,im_box2);
% subplot(n,n,3)
% imshow(I);
% %%
sh=graythresh(I_jz);
I0=im2bw(I_jz,sh);
I0=bwmorph(I0,'thin',1);
% figure
% imshow(I0);
%%
%我的字符分割
myfengge(I0);
%%
% 限制
% 是用均分法分割的，要求前面梯形校正参数合适，得到的车牌方正
% 其他方法
% 根据字符间联系最弱点区分字符
% %
% 后续
% 字符匹配
% OCR
% 神经网络
% 模板匹配


