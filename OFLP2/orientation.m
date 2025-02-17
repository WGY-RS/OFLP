function ANG = orientation(x,y,gradientImg,gradientAng, space, radius, sigma_1, ratio, layer, n, ORI_PEAK_RATIO)

se=strel('disk',radius,0); %�뾶Ϊr��Բ,
Sa=getnhood(se); %Բ������ֵ������ʾԲ�ľ���
 %ͳ���ݶ�ֱ��ͼ��������������ϵ�ֵ
[hist,max_value,angle_1]=calculate_oritation_hist(x,y,radius,gradientImg,gradientAng,space,n,Sa,sigma_1,ratio,layer);
mag_thr=max_value * ORI_PEAK_RATIO;
%�Թؼ���������ݶȴ�С���и�˹��Ȩ��ÿ��������bin���ø�˹��Ȩ������Lowe�Ľ��飬ģ�����[0.25,0.5,0.25]���������������͸�������
ANG=[];
ANG=[ANG,angle_1];
for k=1:n
    if(k==1)
        k1=n;
    else       
        k1=k-1;
    end
    
    if(k==n)
        k2=1;
    else
        k2=k+1;
    end
    if(hist(k)>hist(k1) && hist(k)>hist(k2)&& hist(k)>mag_thr)
        bin=k-1+0.5*(hist(k1)-hist(k2))/(hist(k1)+hist(k2)-2*hist(k));
        if(bin<0)
            bin=n+bin;
        elseif(bin>=n)
            bin=bin-n;
        end
        angle=((360/n)*bin);%0-360
        ANG=[ANG,angle];
    end
end

