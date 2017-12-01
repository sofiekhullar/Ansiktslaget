function [a] = findFace(i)

 erode = strel('diamond',22);
 dilate = strel('diamond',50);
 dilateSmall = strel('diamond',3);

 i = imgaussfilt(i,6);
 h = fspecial('motion', 50, 45);
 i = imfilter(i, h);
 
 
 lab = rgb2lab(i);
 a = lab(:,:,2)/100;
 a = im2bw(a, mean(mean(a)));
 a = imerode(a, erode);
 a = imfill(a,'holes');
%  a = imdilate(a, dilate);
%  a = imdilate(a, dilateSmall);
 a = bwareafilt(a,1);
end