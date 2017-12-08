function [ id ] = tnm034( img, k, threshold)
load('variables.mat');
% Read in data from DB1 and save in imageArray
% DBdir = '../Images/DB1/';
% imagefiles = dir(strcat(DBdir,'*.jpg')); 
% nfiles = length(imagefiles);
% imageArray = {1,nfiles}; 
% 
% for i=1:nfiles
%    currentfilename = imagefiles(i).name;
%    currentimage = imread(strcat(DBdir,currentfilename));
%    imageArray{i} = currentimage;
% end

% Calc new image array
% newnfiles = 0;
% newImageArray = {1,nfiles};
% 
% for i=1:nfiles
%     currentImage = imageArray{i};
%     [leftEye, rightEye] = findEyes(currentImage);
%     mouth = findMouth(currentImage);
%     
%     if (isnan(leftEye(1,1)) || isnan(leftEye(1,2)) || isnan(rightEye(1,1)) || isnan(rightEye(1,2)) || isnan(mouth(1,1)) || isnan(mouth(1,2)) )
%         continue;
%     end
%     
%     newnfiles = newnfiles + 1;
%     
%     currentImage = transformFace(currentImage, leftEye, rightEye, mouth);
%     newImage = rgb2gray(currentImage);
%     
%     newImageArray{newnfiles} = newImage;
% end 

% Norm Image
% clc
% size = length(newImageArray{1});
% norm_image = zeros(size, size);
% 
% for i = 1:length(newImageArray)
%     norm_image = norm_image + mat2gray(newImageArray{i});
% end


% Norm input image
[leftEye_input, rightEye_input] = findEyes(img);
mouth_input = findMouth(img);

if (isnan(leftEye_input(1,1)) || isnan(leftEye_input(1,2)) || isnan(rightEye_input(1,1)) || isnan(rightEye_input(1,2)) || isnan(mouth_input(1,1)) || isnan(mouth_input(1,2)) )
        id = 0;
        return;
end
input_img = transformFace(img, leftEye_input, rightEye_input, mouth_input);
input_img = rgb2gray(input_img);

% Calc eigenfaces
% gammaArray = {}; 
% 
% M = length(newImageArray);
% norm_image_G = mat2gray(norm_image);
% norm_image_vector = norm_image_G(:);

input_img_vector = im2double(input_img(:));

% step 2 - Represent image as vector
% for i = 1:M
%     currentTestImg = newImageArray{i};
%     currentTestImg = im2double(currentTestImg);
%     gammaArray{i} = currentTestImg(:);
% end

% N2 = length(gammaArray{1,1});
% sumVector = zeros(N2, 1);

% step 3 - Find the average face vector psi
% psi = norm_image_vector;

% step 4 - Subtract the mean fae from each face vector 
% phi = {};
% for i = 1:M
%     phi{i} = gammaArray{1,i} - psi;
% end

if (size(input_img_vector,1)) ~= (size(norm_image_vector,1))
    id = 0;
    imshow(input_img);
    pause;
    disp('hej');
    return;
end
size(input_img_vector)
size(norm_image_vector)
input_img_vector = input_img_vector - norm_image_vector;

% imshow(mat2gray(reshape(input_img_vector, [261 261])));

% step 5 - Find the Covariance matrix C
% A = cell2mat(phi);
% C = A'*A;
% 
% [eigenVectors, eigenValues] = eig(C);

%[M, I] = max(max(eigenValues));
% k = 14;

% % To sort the eigenvectors with the eigenvalues
% [L, ind] = sort(diag(eigenValues),'descend');
% sortedEigenVectors = eigenVectors(:, ind);

v = sortedEigenVectors(:,1:k);
u = A * v;

%for input image
%u_input = input_img_vector * v;

% % Finding Weights
w = u' * A;

% for input image
w_input = u' * input_img_vector;

id = findIndex(w, w_input, threshold);

% variables = matfile('variables.mat', 'Writable', true);
% variables.u = u;
% variables.w = w;
% variables.A = A;
% variables.norm_image_vector = norm_image_vector;
% variables.sortedEigenVectors = sortedEigenVectors;

end

