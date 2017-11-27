function [ triangle ] = transform_face( picture, left_eye_x, left_eye_y, right_eye_x, right_eye_y, mouth_x, mouth_y )
%TRANSFORM Summary of this function goes here
%   Detailed explanation goes here

% Init
triangle = picture;

[height, width, ~] = size(triangle);
origo.x = (width / 2);
origo.y = (height / 2);

left_eye.x = left_eye_x;
left_eye.y = left_eye_y;
right_eye.x = right_eye_x;
right_eye.y = right_eye_y;
mouth.x = mouth_x;
mouth.y = mouth_y;

% Find middle
left_eye_mouth_middle.x = (left_eye.x + mouth.x) / 2;
left_eye_mouth_middle.y = (left_eye.y + mouth.y) / 2;

right_eye_mouth_middle.x = (right_eye.x + mouth.x) / 2;
right_eye_mouth_middle.y = (right_eye.y + mouth.y) / 2;

dots = 100;
left_to_right.x = linspace(left_eye_mouth_middle.x, right_eye.x, dots);
left_to_right.y = linspace(left_eye_mouth_middle.y, right_eye.y, dots);

right_to_left.x = linspace(right_eye_mouth_middle.x, left_eye.x, dots);
right_to_left.y = linspace(right_eye_mouth_middle.y, left_eye.y, dots);

diff_min = abs(left_to_right.x-right_to_left.x)+abs(left_to_right.y-right_to_left.y);
[~,index_min] = min(diff_min);

middle.x = round((left_to_right.x(index_min)+right_to_left.x(index_min)) / 2);
middle.y = round((left_to_right.y(index_min)+right_to_left.y(index_min)) / 2);

% figure;
% imshow(triangle)
% hold on;
% plot(left_eye.x, left_eye.y,'--o','LineWidth',2);
% plot(right_eye.x , right_eye.y,'--o','LineWidth',2);
% plot(mouth.x, mouth.y,'--o','LineWidth',2);
% plot(middle.x, middle.y,'--x','LineWidth',2);
% plot(origo.x, origo.y,'--x','LineWidth',2);
% grid on;
% hold off;

% Translate image to middle
diff.x = round(origo.x - middle.x);
diff.y = round(origo.y - middle.y);

left_eye.x = left_eye.x + diff.x;
left_eye.y = left_eye.y + diff.y;

right_eye.x = right_eye.x + diff.x;
right_eye.y = right_eye.y + diff.y;

mouth.x = mouth.x + diff.x;
mouth.y = mouth.y + diff.y;

middle.x = middle.x + diff.x;
middle.y = middle.y + diff.y;

triangle = imtranslate(triangle,[diff.x, diff.y]);

% figure;
% imshow(triangle)
% hold on;
% plot(left_eye.x, left_eye.y,'--o','LineWidth',2);
% plot(right_eye.x , right_eye.y,'--o','LineWidth',2);
% plot(mouth.x, mouth.y,'--o','LineWidth',2);
% plot(middle.x, middle.y,'--x','LineWidth',2);
% plot(origo.x, origo.y,'--x','LineWidth',2);
% grid on;
% hold off;

% Rotate
slope = (left_eye.y - right_eye.y) / (left_eye.x - right_eye.x);
angle_rad = -atan(slope);

left_eye.x = origo.x + cos(angle_rad) * (left_eye.x - origo.x) - sin(angle_rad) * (left_eye.y - origo.y);
left_eye.y = origo.y + sin(angle_rad) * (left_eye.x - origo.x) + cos(angle_rad) * (left_eye.y - origo.y);

right_eye.x = origo.x + cos(angle_rad) * (right_eye.x - origo.x) - sin(angle_rad) * (right_eye.y - origo.y);
right_eye.y = origo.y + sin(angle_rad) * (right_eye.x - origo.x) + cos(angle_rad) * (right_eye.y - origo.y);

mouth.x = origo.x + cos(angle_rad) * (mouth.x - origo.x) - sin(angle_rad) * (mouth.y - origo.y);
mouth.y = origo.y + sin(angle_rad) * (mouth.x - origo.x) + cos(angle_rad) * (mouth.y - origo.y);

angle_deg = radtodeg(angle_rad);

triangle = imrotate(triangle, -angle_deg, 'bicubic');

% figure;
% imshow(triangle)
% hold on;
% plot(left_eye.x, left_eye.y,'--o','LineWidth',2);
% plot(right_eye.x , right_eye.y,'--o','LineWidth',2);
% plot(mouth.x, mouth.y,'--o','LineWidth',2);
% plot(middle.x, middle.y,'--x','LineWidth',2);
% plot(origo.x, origo.y,'--x','LineWidth',2);
% grid on;
% hold off;

% Translate dots to middle
[height, width, ~] = size(triangle);
origo.x = (width / 2);
origo.y = (height / 2);

diff.x = round(origo.x - middle.x);
diff.y = round(origo.y - middle.y);

left_eye.x = left_eye.x + diff.x;
left_eye.y = left_eye.y + diff.y;

right_eye.x = right_eye.x + diff.x;
right_eye.y = right_eye.y + diff.y;

mouth.x = mouth.x + diff.x;
mouth.y = mouth.y + diff.y;

middle.x = middle.x + diff.x;
middle.y = middle.y + diff.y;

% figure;
% imshow(triangle)
% hold on;
% plot(left_eye.x, left_eye.y,'--o','LineWidth',2);
% plot(right_eye.x , right_eye.y,'--o','LineWidth',2);
% plot(mouth.x, mouth.y,'--o','LineWidth',2);
% plot(middle.x, middle.y,'--x','LineWidth',2);
% plot(origo.x, origo.y,'--x','LineWidth',2);
% grid on;
% hold off;

% Scale
goal_diff = 130;

diff = sqrt((left_eye.x - right_eye.x)^2 + (left_eye.y - right_eye.y)^2);
change = goal_diff / diff;

triangle = imresize(triangle,change);

% figure;
% imshow(triangle)
% hold on;
% plot(left_eye.x, left_eye.y,'--o','LineWidth',2);
% plot(right_eye.x , right_eye.y,'--o','LineWidth',2);
% plot(mouth.x, mouth.y,'--o','LineWidth',2);
% plot(middle.x, middle.y,'--x','LineWidth',2);
% grid on;
% hold off;

% Crop image
h = goal_diff*2;
w = goal_diff*2;

[height, width, ~] = size(triangle);
origo.x = (width / 2);
origo.y = (height / 2);

triangle = imcrop(triangle,[origo.x-(w/2) origo.y-(h/2) w h]);

% figure;
% imshow(triangle)
% hold on;
% plot(origo.x, origo.y,'--x','LineWidth',2);
% grid on;
% hold off;

end

