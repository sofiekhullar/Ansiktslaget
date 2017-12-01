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

% Calc new image array
number_of_files = 0;
raw_images = {1,nfiles};

for i=1:nfiles
    currentImage = imageArray{i};
    [leftEye, rightEye] = findEyes(currentImage);
    mouth = findMouth(currentImage);
    
    if (isnan(leftEye(1,1)) || isnan(leftEye(1,2)) || isnan(rightEye(1,1)) || isnan(rightEye(1,2)) || isnan(mouth(1,1)) || isnan(mouth(1,2)) || (i == 12))
        continue;
    end
    
    number_of_files = number_of_files + 1;
    
    currentImage = transformFace(currentImage, leftEye, rightEye, mouth);
    newImage = rgb2gray(currentImage);
    
    raw_images{number_of_files} = newImage;
end 

clearvars -except raw_images number_of_files

%%
clc
temp = zeros(length(raw_images{1})^2, 1);

raw_vector = zeros(length(raw_images{1})^2, number_of_files);

for i = 1:number_of_files
    raw_vector(:,i) = raw_images{i}(:);
    temp = temp + raw_vector(:,i);
end

psi = temp / number_of_files;
phi = raw_vector - psi;

A = phi;
C = A'*A;

[eig_mat, eig_vals] = eig(C);

eig_vals_vect = diag(eig_vals);
[sorted_eig_vals, eig_indices] = sort(eig_vals_vect,'descend');
sorted_eig_mat = zeros(number_of_files);

for i=1:number_of_files
    sorted_eig_mat(:,i) = eig_mat(:,eig_indices(i));
end

eig_faces = (A*sorted_eig_mat);

% Show
nr = 1;
figure;
imshow(mat2gray(reshape(Eig_faces(:,nr), [261,261])));

%% Call function tnm034 

id = tnm034(imageArray{1})
