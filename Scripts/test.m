%% Read in data from DB1 and save in imageArray
DBdir = '../Images/DB1/';
imagefiles = dir(strcat(DBdir,'*.jpg')); 
nfiles = length(imagefiles);
imageArray = {1,nfiles}; 

for i=1:nfiles
   currentfilename = imagefiles(i).name;
   currentimage = imread(strcat(DBdir,currentfilename));
   imageArray{i} = currentimage;
end

%% Calc new image array
newnfiles = 0;
newImageArray = {1,nfiles};

for i=1:nfiles
    currentImage = imageArray{i};
    [leftEye, rightEye] = findEyes(currentImage);
    mouth = findMouth(currentImage);
    
    if (isnan(leftEye(1,1)) || isnan(leftEye(1,2)) || isnan(rightEye(1,1)) || isnan(rightEye(1,2)) || isnan(mouth(1,1)) || isnan(mouth(1,2)) || (i == 12))
        continue;
    end
    
    newnfiles = newnfiles + 1;
    
    currentImage = transformFace(currentImage, leftEye, rightEye, mouth);
    newImage = rgb2gray(currentImage);
    
    newImageArray{newnfiles} = newImage;
end 

clearvars -except newImageArray newnfiles imageArray nfiles

%% Norm Image
clc
size = length(newImageArray{1});
norm_image = zeros(size, size);

for i = 1:length(newImageArray)
    norm_image = norm_image + mat2gray(newImageArray{i});
end

figure;
imshow(mat2gray(norm_image))

%%
gammaArray = {}; 
psiArray = {};

M = length(newImageArray);
norm_image_vector = norm_image(:);

% step 2 - Represent image as vector
for i = 1:M
    currentTestImg = newImageArray{i};
    currentTestImg = im2double(currentTestImg);
    gammaArray{i} = currentTestImg(:);
end

M2 = length(gammaArray{1,1});
sumVector = zeros(M2, 1);

% step 3 - Find the average face vector psi
for i = 1:M
    tmpVector = gammaArray{1,i};
    for j = 1:M2
        sumVector(j,1) = (sumVector(j,1) + tmpVector(j,1));
    end
end
psi = 1/M .* sumVector;

% step 4 - Subtract the mean face from each face vector 
for i = 1:M
    phi{i} = gammaArray{1,i} - norm_image_vector;
end

%% step 5 - Find the Covariance matrix C
% A = [phi1, phi2, ....]
% C = A A^T
% A is of size n x M
% C is a N^2 times N^2 

A = cell2mat(phi);
AT = A.'; 
C = AT*A;

%C = cov(A, AT);

%% Call function tnm034 

id = tnm034(imageArray{1})
