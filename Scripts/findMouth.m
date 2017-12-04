function [mouthPosition] = findMouth( img )

% Mask and find face
face_img = findFace(img);
face_masked = bsxfun( @times, img, cast(face_img, class(img)) );
[top, bottom, left, right] = cropImage(face_masked);

face_masked = face_masked(top:bottom,left:right,:);
[y, x, ~] = size(face_masked);
face_cropped = face_masked(y/2 : end,:,:);

% Converting the mouthImg
mouthImgC = im2double(face_cropped) * 255;

% Converting the mouthmap to Y Cb Cr
YCbCr = rgb2ycbcr(mouthImgC);

Cb = YCbCr(:,:,2);
Cr = YCbCr(:,:,3);

% Creating the mouth mask
maskMouth= uint8( 255 * mat2gray(( Cr.^2 - Cr./Cb).*Cr.^2));
mask = maskMouth > 110 + mean(mean(maskMouth));
thresholdMouth = maskMouth;

% set all pixels that don't pass threshold to zero  
thresholdMouth(~mask) = 0;      

% erosion followed by dilation
binaryMouth = im2bw(thresholdMouth);
mouthDone = bwmorph(binaryMouth,'majority'); 

dilate = strel('disk',3);
erode = strel('disk', 2);

mouthDone = imerode(mouthDone, erode);
mouthDone = imdilate(mouthDone, dilate);

% Find the centroid positon for the mouth in 
[Y, X] = ndgrid(1:size(mouthDone, 1), 1:size(mouthDone, 2));
centroid = mean([X(logical(mouthDone)), Y(logical(mouthDone))]);

%makerMouth = insertMarker(img, [(centroid(1) + left) (centroid(2) + top + y/2)]);

mouthPosition = [(centroid(1) + left) (centroid(2) + top + y/2)];

markerFace = insertMarker(img,[mouthPosition(1) mouthPosition(2)]);
imshow(markerFace)

end
