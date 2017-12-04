DBdir = '../Images/DB1/';
imagefiles = dir(strcat(DBdir,'*.jpg')); 
nfiles = length(imagefiles);
imageArray = {1,nfiles}; 

for i = 1:nfiles
   currentfilename = imagefiles(i).name;
   currentimage = imread(strcat(DBdir,currentfilename));
   imageArray{i} = currentimage;
end

%%

for i = 1:16
img = imageArray{i};
face_findface = findFace(img);
face_masked = bsxfun( @times, img, cast(face_findface, class(img)) );

[top, bottom, left, right] = cropImage(face_masked);

face_masked = face_masked(top:bottom,left:right,:);

[y, x, ~] = size(face_masked);
face_masked = face_masked(y/2 : end,:,:);

%half_face = face_masked((img_size(1)/1.7): end,:,:);

% Converting the mouthImg
mouthImgC = im2double(face_masked) * 255;

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

dilate = strel('disk',5);
erode = strel('disk', 2);

mouthDone = imerode(mouthDone, erode);
mouthDone = imdilate(mouthDone, dilate);

% Find the centroid positon for the mouth in 
[Y, X] = ndgrid(1:size(mouthDone, 1), 1:size(mouthDone, 2));
centroid = mean([X(logical(mouthDone)), Y(logical(mouthDone))]);

makerMouth = insertMarker(img, [(centroid(1) + left) (centroid(2) + top + y/2)]);

imshow(face_masked)
pause;
imshow(mouthDone)
pause;
imshow(makerMouth)
pause;

%     imshow(test);
%     pause;
%     imshow(masked);
%     pause;
%     pause;
%     newEye(masked);
%     [e1, e2] = findEyes(masked);
%     m = findMouth(masked);
%     eyes = insertMarker(test,[e1(1) e1(2); e2(1) e2(2)]);
%     imshow(eyes);
%     pause;
    
end

%%
img = imageArray{1};
face_findface = findFace(img);
face_masked = bsxfun( @times, img, cast(face_findface, class(img)) );

img_size = size(face_masked);
half_face = face_masked((img_size(1)/2): end,:,:);

% Viola jones detectors for Face and Eyes
faceDetector = vision.CascadeObjectDetector;
eyeDetector = vision.CascadeObjectDetector('EyePairSmall');

bboxesFace = step(faceDetector, img);
bboxesEye = step(eyeDetector, img);

mouthImg = img((bboxesEye(1,2) + bboxesEye(1,4)): bboxesFace(1,2) + bboxesFace(1,4),bboxesEye(1,1):(bboxesEye(1,1) + bboxesEye(1,3)),:);

% Converting the mouthImg
mouthImgC = im2double(half_face) * 255;

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

makerMouth = insertMarker(mouthImg, [centroid(1) centroid(2)]);
imshow(makerMouth)

mouthPosition = [(centroid(1) + bboxesEye(1,1)) (centroid(2) + bboxesEye(1,4)+ bboxesEye(1,2) )];
