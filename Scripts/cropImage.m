function [ top,bottom,left, right ] = cropImage( face_masked )

[y, x, ~] = size(face_masked);

for i = 1:y
    if mean(face_masked(i,:,1)) > 0
        top = i;
        break;
    end
end

for i = y:-1:1
    if mean(face_masked(i,:,1)) > 0
        bottom = i;
        break;
    end
end

for i = 1:x
    if mean(face_masked(:,i,1)) > 0
        left = i;
        break;
    end
end

for i = x:-1:1
    if mean(face_masked(:,i,1)) > 0
        right = i;
        break;
    end
end
end