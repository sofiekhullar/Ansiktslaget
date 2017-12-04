function [ pic ] = transformFace( pic, left_eye, right_eye, mouth)
%   Centers, rotates, scales and crops the picture. (transformFace( pic,
%   left_eye, right_eye, mouth))

% Init
[height, width, ~] = size(pic);
origo = [width, height] / 2;

% Find middle
left_eye_mouth_middle = (left_eye + mouth) / 2;
right_eye_mouth_middle = (right_eye + mouth) / 2;

dots = 100;

left_to_right(1,:) = linspace(left_eye_mouth_middle(1), right_eye(1), dots);
left_to_right(2,:) = linspace(left_eye_mouth_middle(2), right_eye(2), dots);

right_to_left(1,:) = linspace(right_eye_mouth_middle(1), left_eye(1), dots);
right_to_left(2,:) = linspace(right_eye_mouth_middle(2), left_eye(2), dots);


diff_min = abs(left_to_right(1,:)-right_to_left(1,:))+abs(left_to_right(2,:)-right_to_left(2,:));
[~,index_min] = min(diff_min);

middle = round((left_to_right(:,index_min)+right_to_left(:,index_min)) / 2)';

% figure;
% imshow(triangle)
% hold on;
% plot(left_eye(1), left_eye(2),'--o','LineWidth',2);
% plot(right_eye(1), right_eye(2),'--o','LineWidth',2);
% plot(mouth(1), mouth(2),'--o','LineWidth',2);
% plot(middle(1), middle(2),'--x','LineWidth',2);
% plot(origo(1),origo(2),'--x','LineWidth',2);
% grid on;
% hold off;

% Translate image to middle
diff = round(origo - middle);

left_eye = left_eye + diff;
right_eye = right_eye + diff;
mouth = mouth + diff;
middle = middle + diff;

pic = imtranslate(pic,diff);

% figure;
% imshow(triangle)
% hold on;
% plot(left_eye(1), left_eye(2),'--o','LineWidth',2);
% plot(right_eye(1), right_eye(2),'--o','LineWidth',2);
% plot(mouth(1), mouth(2),'--o','LineWidth',2);
% plot(middle(1), middle(2),'--x','LineWidth',2);
% plot(origo(1),origo(2),'--x','LineWidth',2);
% grid on;
% hold off;

% Rotate
slope = (left_eye(2) - right_eye(2)) / (left_eye(1) - right_eye(1));
angle_rad = -atan(slope);

left_eye(1) = origo(1) + cos(angle_rad) * (left_eye(1) - origo(1)) - sin(angle_rad) * (left_eye(2) - origo(2));
left_eye(2) = origo(2) + sin(angle_rad) * (left_eye(1) - origo(1)) + cos(angle_rad) * (left_eye(2) - origo(2));

right_eye(1) = origo(1) + cos(angle_rad) * (right_eye(1) - origo(1)) - sin(angle_rad) * (right_eye(2) - origo(2));
right_eye(2) = origo(2) + sin(angle_rad) * (right_eye(1) - origo(1)) + cos(angle_rad) * (right_eye(2) - origo(2));

mouth(1) = origo(1) + cos(angle_rad) * (mouth(1) - origo(1)) - sin(angle_rad) * (mouth(2) - origo(2));
mouth(2) = origo(2) + sin(angle_rad) * (mouth(1) - origo(1)) + cos(angle_rad) * (mouth(2) - origo(2));

angle_deg = radtodeg(angle_rad);

pic = imrotate(pic, -angle_deg, 'bicubic');

% figure;
% imshow(triangle)
% hold on;
% plot(left_eye(1), left_eye(2),'--o','LineWidth',2);
% plot(right_eye(1), right_eye(2),'--o','LineWidth',2);
% plot(mouth(1), mouth(2),'--o','LineWidth',2);
% plot(middle(1), middle(2),'--x','LineWidth',2);
% plot(origo(1),origo(2),'--x','LineWidth',2);
% grid on;
% hold off;

% Translate dots to middle
[height, width, ~] = size(pic);
origo = [width, height] / 2;

diff = round(origo - middle);
left_eye = left_eye + diff;
right_eye = right_eye + diff;
mouth = mouth + diff;
middle = middle + diff;

% figure;
% imshow(triangle)
% hold on;
% plot(left_eye(1), left_eye(2),'--o','LineWidth',2);
% plot(right_eye(1), right_eye(2),'--o','LineWidth',2);
% plot(mouth(1), mouth(2),'--o','LineWidth',2);
% plot(middle(1), middle(2),'--x','LineWidth',2);
% plot(origo(1),origo(2),'--x','LineWidth',2);
% grid on;
% hold off;

% Scale
goal_diff = 130;

diff = sqrt((left_eye(1) - right_eye(1))^2 + (left_eye(2) - right_eye(2))^2);
change = goal_diff / diff;

pic = imresize(pic,change);

% Crop image
h = goal_diff*2;
w = goal_diff*2;

[height, width, ~] = size(pic);
origo = [width, height] / 2;

pic = imcrop(pic,[origo(1)-(w/2) origo(2)-(h/2), w, h]);

% figure;
% imshow(triangle);   

end

