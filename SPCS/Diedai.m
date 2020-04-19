function  Mean=Diedai(X)                      %%%%%  X Îª»Ò¶ÈÍ¼Ïñ
[Ix,Iy]=gradient(double(X));
[Long Width]=size(X);
exy=zeros(Long,Width);
for iiii=1:1:Long
    for jjjj=1:1:Width
        exy(iiii,jjjj)=max(Ix(iiii,jjjj),Iy(iiii,jjjj));
    end
end

Temp=zeros(Long,Width);
for iiii=1:1:Long
    for jjjj=1:1:Width
        Temp(iiii,jjjj)=exy(iiii,jjjj)*X(iiii,jjjj);
    end
end
t=sum(sum(Temp))/sum(sum(exy));

Temp_X=zeros(Long,Width);
num_s=0;
for iiii=1:1:Long
    for jjjj=1:1:Width
        if X(iiii,jjjj)>t
            Temp_X(iiii,jjjj)=X(iiii,jjjj);
            num_s=num_s+1;
        end
    end
end

Mean=sum(sum(Temp_X))/num_s;