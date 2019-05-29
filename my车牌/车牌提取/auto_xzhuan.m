function theta=auto_xzhuan(I_bw)
%I_bw为框出的bw图像
%theta为自动旋转的最佳角度
%该函数可以实现自适应角计算
%th为设定阈值
th=1000;
c=0.05;
theta=10;
for a=-theta:theta
    I_rot=imrotate(I_bw,a,'loose');
    im_m=mean(I_rot,2);
    t=find(im_m>c); %找到行均值的非零元素,阈值0.05，可以稍微大点
    [im_row,~]=size(t);
    if im_row<th    %非零行最少时最端正
        th=im_row;
        theta=a;
    end
end
