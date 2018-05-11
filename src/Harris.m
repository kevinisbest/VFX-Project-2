function [X,Y,RT]= harrisDetection(image, sigma, w, threshold, k)

    grayimage = rgb2gray(image);
    I = GaussianFilter(grayimage,sigma,w);
    [Ix,Iy] = gradient(I);

    Ix2 = Ix.^2;
    Iy2 = Iy.^2;
    Ixy = Ix.*Iy;

    Sx2 = GaussianFilter(Ix2,sigma,w);
    Sy2 = GaussianFilter(Iy2,sigma,w);
    Sxy = GaussianFilter(Ixy,sigma,w);

    R = (Sx2.*Sy2-Sxy.^2)-k*(Sx2+Sy2).^2;

    RT = R>threshold;
    RT = RT & (R>imdilate(R,[1 1 1;1 0 1;1 1 1]));
    
    [Y,X] = find(RT);
%     figure
%     imshow(image);
%     hold on
%     for i=1:length(X)
%         plot(Y(i),X(i),'r+');
%     end

end
function result = GaussianFilter(image,sigma,w)
if(~exist('sigma'))
    sigma = 0.5;
end
if(~exist('w'))
    w = 3;
end

  Gaussian = fspecial('Gaussian',[w w],sigma);
  result = filter2(Gaussian,image);
end
