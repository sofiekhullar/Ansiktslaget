function [e1, e2] = findEyes (img)

faceDetector = vision.CascadeObjectDetector;
bboxesFace = step(faceDetector, img);
test = img(bboxesFace(1,2):(bboxesFace(1,2) + floor((bboxesFace(1,4)/1.5))), bboxesFace(1,1):(bboxesFace(1,1) + bboxesFace(1,3)),:);

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

eye1 = BW1(:,1:x/2);
eye2 = BW1(:,x/2:x);

[Y, X] = ndgrid(1:size(eye1, 1), 1:size(eye1, 2));
e1 = mean([X(logical(eye1)), Y(logical(eye1))]);

[Y, X] = ndgrid(1:size(eye2, 1), 1:size(eye2, 2));
e2 = mean([X(logical(eye2)), Y(logical(eye2))]);

e1(1,1) = e1(1,1) + bboxesFace(1,1);
e1(1,2) = e1(1,2) + bboxesFace(1,2);

e2(1,1) = e2(1,1) + bboxesFace(1,1) + x/2;
e2(1,2) = e2(1,2) + bboxesFace(1,2);


