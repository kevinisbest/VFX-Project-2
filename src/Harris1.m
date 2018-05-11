function [posr,posc]=Harris1(in_image,a)
% �\��G???��harris��?
% in_image-��??��rgb?��??
% a--��?????�A���ȭS?�G0.04~0.06
% [posr�Aposc]-��?��?
in_image=rgb2gray(in_image);
I=double(in_image);
%%%%?��xy��V���%%%%%

fx=[-1,0,1];%x��V��׼ҪO
Ix=filter2(fx,I);%x��V?�i
fy=[-1;0;1];%y��V��׼ҪO(�`�N�O��?)
Iy=filter2(fy,I);
%%%%?��??��V��ת���?%%%%%
Ix2=Ix.^2;
Iy2=Iy.^2;
Ixy=Ix.*Iy;
%%%%�ϥΰ����[?��??��׭�??��[?%%%%
%?�ͤ@?7*7����������?�Asigma��?2
h=fspecial('gaussian',[7,7],2);
IX2=filter2(h,Ix2);
IY2=filter2(h,Iy2);
IXY=filter2(h,Ixy);
%%%%%?��C?������Harris??��%%%%%
[height,width]=size(I);
R=zeros(height,width);
%����(i,j)?��Harris??��
for i=1:height
    for j=1:width
        M=[IX2(i,j) IXY(i,j);IXY(i,j) IY2(i,j)];
        R(i,j)=det(M)-a*(trace(M))^2;
    end
end
%%%%%�h���p?�Ȫ�Harris��%%%%%
Rmax=max(max(R));
%?��
t=0.01*Rmax;
for i=1:height
    for j=1:width
        if R(i,j)<t
            R(i,j)=0;
        end
    end
end
%%%%%?��3*3?��D��j�ȧ��%%%%%%%%%
corner_peaks=imregionalmax(R);
%imregionalmax?�G??���A����8?��]�q?�A�]�i���w�^�d����ȡA�T??������26?��
%��ȸm?1�A��E�m?0
num=sum(sum(corner_peaks));
%%%%%%?�ܩҴ�����Harris��?%%%%
[posr,posc]=find(corner_peaks==1);
figure
imshow(in_image);
hold on
for i=1:length(posr)
    plot(posc(i),posr(i),'r+');
end
end