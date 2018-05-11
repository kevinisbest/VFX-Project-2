function [X,Y]= Harris(image, sigma, w, threshold, k)

    % in_image-�ݴ��o��rgb
    % a--0.04~0.06
    % [posr�Aposc]-���y��
    grayimage=rgb2gray(image);
    I=double(grayimage);
    %%%% ��xy��V��� %%%%

    fx=[-1,0,1];%x��V��׼ҪO
    Ix=filter2(fx,I);%x��V�o�i
    fy=[-1;0;1];%y��V��׼ҪO
    Iy=filter2(fy,I);
    %%%%���Ӥ�V��ת�����%%%%%
    Ix2=Ix.^2;
    Iy2=Iy.^2;
    Ixy=Ix.*Iy;
    %%%%�ϥΰ����[�v��ƹ��׭��n��[�v%%%%
    %���ͤ@��7*7�������Asigma��2
    h=fspecial('gaussian',[7,7],2);
    IX2=filter2(h,Ix2);
    IY2=filter2(h,Iy2);
    IXY=filter2(h,Ixy);
    %%%%%�p��C�ӹ�����Harris�T����%%%%%
    [height,width]=size(I);
    R=zeros(height,width);
    %����(i,j)��Harris�T����
    for i=1:height
        for j=1:width
            M=[IX2(i,j) IXY(i,j);IXY(i,j) IY2(i,j)];
            R(i,j)=det(M)-k*(trace(M))^2;
        end
    end
    %%%%%�h���p�֭Ȫ�Harris��%%%%%
    Rmax=max(max(R));
    %�֭�
    t=0.01*Rmax;
    for i=1:height
        for j=1:width
            if R(i,j)<t
                R(i,j)=0;
            end
        end
    end
    %%%%%�i��3*3���D��j�ȧ��%%%%%%%%%
    corner_peaks=imregionalmax(R);
    %imregionalmax��G���Ϥ��A����8��]�q�b�A�]�i���w�^�d����ȡA�T���Ϥ�����26���
    %��ȸm1�A��E�m0
    num=sum(sum(corner_peaks));
    %%%%%%��ܩҴ�����Harris���I%%%%
    [Y,X]=find(corner_peaks==1);
%     figure
%     imshow(grayimage);
%     hold on
%     for i=1:length(Y)
%         plot(X(i),Y(i),'r+');
%     end
    
    
%     grayimage = rgb2gray(image);
%     I = GaussianFilter(grayimage,sigma,w);
%     [Ix,Iy] = gradient(I);
% 
%     Ix2 = Ix.^2;
%     Iy2 = Iy.^2;
%     Ixy = Ix.*Iy;
% 
%     Sx2 = GaussianFilter(Ix2,sigma,w);
%     Sy2 = GaussianFilter(Iy2,sigma,w);
%     Sxy = GaussianFilter(Ixy,sigma,w);
% 
%     R = (Sx2.*Sy2-Sxy.^2)-k*(Sx2+Sy2).^2;
% 
%     RT = R>threshold;
%     RT = RT & (R>imdilate(R,[1 1 1;1 0 1;1 1 1]));
%     
%     [Y,X] = find(RT);
%     figure
%     imshow(image);
%     hold on
%     for i=1:length(X)
%         plot(X(i),Y(i),'r+');
%     end

end
% function result = GaussianFilter(image,sigma,w)
% if(~exist('sigma'))
%     sigma = 0.5;
% end
% if(~exist('w'))
%     w = 3;
% end
% 
%   Gaussian = fspecial('Gaussian',[w w],sigma);
%   result = filter2(Gaussian,image);
% end
