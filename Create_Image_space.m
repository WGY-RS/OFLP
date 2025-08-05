function Max_Scalespace=Create_Image_space2(im,nOctaves,Scale_Invariance,ScaleValue,ratio,sigma_1,filter)

if (size(im, 3)==3)
    dst=rgb2gray(im);
else
    dst = im;
end


image=double(dst);
[M,N]=size(image);

if (strcmp(Scale_Invariance,'YES'))
    Layers=nOctaves;
else
    Layers=1;
end



Max_Scalespace=cell(1,Layers);
Nonelinear_Scalespace=cell(1,Layers);


for i=1:1:Layers
    Max_Scalespace{1,i}=zeros(M,N);
    Nonelinear_Scalespace{1,i}=zeros(M,N);
end
Nonelinear_Scalespace{1}=image; 


[Max_Scalespace{1}, ~,~, ~] = WPC(image,4,6);



for i=2:Layers
    Nonelinear_Scalespace{1,i} = imresize(Nonelinear_Scalespace{1,i-1},1/ScaleValue,'bilinear');    
    Max_Scalespace{1,i} = WPC(Nonelinear_Scalespace{1,i},4,6);      
end

end

