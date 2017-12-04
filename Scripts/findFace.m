function [a] = findFace(i)

 erode = strel('disk',40);
 erode_big = strel('disk',50);
 dilate = strel('disk',65);
 dilateSmall = strel('diamond',3);

 i = imgaussfilt(i,10);
 h = fspecial('motion', 50, 45);
 i = imfilter(i, h);
 
 lab = rgb2lab(i);
 a = lab(:,:,2)/100;
 m = abs(mean(mean(a)));
 a = im2bw(a, 1.*m);
 a = imerode(a, erode);
%  a = imfill(a,'holes');
%  a = imdilate(a, dilate);
%  a = imdilate(a, dilateSmall);
 a = bwareafilt(a,1);
 a = imerode(a, erode_big);
%  a = bwareafilt(a,1);
 a = imdilate(a, dilate);
end