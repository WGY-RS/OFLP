function [position, Corner_gradient_cell, Corner_angle_cell] = OFLP_features(Max_space, sigma_1, ratio, Scale_Invariance, nOctaves)
   
   [Corner_space,Corner_gradient_cell,Corner_angle_cell] = OFLP_gradient_feature( Max_space,Scale_Invariance, nOctaves);
    points_layer = 5000; 
   Corner_key_point_array = FeatureDetection(Corner_space,nOctaves,points_layer);
    


    window = 3;
    [keypoints,~]=OFLP_selectMax_NMS(Corner_key_point_array,window);
    Corner_key_point_array = keypoints.kpts;
    uni1=Corner_key_point_array(:,[1,2]);
    [~,i,~]=unique(uni1,'rows','first');
    Corner_key_point_array=Corner_key_point_array(sort(i)',:);
    Corner_key_point_array_end=sortrows(Corner_key_point_array,4,'descend');
    Corner_KeyNum=round(0.85 * size(Corner_key_point_array,1));
    if(size(Corner_key_point_array_end,1)>Corner_KeyNum)
        Corner_key_point_array_end = Corner_key_point_array_end(1:Corner_KeyNum,:);
    else
        Corner_key_point_array_end = Corner_key_point_array_end(:,:);
    end    
    Corner_key_point_array = Corner_key_point_array_end(:,1:3);     
    position = kptsOrientation(Corner_key_point_array,Corner_gradient_cell,Corner_angle_cell,Corner_space,sigma_1,ratio);  
end
