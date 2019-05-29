function M=txjz(I,k)
% 梯形校正
%I为rgb原图像
%k为校正系数,为正数
%M为bw图像
[m,n,c]=size(I);
M=zeros(m,n,c);
if k>=0&&k<=1
    for j=1:c
        for i=1:m
            r=k+(1-k)/(m-1)*(i-1);
            x=imresize(I(i,:,j),[1 round(r*n)],'nearest');
            a=size(x,2);b=round(n/2-a/2);
            M(i,b+1:b+a,j)=x(1,:);
        end
    end
else
    k=1/k;
    for j=1:c
        for i=1:m
            r=(m-k)/(m-1)+(k-1)*i/(m-1);
            x=imresize(I(i,:,j),[1 round(r*n)],'nearest');
            a=size(x,2);b=round(n/2-a/2);
            M(i,b+1:b+a,j)=x(1,:);
        end
    end  
end 
M=uint8(M);
th=graythresh(M);
M=im2bw(M,th);