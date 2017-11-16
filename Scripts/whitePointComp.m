function [ outImage ] = whitePointComp( image )

ycbcrmap = rgb2ycbcr(image);
ycbcrmap = im2double(ycbcrmap);

Y = ycbcrmap(:,:,1);

H=size(image,1);
W=size(image,2);

R=image(:,:,1);
G=image(:,:,2);
B=image(:,:,3);

%normalize Y and X
minY=min(min(Y));
maxY=max(max(Y));
Y=255.0*(Y-minY)./(maxY-minY);

Yavg=sum(sum(Y))/(W*H);

T=1;
if (Yavg<64)
    T=1.4;
elseif (Yavg>192)
    T=0.6;
end

if (T~=1)
    RI=R.^T;
    GI=G.^T;
else
    RI=R;
    GI=G;
end

outImage =zeros(H,W,3);
outImage(:,:,1)=RI;
outImage(:,:,2)=GI;
outImage(:,:,3)=B;

end

