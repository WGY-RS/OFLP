%
clear;close all;
warning('off');
addpath(genpath('Others'));

Path_Block = 48;                   
sigma_1=1.6;   
ratio=2^(1/3);                     
ScaleValue = 1.6;
nOctaves = 3;
filter = 5;
Scale ='YES';

tableData = table();
folderPath = 'D:\MATLAB\MyCode\DataSet_Planteary2(pure)\DataSet_Planteary2(pure)\';
fileList  = dir(fullfile(folderPath,'*.png'));

index = 1;
for i = 1:100
    image1_name = [num2str(index), '-1'];
    image2_name = [num2str(index), '-2'];    
    
        image1Path = fullfile(folderPath, strcat(image1_name, '.png'));
        image2Path = fullfile(folderPath, strcat(image2_name, '.png'));
        image_1 = imread(image1Path);
        image_2 = imread(image2Path);
        gcp = importdata(fullfile(folderPath,'gcp',strcat(num2str(index),'.txt')));
        [H,RMSE,Time,NCM,NCR,SR,out1,out2,fusion_image,mosaic_map] = OFLPAuto(index,image_1,image_2,Path_Block,sigma_1,ratio,ScaleValue,nOctaves,filter,Scale,gcp);        
        result = string({RMSE,NCM,NCR,SR,Time});
        Var_once = table(result);       
        tableData = [tableData; Var_once];
        
        savePath1 = fullfile(folderPath,'OFLP',strcat([num2str(index), '-1'], '.png'));
        savePath2 = fullfile(folderPath,'OFLP',strcat([num2str(index), '-2'], '.png'));
        savePath3 = fullfile(folderPath,'OFLP',strcat([num2str(index), '-3'], '.png'));
        
        if str2double(RMSE) < 5
           imwrite(out1, savePath1);
           imwrite(fusion_image, savePath2);
           imwrite(mosaic_map, savePath3);
        else
           imwrite(out2, savePath1);
           imwrite(fusion_image, savePath2);
           imwrite(mosaic_map, savePath3);            
        end
  
         index = index + 1;
end
   writetable(tableData, 'D:\MATLAB\MyCode\DataSet_Planteary2(pure)\DataSet_Planteary2(pure)\OFLP_results.xls');
   


    
    
    