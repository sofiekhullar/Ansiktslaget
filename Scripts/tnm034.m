function [ id ] = tnm034( im )

%%%%%%%%%%%%%%%%%%%%%%%%%% 
% % im: Image of unknown face, RGB-image in uint8 format in the 
% range [0,255] % % id: The identity number (integer) of the identified person,
% i.e. ?1?, ?2?,...,?16? for the persons belonging to ?db1? 
% and ?0? for all other faces. 
% % Your program code. 
%%%%%%%%%%%%%%%%%%%%%%%%%% 

for i=1:nfiles
   currentfilename = imagefiles(i).name;
   currentimage = imread(strcat(DBdir,currentfilename));
   imageArray{i} = currentimage;
end

% Calc new image array
newnfiles = 0;
newImageArray = {1,nfiles};

for i=1:nfiles
    current = imageArray{i};
    [leftEye, rightEye] = findEyes(currentImage);
    mouth = findMouth(currentImage);
    
    newnfiles = newnfiles + 1;
    
    currentImage = transformFace(currentImage, leftEye, rightEye, mouth);
    newImage = rgb2gray(currentImage);
    
    newImageArray{newnfiles} = newImage;
end 

% Norm Image
clc
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

% Calc eigenfaces
gammaArray = {}; 

M = length(newImageArray);
norm_image_G = mat2gray(norm_image);
norm_image_vector = norm_image_G(:);


input_img_vector = im2double(input_img(:));

% step 2 - Represent image as vector
for i = 1:M
    currentTestImg = newImageArray{i};
    currentTestImg = im2double(currentTestImg);
    gammaArray{i} = currentTestImg(:);
end

N2 = length(gammaArray{1,1});
sumVector = zeros(N2, 1);

% step 3 - Find the average face vector psi
psi = norm_image_vector;

% step 4 - Subtract the mean fae from each face vector 
phi = {};
for i = 1:M
    phi{i} = gammaArray{1,i} - psi;
end

input_img_vector = input_img_vector - norm_image_vector;

% step 5 - Find the Covariance matrix C
A = cell2mat(phi);
C = A'*A;

[eigenVectors, eigenValues] = eig(C);

%[M, I] = max(max(eigenValues));
k = 6;
 
% To sort the eigenvectors with the eigenvalues
[L, ind] = sort(diag(eigenValues),'descend');
sortedEigenVectors = eigenVectors(:, ind);

v = sortedEigenVectors(:,1:k);
u = A * v;

%for input image
%u_input = input_img_vector * v;

% % Finding Weights
w = u' * A;

% for input image
w_input = u' * input_img_vector;

id = findIndex(w, w_input);

end

