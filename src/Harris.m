function [X,Y]= Harris(image, a)

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
    h=fspecial('gaussian',[5,5],2);
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
            R(i,j)=det(M)-a*(trace(M))^2;
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
%     imshow(image);
%     hold on
%     for i=1:length(Y)
%         plot(X(i),Y(i),'r+');
%     end
    
    

end

