function [X,Y]= Harris(image, a)

    % in_image-待測得的rgb
    % a--0.04~0.06
    % [posr，posc]-角座標
    grayimage=rgb2gray(image);
    I=double(grayimage);
    %%%% 算xy方向梯度 %%%%
    
    fx=[-1,0,1];%x方向梯度模板
    Ix=filter2(fx,I);%x方向濾波
    fy=[-1;0;1];%y方向梯度模板
    Iy=filter2(fy,I);
    %%%%算兩個方向梯度的乘雞%%%%%
    Ix2=Ix.^2;
    Iy2=Iy.^2;
    Ixy=Ix.*Iy;
    %%%%使用高斯加權函數對梯度乘積行加權%%%%
    %產生一個7*7的高斯，sigma值2
    h=fspecial('gaussian',[5,5],2);
    IX2=filter2(h,Ix2);
    IY2=filter2(h,Iy2);
    IXY=filter2(h,Ixy);
    %%%%%計算每個像素的Harris響應值%%%%%
    [height,width]=size(I);
    R=zeros(height,width);
    %像素(i,j)的Harris響應值
    for i=1:height
        for j=1:width
            M=[IX2(i,j) IXY(i,j);IXY(i,j) IY2(i,j)];
            R(i,j)=det(M)-a*(trace(M))^2;
        end
    end
    %%%%%去掉小閥值的Harris值%%%%%
    Rmax=max(max(R));
    %閥值
    t=0.01*Rmax;
    for i=1:height
        for j=1:width
            if R(i,j)<t
                R(i,j)=0;
            end
        end
    end
    %%%%%進行3*3領域非极大值抑制%%%%%%%%%
    corner_peaks=imregionalmax(R);
    %imregionalmax對二維圖片，采用8域（默刃，也可指定）查找极值，三維圖片采用26領域
    %极值置1，其余置0
    num=sum(sum(corner_peaks));
    %%%%%%顯示所提取的Harris角點%%%%
    [Y,X]=find(corner_peaks==1);
%     figure
%     imshow(image);
%     hold on
%     for i=1:length(Y)
%         plot(X(i),Y(i),'r+');
%     end
    
    

end

