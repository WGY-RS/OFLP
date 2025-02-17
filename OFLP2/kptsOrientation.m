function key_point_array = kptsOrientation(key,gradient,angle,space, sigma_1,ratio)
gradientImg=gradient;gradientAng=angle;
HIST_BIN = 24;
SIFT_ORI_PEAK_RATIO = 0.8;
key_point_array = [];
key_number = 0;
for i = 1: size(key,1)
     x = round(key(i, 1));
     y = round(key(i, 2));  
     layer = key(i,3);
     diameter = 16 * layer;
     if rem(diameter,2)~=0
       diameter=diameter+1;
     end
    x1 = max(1,x-floor(diameter/2));
    y1 = max(1,y-floor(diameter/2));
    x2 = min(x+floor(diameter/2),size(gradientImg{key(i,3)},2));
    y2 = min(y+floor(diameter/2),size(gradientImg{key(i,3)},1));  
    if y2-y1 ~= diameter || x2-x1 ~= diameter
        continue;
    end
        angle = orientation(x,y,gradientImg{key(i,3)},gradientAng{key(i,3)}, space{key(i,3)}, diameter/2, sigma_1, ratio, layer, HIST_BIN, SIFT_ORI_PEAK_RATIO);
        for j=1:size(angle,2)
            key_number = key_number + 1;
            key_point_array(key_number, 1) = x;
            key_point_array(key_number, 2) = y;
            key_point_array(key_number, 3) = key(i,3);
            key_point_array(key_number, 4) = angle(j);
        end
end
    

