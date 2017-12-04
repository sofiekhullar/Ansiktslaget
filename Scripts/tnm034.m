function [ id ] = tnm034( img )

% Read in data from DB1 and save in imageArray
DBdir = '../Images/DB1/';
imagefiles = dir(strcat(DBdir,'*.jpg')); 
nfiles = length(imagefiles);
imageArray = {1,nfiles}; 

for i=1:nfiles
   currentfilename = imagefiles(i).name;
   currentimage = imread(strcat(DBdir,currentfilename));
   imageArray{i} = currentimage;
end

% Calc new image array
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

% Norm Image
size = length(newImageArray{1});
norm_image = zeros(size, size);

for i = 1:length(newImageArray)
    norm_image = norm_image + mat2gray(newImageArray{i});
end

% Norm input image
[leftEye_input, rightEye_input] = findEyes(img);
mouth_input = findMouth(img);
input_img = transformFace(img, leftEye_input, rightEye_input, mouth_input);
input_img = rgb2gray(input_img);

% Calculate eigenfaces
% step 1 - Convert image to vector
M = length(newImageArray);
norm_image_G = mat2gray(norm_image);
norm_image_vector = norm_image_G(:);

% change input image
input_img_vector = im2double(input_img(:));

% step 2 - Represent image as vector
gammaArray = cell(1, M);
for i = 1:M
    currentTestImg = newImageArray{i};
    currentTestImg = im2double(currentTestImg);
    gammaArray{i} = currentTestImg(:);
end

% step 3 - Find the average face vector psi
psi = norm_image_vector;

% step 4 - Subtract the mean fae from each face vector 
phi = cell(1,M);
for i = 1:M
    phi{i} = gammaArray{1,i} - psi;
end

input_img_vector = input_img_vector - norm_image_vector;

% step 5 - Find the Covariance matrix C
A = cell2mat(phi);
C = A'*A;

[eigenVectors, eigenValues] = eig(C);

k = 6;

% To sort the eigenvectors with the eigenvalues
[L, ind] = sort(diag(eigenValues),'descend');
sortedEigenVectors = eigenVectors(:, ind);

v = sortedEigenVectors(:,1:k);
u = A * v;

% % Finding Weights
w = u' * A;

% weights for input image
w_input = u' * input_img_vector;

id = findIndex(w, w_input);

end

