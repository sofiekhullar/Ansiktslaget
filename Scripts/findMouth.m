function [ mouthPosition ] = findMouth( img )

% Viola jones detectors for Face and Eyes
faceDetector = vision.CascadeObjectDetector;
eyeDetector = vision.CascadeObjectDetector('EyePairSmall');

bboxesFace = step(faceDetector, img);
bboxesEye = step(eyeDetector, img);

mouthImg = img((bboxesEye(1,2) + bboxesEye(1,4)): bboxesFace(1,2) + bboxesFace(1,4),bboxesEye(1,1):(bboxesEye(1,1) + bboxesEye(1,3)),:);

% Converting the mouthImg
mouthImgC = im2double(mouthImg) * 255;

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

% Find the centroid positon for the mouth in 
[y, x] = ndgrid(1:size(mouthDone, 1), 1:size(mouthDone, 2));
centroid = mean([x(logical(mouthDone)), y(logical(mouthDone))]);

%makerMouth = insertMarker(mouthImg, [centroid(1) centroid(2)]);
%imshow(makerMouth)
%figure

mouthPosition = [(centroid(1) + bboxesEye(1,1)) (centroid(2) + bboxesEye(1,4)+ bboxesEye(1,2) )];
%markerFace = insertMarker(img,[mouthPosition(1) mouthPosition(2)]);
%imshow(markerFace)

end
