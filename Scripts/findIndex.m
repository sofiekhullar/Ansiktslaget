function [min_ind] = findIndex(w, x) 

    threshold = 100;
    n_images = size(w,2);
    min_dist = 10000;
    min_ind = 0;

    for i = 1:n_images
        
        dist = sqrt(sum((w(:,i) - x).^2))
        
        if  dist < min_dist
            min_dist = dist;
            if min_dist < threshold
                min_ind = i;
            end
        end
    end
end