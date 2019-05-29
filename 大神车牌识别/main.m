clear;close;clc
car=imread('car.jpg');
r=car(:,:,1); %RGB三色通道
g=car(:,:,2);
b=car(:,:,3);
% imshow(car);
%% RGB范围可以自行修改，这是手动测试找到的可行范围
r1=r<25;
g1=g>20&g<65;
b1=b>90&b<140;
img_merge=r1.*g1.*b1; %找到蓝色区域的二值图
n=9;
mask=ones(n,n)/(n.^2);
img_conv=conv2(img_merge,mask,'valid'); %二维卷积计算，找到蓝色集中区域
max_i=max(max(img_conv)); %蓝色过滤器的中心点
% subplot(1,2,1)
% % imshow(img_merge);
% imshow(img_conv);
%% 确定车牌位置及大小
length=15;
width=15;
[x_pos,y_pos]=find(img_conv==max_i); %找到卷积后的中心位置作为box起点
x_pos=x_pos(1,1);
y_pos=y_pos(1,1);
% rectangle('Position',[y_pos,x_pos,1,1],'EdgeColor','b','LineWidth',3);
% plate=car(x_pos:x_pos+length,y_pos:y_pos+width,:); 
% imshow(plate);
%%
for i=1:2
up_mean=1;
down_mean=1;
right_mean=1;
left_mean=1;
thres=0; %设置阈值限制扩张
    
while up_mean>thres %往上扩张
    up_mean=mean(img_conv(x_pos:x_pos+length,y_pos));
    y_pos=y_pos-1;
end
while left_mean>thres %往左扩张
    left_mean=mean(img_conv(x_pos,y_pos:y_pos+width));
    x_pos=x_pos-1;

end
thres=0.1; %设置阈值限制扩张
while right_mean>thres %往右扩张
    right_mean=mean(img_conv(x_pos+length,y_pos:y_pos+width));
    length=length+1;
end
while down_mean>thres %往下扩张
    down_mean=mean(img_conv(x_pos:x_pos+length,y_pos+width));
    width=width+1;
end
end
plate=car(x_pos+1:x_pos+length,y_pos+1:y_pos+width,:); %初次确定车牌位置
% rectangle('Position',[y_pos,x_pos,width,length],'EdgeColor','b','LineWidth',3);
% subplot(1,2,2)
% imshow(plate);
% imshow(img_conv);
%% 进一步确定车牌位置
r_p=plate(:,:,1);
g_p=plate(:,:,2);
b_p=plate(:,:,3);

r2=r_p<25; %rpg三色通道范围
g2=g_p>20&g_p<65;
b2=b_p>90&b_p<140;
img_m2=r2.*g2.*b2; %找到蓝色区域的二值图
% subplot(1,2,1)
% imshow(img_m2);
% mask2=[1,1;1,1];
% img_m2=imerode(img_m2,mask2); %腐蚀图像去噪

%% 车牌旋转
best_angle=1000;
for i=-30:30
temp_plate=imrotate(img_m2,i,'loose');
mean_img=mean(temp_plate,2);
t=find(mean_img);
[num_row,~]=size(t);
   if num_row<best_angle
       best_angle=num_row;
       rot_plate=temp_plate;
       rot_img=imrotate(plate,i,'loose');
   end
end
% subplot(1,2,2)
% imshow(rot_plate);
%% 设置阈值进一步确定车牌位置
plate_thresh=1; %自定义车牌范围阈值（目前的问题是当车牌有噪音时需要高阈值，但高阈值会影响车牌字符范围）
x_m2=find(sum(rot_plate)>plate_thresh);
min_x2=min(x_m2);%纵向起点坐标
max_x2=max(x_m2); %纵向终点坐标
y_m2=find(sum(rot_plate,2)>plate_thresh);
min_y2=min(y_m2); %横向起点坐标
max_y2=max(y_m2);%横向终点坐标
plate2=rot_img(min_y2:max_y2,min_x2:max_x2,:);
% subplot(1,2,2)
% imshow(plate2);

%% 车牌灰度化，二值化
i2=im2double(plate2);
i3=rgb2gray(i2);
i3_a=i3(i3>0); %去掉0，因为旋转角度过多会有很多0，影响二值化阈值
sh=graythresh(i3_a);
i4=im2bw(i3,sh);
% subplot(1,2,2)
% imshow(i4);

%% 车牌字符分割
[~,m]=size(i4);
length_i=ones(1,1); %初次分割
pos_k=zeros(2,7); %找到7个字符位置
k=1;
length=fix(m/21); %一次分割的长度
i=1;
  while k<7
     length=fix(m/21);
    while length_i(i)+length<m&& mean(mean(i4(:,length_i(i)+length)))>0.08 %当横坐标所在纵列小于阈值时分割
        length=length+1;
    end
    if mean(mean(i4(:,length_i(i):length_i(i)+length)))>0.1 %判断分割的图是否为字符
        pos_k(1,k)=length_i(i);
        pos_k(2,k)=length_i(i)+length;
        k=k+1;
    end
    length_i(i+1)=length_i(i)+length;
    i=i+1;
 end
 pos_k(1,7)=pos_k(2,6); %最后个字符范围确定
 pos_k(2,7)=m;
 %% 输出分割字符
 figure
 subplot(4,10,[1:5,11:15,21:25]);
 imshow(car)
 title('原图')
 
 subplot(4,10,6:10);
 imshow(plate)
 title('彩色车牌')
 
 subplot(4,10,16:20);
 imshow(rot_img)
 title('旋转后车牌')
 
  subplot(4,10,26:30);
 imshow(plate2)
 title('二次定位')
 
    for i=1:7
        subplot(4,10,30+i);
        imshow(i4(:,pos_k(1,i):pos_k(2,i)))
    end
    title('字符分割');