function Corner_key_point_array = FeatureDetection(Corner_space,layers,npt)

   
   Corner_key_point_array = [];
   Corner_key_number = 0;  
   for i = 1:1:layers

       Corner_temp_current = Corner_space{i};
       im=Corner_temp_current;       
       a=max(im(:));  b=min(im(:));  im=(im-b)/(a-b);       
       Corner_kpts =  detectKAZEFeatures(im);
       Corner_kpts = Corner_kpts.selectStrongest(npt);      
       NumCorners=Corner_kpts.Count;
       Corner_Kpts=Corner_kpts.Location;
       Corner_nom=Corner_kpts.Metric;
       Corner_nom=mapminmax(Corner_nom(:)',0,1)';       
       PointsCorners=[Corner_Kpts(:,1),Corner_Kpts(:,2)];
    
       
      for j=1:NumCorners
           Corner_key_number = Corner_key_number + 1;
           Corner_key_point_array(Corner_key_number, 1) = floor(PointsCorners(j,1));
           Corner_key_point_array(Corner_key_number, 2) = floor(PointsCorners(j,2));
           Corner_key_point_array(Corner_key_number, 3) =i;
           Corner_key_point_array(Corner_key_number, 4) =Corner_nom(j,1);
       end
   end





