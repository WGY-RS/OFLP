function [Y] = steerable_gaussians(X1,filter,sigmas,angles)

if size(X1,3)~=1
    X1=rgb2gray(X1);
end 
%% Parameter checking


%% Init. operations
[a,b]=size(X1);
G=[];
%% Construct steerable Gaussians
angle_step = pi/angles;

sigma_1 = 3.2; ratio=2^(1/3);   
sigma=zeros(1,sigmas);
for i=1:sigmas
    sigma(i)=sigma_1*ratio^(i-1);
end


    Wx = filter;
    if Wx < 1
       Wx = 1;
    end
    Wy = filter;
    if Wy < 1
       Wy = 1;
    end
    [X,Y]=meshgrid(-Wy:Wy,-Wx:Wx);
 
    %produce final filters
    for i = 1: sigmas
        g0 = exp(-(X.^2+Y.^2)/(2*sigma(i)^2))/(sigma(i)*sqrt(2*pi));
        G2a = -g0/sigma(i)^2+g0.*X.^2/sigma(i)^4;
        G2b =  g0.*X.*Y/sigma(i)^4;
        G2c = -g0/sigma(i)^2+g0.*Y.^2/sigma(i)^4;
        for j = 1 : angles
            angle = (j-1)*angle_step;
            G{i,j}=imfilter(X1,(cos(angle)^2*G2a+sin(angle)^2*G2c-2*cos(angle)*sin(angle)*G2b),'replicate','same');   
        end
    end
    
CS = zeros(size(X1,1), size(X1,2), 6); %convolution sequence
for j=1:6
    for i=1:4
        CS(:,:,j)=CS(:,:,j)+abs(G{i,j});
    end
end
[Y,~] = min(CS,[],3); % MIM maximum index map


end
