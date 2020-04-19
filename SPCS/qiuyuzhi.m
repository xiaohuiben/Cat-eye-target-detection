function    threshold=qiuyuzhi(estIm02)
[Ix,Iy]=gradient(double(estIm02));
[Long Width]=size(estIm02);
exy=zeros(Long,Width);
for iiii=1:1:Long
    for jjjj=1:1:Width
        exy(iiii,jjjj)=max(Ix(iiii,jjjj),Iy(iiii,jjjj));
    end
end

Temp=zeros(Long,Width);
for iiii=1:1:Long
    for jjjj=1:1:Width
        Temp(iiii,jjjj)=exy(iiii,jjjj)*estIm02(iiii,jjjj);
    end
end
t=sum(sum(Temp))/sum(sum(exy));

Temp_estIm02=zeros(Long,Width);
num_s=0;
for iiii=1:1:Long
    for jjjj=1:1:Width
        if estIm02(iiii,jjjj)>t
            Temp_estIm02(iiii,jjjj)=estIm02(iiii,jjjj);
            num_s=num_s+1;
        end
    end
end
% mean(mean(estIm02));
Mean=sum(sum(Temp_estIm02))/num_s;
MAX=double(max(max(estIm02)));
% threshold = graythresh(estIm02);
 threshold=(MAX/255+Mean/255)/2;