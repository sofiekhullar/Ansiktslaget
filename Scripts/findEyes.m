function [e1, e2] = findEyes (input)

face = findFace(input);
masked = bsxfun( @times, input, cast(face, class(input)));

[top,bottom,left, right] = cropImage(masked);

img = masked(top:bottom,left:right,:);

[y_, x, ~] = size(img);
img = img(floor(y_/10):floor(3*y_/5),:,:);

test = img;
ycbcr = rgb2ycbcr(test);
ycbcr = im2double(ycbcr);
lab = rgb2lab(test);
lab = im2double(lab);

erode = strel('ball',10,3,2);
dilate = strel('ball',10,3,2);

[y,x,~] = size(test);

a = (lab(:,:,2)/255*5);
a = (1-a).^2;
as = imdilate(a,dilate);
a = as / max(max(as));

cb = (ycbcr(:,:,2));
cb = imerode(cb,erode);
cb = imdilate(cb,dilate);
maxi = max(max(cb));
mini = min(min(cb));

for i = 1:x
    for j = 1:y
        cb(j,i) = (cb(j,i) - mini) / (maxi - mini);
    end
end

cr = (ycbcr(:,:,3));
cr = imerode(cr,erode);
cr = imdilate(cr,dilate);

maxi = max(max(cr));
mini = min(min(cr));
for i = 1:x
    for j = 1:y
        cr(j,i) = (cr(j,i) - mini) / (maxi - mini);
    end
end

back = ((cb.^2 + (1-cr).^2).*cr.*a.*(1-cr).^3).^3;
back = imerode(back,erode);
back = imdilate(back,dilate);

maxi = max(max(back));
mini = min(min(back));
for i = 1:x
    for j = 1:y
        back(j,i) = (back(j,i) - mini) / (maxi - mini);
    end
end

back = back.^2;
m = mean(mean(back));
BW1 = im2bw(back,0.34-m^2);

BW1 = bwmorph(BW1, 'thicken', 8);
BW1 = bwmorph(BW1, 'bridge', 5);
BW1 = bwareafilt(BW1,2);
BW1 = bwfill(BW1, 'holes');

eye1 = BW1(:,1:floor(x/2));
eye2 = BW1(:,floor(x/2):x);

[Y, X] = ndgrid(1:size(eye1, 1), 1:size(eye1, 2));
e1 = mean([X(logical(eye1)), Y(logical(eye1))]);

[Y, X] = ndgrid(1:size(eye2, 1), 1:size(eye2, 2));
e2 = mean([X(logical(eye2)), Y(logical(eye2))]);

e1(1,1) = e1(1,1)+left;
e1(1,2) = e1(1,2)+top+floor(y_/10);

e2(1,1) = e2(1,1)+x/2+left;
e2(1,2) = e2(1,2)+top+floor(y_/10);

end

