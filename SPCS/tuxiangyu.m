function [bw1,bw2,bw_R,Sub_I1,Sub_I2]=tuxiangyu(x1,x2,x3,x4)
 I1=x1;
 I2=x2;
 I3=x3;
 I4=x4;
Sub_I1=I1-I2;
Sub_I2=I3-I4;

H = fspecial('average',[4 4]);  
Sub_I1= imfilter(Sub_I1,H);
Sub_I2= imfilter(Sub_I2,H);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%迭代求分割阈值
 Mean1=Diedai(Sub_I1);
 Mean2=Diedai(Sub_I2);
 threshold1 = Mean1/255;
 threshold2 = Mean2/255;
 
bw1 = im2bw(Sub_I1,threshold1);
bw2 = im2bw(Sub_I2,threshold2);
[long width]=size(bw1);
bw_R=zeros(long,width);
 for i=1:long
     for j=1:width
         bw_R(i,j)=bw1(i,j)&bw2(i,j);
     end
 end