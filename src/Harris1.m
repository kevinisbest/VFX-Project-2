function [posr,posc]=Harris1(in_image,a)
% 功能：???像harris角?
% in_image-待??的rgb?像??
% a--角?????，取值范?：0.04~0.06
% [posr，posc]-角?坐?
in_image=rgb2gray(in_image);
I=double(in_image);
%%%%?算xy方向梯度%%%%%

fx=[-1,0,1];%x方向梯度模板
Ix=filter2(fx,I);%x方向?波
fy=[-1;0;1];%y方向梯度模板(注意是分?)
Iy=filter2(fy,I);
%%%%?算??方向梯度的乘?%%%%%
Ix2=Ix.^2;
Iy2=Iy.^2;
Ixy=Ix.*Iy;
%%%%使用高斯加?函??梯度乘??行加?%%%%
%?生一?7*7的高斯窗函?，sigma值?2
h=fspecial('gaussian',[7,7],2);
IX2=filter2(h,Ix2);
IY2=filter2(h,Iy2);
IXY=filter2(h,Ixy);
%%%%%?算每?像元的Harris??值%%%%%
[height,width]=size(I);
R=zeros(height,width);
%像素(i,j)?的Harris??值
for i=1:height
    for j=1:width
        M=[IX2(i,j) IXY(i,j);IXY(i,j) IY2(i,j)];
        R(i,j)=det(M)-a*(trace(M))^2;
    end
end
%%%%%去掉小?值的Harris值%%%%%
Rmax=max(max(R));
%?值
t=0.01*Rmax;
for i=1:height
    for j=1:width
        if R(i,j)<t
            R(i,j)=0;
        end
    end
end
%%%%%?行3*3?域非极大值抑制%%%%%%%%%
corner_peaks=imregionalmax(R);
%imregionalmax?二??片，采用8?域（默?，也可指定）查找极值，三??片采用26?域
%极值置?1，其余置?0
num=sum(sum(corner_peaks));
%%%%%%?示所提取的Harris角?%%%%
[posr,posc]=find(corner_peaks==1);
figure
imshow(in_image);
hold on
for i=1:length(posr)
    plot(posc(i),posr(i),'r+');
end
end