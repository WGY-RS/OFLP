function [Corner_space,Corner_gradient_cell,Corner_angle_cell] = OFLP_gradient_feature(Max_Scalespace,Scale_Invariance, nOctaves)


    if (strcmp(Scale_Invariance, 'YES'))
        Layers = nOctaves;
    else
        Layers = 1;
    end

    [M, N] = size(Max_Scalespace{1});
    Corner_gradient_cell = cell(1, Layers);
    Corner_angle_cell = cell(1, Layers);
    Corner_space = cell(1, Layers);


    for j = 1:Layers
      Corner_gradient_cell{1,j} = zeros(M, N);
      Corner_angle_cell{1,j} = zeros(M, N);
      Corner_space{1,j} = zeros(M, N);       
    end


   %sobel
    h1 = [- 1, 0, 1; - 2, 0, 2; - 1, 0, 1];
    h2 = [- 1, - 2, - 1; 0, 0, 0; 1, 2, 1];
    
    
    for j = 1:Layers
        Cornerspace  = double(1 * Max_Scalespace{1,j});
        Cornerspace = steerable_gaussians22(Cornerspace,5,5,6)/6; 
        Corner_space{1,j} = double(Max_Scalespace{1,j});  
        %figure;imshow(Max_Scalespace{1,j});
 
        %Corner
        gradient_x_Corner_1 = imfilter(Cornerspace, h1, 'replicate');
        gradient_y_Corner_1 = imfilter(Cornerspace, h2, 'replicate');       
        gradient_Corner_1 = sqrt(gradient_x_Corner_1.^2 + gradient_y_Corner_1.^2);
        Corner_gradient_cell{j} = single(gradient_Corner_1);
    
        Corner_angle = atan2(gradient_y_Corner_1, gradient_x_Corner_1);
        Corner_angle = Corner_angle * 180 / pi;
        Corner_angle(Corner_angle < 0) = Corner_angle(Corner_angle < 0) + 360;
        Corner_angle_cell{j} = single(Corner_angle);  


    end
end
    
  
    



