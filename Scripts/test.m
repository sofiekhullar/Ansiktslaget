%% Read in data from DB1 and save in imageArray
clear clc
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

clearvars -except newImageArray newnfiles

%% Norm Image
size = length(newImageArray{1});
norm_image = zeros(size, size);

for i = 1:length(newImageArray)
    norm_image = norm_image + mat2gray(newImageArray{i});
end

norm_image = uint8(mat2gray(norm_image) * 255);

%figure;
%imshow(norm_image)

clearvars -except newImageArray newnfiles norm_image size

%%
M = length(newImageArray);
norm_image_vector = norm_image(:);

gammaArray = {M};

% step 2 - Represent image as vector
for i = 1:M
    gammaArray{i} = newImageArray{i}(:);
end

% step 3 - Find the average face vector psi
psi = norm_image_vector;

% step 4 - Subtract the mean fae from each face vector 
phi = {M};

for i = 1:M
    phi{i} = double(gammaArray{1,i}) - double(psi);
end

%% step 5 - Find the Covariance matrix C
A = cell2mat(phi);
AT = A'; 
C = AT*A;

%%
vi = C(:,1);
ui = A*vi;
uiR = reshape(ui, [261,261]);

figure;
imshow(uiR)
%% Call function tnm034 

id = tnm034(imageArray{1})
