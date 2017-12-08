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

images = imageArray;
%%
correct = [1 2 4 5 6 7 10 13 14 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 1 3 4 7 9 11 12 1 7 8 9 12 16]';
% correct = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16]';
% correct = [0 0 0 0]';

score = zeros(16,10);
% 
% for k = 1:16
%     for threshold = 200:200:2000
        prediction = zeros(length(images),1);
        for i = 1:length(images)
            prediction(i) = tnm034(images{i}, 10, 200)
        end
        score1 =  mean(prediction == correct)
%         score(k, threshold/200) = mean(prediction == correct);
%         score(k, threshold/200)
%     end
% end
