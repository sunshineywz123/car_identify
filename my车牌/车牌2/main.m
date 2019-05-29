clear;close all;clc;
I = imread('2.jpg');
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);
Gray = 0.299*R+0.587*G+0.114*B;
% imshow(Gray)
%%
R1 = R(195:215,118:176);
G1 = G(195:215,118:176);
B1 = B(195:215,118:176);
R2 = R<55;
G2 = G>50&G<100;
B2 = B>120&B<200;
Blue_bw = R2.*G2.*B2;
% imshow(Blue_bw)
% imhist(B1)
se = strel('disk',3);
Blue_bw_d = imdilate(Blue_bw,se);
Blue_bw_d_o = bwareaopen(Blue_bw_d,100);
Blue_bw_d_o_e = imerode(Blue_bw_d_o,se);
A = mean(Blue_bw_d_o_e);
B = mean(Blue_bw_d_o_e,2);

x_min = min(find(B~=0));
x_max = max(find(B~=0));
y_min = min(find(A~=0));
y_max = max(find(A~=0));

Che_Pai = I(x_min:x_max,y_min:y_max,:);
Che_Pai_Gray = rgb2gray(Che_Pai);
Che_Pai_bw = im2bw(Che_Pai_Gray);
% imshow(Che_Pai_bw)
C = mean(Che_Pai_bw,2);
[m,n] = size(Che_Pai_bw);
for i=1:m/2
    if C(i)==0 & C(i-1)~=0
        Che_Pai_bw(1:i,:) = 0;
    end
end
for i=m/2:m
    if C(i)~=0 & C(i-1)==0
        Che_Pai_bw(i:m,:) = 0;
    end
end
% imshow(Che_Pai_bw);
Che_Pai_bw_rs = imresize(Che_Pai_bw,5);
[m,n] = size(Che_Pai_bw_rs);
D = mean(Che_Pai_bw_rs);
for i=1:n
    if D(i)<0.1
        Che_Pai_bw_rs(:,i) = 0;
    end
end
D = mean(Che_Pai_bw_rs);
F = zeros(1,n+1);
H = zeros(1,n+1);
for i=2:n
    if D(i)~=0 && D(i-1)==0
        F(1,i) = i;
    end
    if D(i)==0 && D(i-1)~=0
        H(1,i) = i;
    end
end
Y_min = find(F);
Y_max = find(H);

for i=1:length(Y_min)
    L=Che_Pai_bw_rs(:,Y_min(i):Y_max(i));
    L=bwmorph(L,'thin',inf);
    subplot(3,3,i);imshow(L);
end