function I=kuangchu(I,im_box)
%框出车牌区域
%I为rgb原图像
%im_box为二值图像，即要在图像I上框出的区域
[row,col]=find(im_box);
minrow=min(row);
maxrow=max(row);
mincol=min(col);
maxcol=max(col);
I=I(minrow:maxrow,mincol:maxcol,1:3);