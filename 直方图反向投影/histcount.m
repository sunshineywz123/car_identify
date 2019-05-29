function hist=histcount(w)
    [H W]=size(w);
    w=uint8(w);
    hist=zeros(1,256);
    for i=1:H
        for j=1:W
            hist(w(i,j)+1)=hist(w(i,j)+1)+1; %统计直方图
        end
    end
hist=hist/(H*W);
end