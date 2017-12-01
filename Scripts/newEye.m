function [e1, e2] = newEye (img) 
    
    [y, x, ~] = size(img);
    [y_orig, x_orig, ~] = size(img);
    
    for i = 1:y
        if mean(img(i,:,1)) > 0
            top = i;
            break;
        end
    end
    
    for i = y:-1:1
        if mean(img(i,:,1)) > 0
            bottom = i;
            break;
        end
    end
    
    for i = 1:x
        if mean(img(:,i,1)) > 0
            left = i;
            break;
        end
    end
    
    for i = x:-1:1
        if mean(img(:,i,1)) > 0
            right = i;
            break;
        end
    end
    
    for i = 1:y
        for j = 1:x
            if img(i,j,1) == 0 && img(i,j,2) == 0 && img(i,j,3) == 0
                img(i,j,1) = 255;
                img(i,j,1) = 255;
                img(i,j,1) = 255;
            end
        end
    end
    
    img = img(top:bottom,left:right,:);
    
    [y, x, ~] = size(img);
    img = img(y/4:y/2,:,:);
%     img = imresize(img, [200 400]);
    [y, x, ~] = size(img);
    erode = strel('diamond',3);
    dilate = strel('diamond',5);
%     img = imdilate(img, dilate);
%     dilateSmall = strel('diamond',3);

%     imshow(img);
%     pause;
    
    ycbcr = rgb2ycbcr(img);
    ycbcr = im2double(ycbcr);

    cb = ycbcr(:,:,2).^3;
    cr = (ycbcr(:,:,3)).^3;
    
%     maxcb = max(max(cb));
%     maxcr = max(max(cr));
%     mincb = min(min(cb));
%     mincr = min(min(cr));
%     
%     for i = 1:y
%         for j = 1:x
%             cr(i,j) = (cr(i,j) - mincr) / (maxcr - mincr);
%             cb(i,j) = (cb(i,j) - mincb) / (maxcb - mincb);
%         end
%     end
    
%     cb = cb.^3;
%     cr = cr.^3;
    y = (1/4*(2*imadjust(cb).^5 + imadjust((1-cr)).^5 + imadjust(cb./cr)/10));
%     y = imerode(y, erode).^3+(cb./cr/10).^3;
%     y = im2bw(imgaussfilt(y,3), 0.2-mean(mean(y)).^2);
    images(:,:,1,1) = imadjust(cb).^5;
    images(:,:,1,2) = imadjust((1-cr)).^5;
    images(:,:,1,3) = imadjust((cb./cr/10)).^2;
    images(:,:,1,4) = y;
    
    montage(images);
    pause;
    
    
    eye1 = y(:,1:floor(x/2));
    eye2 = y(:,floor(x/2):x);

    [Y, X] = ndgrid(1:size(eye1, 1), 1:size(eye1, 2));
    e1 = mean([X(logical(eye1)), Y(logical(eye1))]);

    [Y, X] = ndgrid(1:size(eye2, 1), 1:size(eye2, 2));
    e2 = mean([X(logical(eye2)), Y(logical(eye2))]);

end