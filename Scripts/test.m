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

%% Read in input image
input_img = imread('../Images/DB0/db0_3.jpg');

%% Call function tnm034 
id = tnm034(input_img)
