function OutImage = Normalization(temp)
 a=max(temp(:));  b=min(temp(:));  final=(temp-b)/(a-b);  
 OutImage = final;
end

