DBdir = '../Images/DB1/';
imagefiles = dir(strcat(DBdir,'*.jpg')); 
nfiles = length(imagefiles);
imageArray = {1,nfiles}; 

for i = 1:nfiles
   currentfilename = imagefiles(i).name;
   currentimage = imread(strcat(DBdir,currentfilename));
   imageArray{i} = currentimage;
end

for i = 1:16
    
    test = imageArray{i};
    face = findFace(test);
    masked = bsxfun( @times, test, cast(face, class(test)));

    imshow(test);
    pause;
    imshow(masked);
    pause;
%     pause;
%     newEye(masked);
    [e1, e2] = findEyes(masked);
%     m = findMouth(masked);
    eyes = insertMarker(test,[e1(1) e1(2); e2(1) e2(2)]);
    imshow(eyes);
    pause;

end