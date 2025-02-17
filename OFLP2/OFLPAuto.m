function  [H,rmse,alltime,NCM,NCR,SR,out1,out2,fusion_image,mosaic_map] = OFLPAuto(index,image1,image2,Path_Block,sigma_1,ratio,ScaleValue,nOctaves,filter,Scale,gcp);
%% 1 Import and display reference and image to be registered


image_ref = image1; image_sen = image2;
image_1 = im2double(image1);image_2 = im2double(image2);

t1=clock;
disp(['Start ',num2str(index),' FDAFT-FAST algorithm processing, please waiting...']);
Max_space_1 = Create_Image_space(image_1,nOctaves,Scale, ScaleValue, ratio, sigma_1, filter);
Max_space_2 = Create_Image_space(image_2, nOctaves,Scale, ScaleValue, ratio, sigma_1, filter);

%% 4 特征提取
[Corner_KeyPts_1,Corner_gradient_1,Corner_angle_1]  =  OFLP_features(Max_space_1,sigma_1,ratio,Scale,nOctaves);
[Corner_KeyPts_2,Corner_gradient_2,Corner_angle_2]  =  OFLP_features(Max_space_2,sigma_1,ratio,Scale,nOctaves);

%% 5 GLOH Descriptor 
Corner_descriptors_1 = GLOH_descriptors(Corner_gradient_1, Corner_angle_1, Corner_KeyPts_1, Path_Block, ratio,sigma_1);
Corner_descriptors_2 = GLOH_descriptors(Corner_gradient_2, Corner_angle_2, Corner_KeyPts_2, Path_Block, ratio,sigma_1);

%% 6 Matching by FSC
%方案一
[indexPairs,~]= matchFeatures(Corner_descriptors_1.des,Corner_descriptors_2.des,'MaxRatio',1,'MatchThreshold', 50,'Unique',true); 
[matchedPoints1,matchedPoints2] = BackProjection(Corner_descriptors_1.locs(indexPairs(:, 1), :),Corner_descriptors_2.locs(indexPairs(:, 2), :),ScaleValue);                                               


allNCM = size(matchedPoints1,1);


[H,~]=FSC(matchedPoints1,matchedPoints2,'affine',5);     % perspective   /  affine   
Y_=H*[matchedPoints1(:,[1,2])';ones(1,size(matchedPoints1,1))];
Y_(1,:)=Y_(1,:)./Y_(3,:);
Y_(2,:)=Y_(2,:)./Y_(3,:);
E=sqrt(sum((Y_(1:2,:)-matchedPoints2(:,[1,2])').^2));
inliersIndex=E < 5;
clearedPoints1 = matchedPoints1(inliersIndex, :);
clearedPoints2 = matchedPoints2(inliersIndex, :);
t2=clock;


gcp1 = gcp(:,[1,2]);
gcp2 = gcp(:,[3,4]);

%利用真值计算NCM和NCR
H1 = fitgeotrans(gcp(:,[1:2]),gcp(:,[3:4]),'affine');%估计投影模型
clearedPoints1_2 = transformPointsForward(H1,clearedPoints1);
E=sqrt(sum((clearedPoints2(:,1:2)- clearedPoints1_2(:,1:2)).^2,2));
inliersIndex = E < 5;
clearedPoints1_2 = clearedPoints1(inliersIndex, :);


% 对左影像每个真值点应用旋转矩阵
tform_cor = fitgeotrans(clearedPoints1(:,1:2),clearedPoints2(:,1:2),'affine');%估计投影模型
gcp1_2 = transformPointsForward(tform_cor,gcp1);


sum_error = 0;
N = size(gcp1,1);
for k = 1:N
    sum_error = sum_error+((gcp1_2(k,1)-gcp2(k,1)).^2+(gcp1_2(k,2)-gcp2(k,2)).^2);
end
rmse = sqrt(sum_error/N);
NCM = size(clearedPoints1_2,1);
if rmse > 5
    rmse = 10;
    SR = 0;
    NCM = 0;
else
    SR = 100;
end


NCR= NCM/allNCM; 
rmse = num2str(rmse);
NCM = num2str(NCM);
NCR= num2str(NCR*100);
alltime = num2str(etime(t2,t1));
SR = num2str(SR);

out1 = cp_showMatch(image_1, image_2, clearedPoints1(:,[1,2]), clearedPoints2(:,[1,2]),[],'HOWP');
out2 = cp_showMatch2(image_1, image_2, clearedPoints1(:,[1,2]), clearedPoints2(:,[1,2]),[],'HOWP');
[fusion_image,mosaic_map] = image_fusion(im2uint8(image_sen),im2uint8(image_ref),double(H));



end
