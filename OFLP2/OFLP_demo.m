close all;
beep off;
warning('off');
addpath(genpath('Others'));
%% 1 Import and display reference and image to be registered

file_image= 'D:\MATLAB\Images\DataSet_Planteary2(pure)\DataSet_Planteary2(pure)\';

[filename,pathname]=uigetfile({'*.*','All Files(*.*)'},'Select Image',file_image);image1=imread(strcat(pathname,filename));
[filename,pathname]=uigetfile({'*.*','All Files(*.*)'},'Select Image',file_image);image2=imread(strcat(pathname,filename));

 
image_ref = image1; image_sen = image2;
image_1 = im2double(image1);image_2 = im2double(image2);



%% 2  Setting of initial parameters 
%Key parameters:
Path_Block = 48;                   
sigma_1=1.6;   
ratio=2^(1/3);                     
ScaleValue = 1.6;
nOctaves = 3;
filter = 5;
Scale ='YES';


%% 3 Ӱ��ռ�
t1=clock;
disp('Start OFLP algorithm processing, please waiting...');
tic;

Max_space_1 = Create_Image_space(image_1,nOctaves,Scale, ScaleValue, ratio, sigma_1, filter);
Max_space_2 = Create_Image_space(image_2, nOctaves,Scale, ScaleValue, ratio, sigma_1, filter);
disp(['����Ӱ��߶ȿռ仨��ʱ�䣺',num2str(toc),' ��']);

%% 4 ������ȡ
tic;
[Corner_KeyPts_1,Corner_gradient_1,Corner_angle_1]  =  OFLP_features(Max_space_1,sigma_1,ratio,Scale,nOctaves);
[Corner_KeyPts_2,Corner_gradient_2,Corner_angle_2]  =  OFLP_features(Max_space_2,sigma_1,ratio,Scale,nOctaves);
disp(['��������ȡ����ʱ��:  ',num2str(toc),' ��']);


%% 5 GLOH Descriptor 
tic;
Corner_descriptors_1 = GLOH_descriptors(Corner_gradient_1, Corner_angle_1, Corner_KeyPts_1, Path_Block, ratio,sigma_1);
Corner_descriptors_2 = GLOH_descriptors(Corner_gradient_2, Corner_angle_2, Corner_KeyPts_2, Path_Block, ratio,sigma_1);
disp(['���������ӻ���ʱ��:  ',num2str(toc),' ��']); 
tic;


%% 6 Matching by FSC
%����һ
[indexPairs,~]= matchFeatures(Corner_descriptors_1.des,Corner_descriptors_2.des,'MaxRatio',1,'MatchThreshold', 50,'Unique',true); 
[matchedPoints_1,matchedPoints_2] = BackProjection(Corner_descriptors_1.locs(indexPairs(:, 1), :),Corner_descriptors_2.locs(indexPairs(:, 2), :),ScaleValue); 

allNCM = size(matchedPoints_1,1);
[H1,rmse]=FSC(matchedPoints_1,matchedPoints_2,'affine',5);
Y_=H1*[matchedPoints_1(:,[1,2])';ones(1,size(matchedPoints_1,1))];
Y_(1,:)=Y_(1,:)./Y_(3,:);
Y_(2,:)=Y_(2,:)./Y_(3,:);
E=sqrt(sum((Y_(1:2,:)-matchedPoints_2(:,[1,2])').^2));
inliersIndex=E < 5;
clearedPoints1 = matchedPoints_1(inliersIndex, :);
clearedPoints2 = matchedPoints_2(inliersIndex, :);
[clearedPoints2,IA]=unique(clearedPoints2,'rows');
clearedPoints1=clearedPoints1(IA,:);
disp(['����ƥ�仨��ʱ��:  ',num2str(toc),' ��']); 
tic; 

t2=clock;
disp(['����׼����ʱ��:  ',num2str(etime(t2,t1)),' ��']); 


cp_showMatch3(image_ref, image_sen, clearedPoints1,clearedPoints2,[],'');
RCM = size(clearedPoints1,1)/allNCM;
image_fusion2(image_sen,image_ref,double(H1));


fprintf('\n');
disp(['��ȷƥ��������',num2str(size(clearedPoints1,1))]);
disp(['ƥ��ĳɹ���RCM��',num2str(RCM*100),'%']);
disp(['RMSE of Matching results: ',num2str(rmse),'  ����']); 



