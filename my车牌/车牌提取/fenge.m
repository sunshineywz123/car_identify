function fenge(M)
%M为彩色rgb车牌
%分割车牌号并腐蚀膨胀细化处理
    n=3;
    [row,col,c]=size(M);
    X=row;
    Y=col/7;
    figure
    for i=7:-1:1
        I0=M(1:X,1+round(Y*(i-1)):round(Y*i));
        I0=im2bw(I0,0.28);
        %%
        se=strel('disk',1);
        I0=imerode(I0,se);
        se=strel('disk',1);
        I0=imclose(I0,se);
        I0=bwmorph(I0,'thin',5);
        subplot(n,n,i)
        imshow(I0);
    end
% %%
% figure
% imhist(I0);