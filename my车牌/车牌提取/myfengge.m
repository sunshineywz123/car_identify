function myfengge(I0)
%I0为bw图像
%我的字符分割
%可以实现分割字符的效果
%显示为二值图像分割字符
[~,col]=size(I0);
n=10;
t=fix(col/n);
a(1)=1;
for i=1:7
    len=t;
    while mean(I0(:,a(i)+len))>0.06  %阈值往小处选
        len=len+1;
    end
    a(i+1)=a(i)+len;
end
figure
for i=1:7
    subplot(3,3,i)
    imshow(I0(:,a(i):a(i+1)));
end