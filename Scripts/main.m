%%%%%%%%%%%%%%%%%%%%%%%%%% function id = tnm034(im) 
% % im: Image of unknown face, RGB-image in uint8 format in the 
% range [0,255] % % id: The identity number (integer) of the identified person,
% i.e. ?1?, ?2?,...,?16? for the persons belonging to ?db1? % and ?0? for all other faces. 
% % Your program code. %%%%%%%%%%%%%%%%%%%%%%%%%% 

%% Read in data

DBdir = '../Images/DB1/';
imagefiles = dir(strcat(DBdir,'*.jpg')); 
nfiles = length(imagefiles);
imageArray = {1,nfiles}; 

for i=1:nfiles
    %test = '../Images/DB1/db1_' + i +'.jpg';
   currentfilename = imagefiles(i).name;
   currentimage = imread(strcat(DBdir,currentfilename));
   imageArray{i} = currentimage;
end

faceDetector = vision.CascadeObjectDetector;
eyeDetector = vision.CascadeObjectDetector('EyePairSmall');
noseDetector = vision.CascadeObjectDetector('Nose');
mouthDetector = vision.CascadeObjectDetector('Mouth');

%% 
img = 5;
bboxesFace = step(faceDetector, imageArray{img});
bboxesEye = step(eyeDetector, imageArray{img});
bboxesNose = step(noseDetector, imageArray{img});
bboxesMouth = step(mouthDetector, imageArray{img});

position = zeros(4, 4);
position(1, 1:4) = bboxesFace(1,:);
position(2, 1:4) = bboxesEye(1,:);
position(3, 1:4) = bboxesNose(1,:);
position(4, 1:4) = bboxesMouth(1,:);

label = {'Face' 'Eyes' 'Nose' 'Mouth'};

IFaces = insertObjectAnnotation(imageArray{img}, 'rectangle', position, label, 'Color',{'cyan','yellow', 'magenta', 'blue'});
figure, imshow(IFaces), title('Detected faces');

%%

tmp = imageArray{img};
test = tmp(bboxesEye(1,2):(bboxesEye(1,2) + bboxesEye(1,4)), bboxesEye(1,1):(bboxesEye(1,1) + bboxesEye(1,3)),:);
bw = im2bw(test);
imshow(bw);

%% Test norm images

size = length(newImageArray{1})
sum_image = zeros(size, size);

for i = 1:length(newImageArray)
    
    sum_image = sum_image + mat2gray(newImageArray{i});
end

figure;
imshow(mat2gray(sum_image))
