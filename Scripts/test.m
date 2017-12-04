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

M = length(newImageArray);
norm_image_G = mat2gray(norm_image);
norm_image_vector = norm_image_G(:);

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

% step 5 - Find the Covariance matrix C
A = cell2mat(phi);
AT = A'; 
C = AT*A;

[eigenVectors, eigenValues] = eig(C);

%[M, I] = max(max(eigenValues));
 %eigenfaces.image{a} = eigenfaces.image{a}./norm(eigenfaces.image{a},2);

k = 6;
v = zeros(M,k);
u = zeros(N2, k);
 
% To sort the eigenvectors with the eigenvalues
[L, ind] = sort(diag(eigenValues),'descend');
sortedEigenVectors = eigenVectors(:, ind);

v = sortedEigenVectors(:,1:k);
u = A * v;

% % Finding Weights
w = A' * u;

abc = u * w';
I = norm_image_G + reshape(abc(:,1), [261,261]);
imshow(mat2gray(I));
%wj = ui'*phitmp;
%I = norm_image_vector + wj_array' * ui_array;



%vi = sortedEigenVectors(:, 10);
%ui = A*vi;
%uiN = norm(ui)
%uiR = reshape(ui_array(:,1), [261,261]);
%uiR_G = mat2gray(uiR);
%imshow(uiR_G);

%% Call function tnm034 

id = tnm034(imageArray{1})
