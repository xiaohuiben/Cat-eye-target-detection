%% Please refer to the following our paper :
%%%  %By hui li @BeihangU 2013.9.8
% Li Li, Hui Li*, Ersheng Dang, Bo Liu. Compressive sensing method for recognizing cat-eye effect targets [J]. 
% Applied Optics, 2013, 52(28):7033-7039  

%
path(path,genpath(pwd));
if exist('fWHtrans','file') ~= 3
    cd Fast_Walsh_Hadamard_Transform;
    mex -O fWHtrans.cpp
    cd ..;
    fprintf('Finished compiling the C++ code for fast Walsh-Hadamard transform!\n');
end
fprintf('Finished adding paths! Welcome to use TVAL3 beta2.4.\n');
clear all; close all;
path(path,genpath(pwd));
fullscreen = get(0,'ScreenSize');
time=tic;
%%%%%%%%%%%%%%%%%%%% problem size采样率设置
ratio = .45;

%%%%%%%%%%%%%%%%%%%%%%%%%%图像尺寸
sidelength = 400;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  N = sidelength^2;                     %图片像素总数
  M = round(ratio*N);                   % 测量次数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% original image
%  bbr = importdata('5-303022.jpg');
%  bbr1 = importdata('5-303023.jpg');
%  bbr2 = importdata('5-303024.jpg');
%  bbr3 = importdata('5-303026.jpg');
%   bbr = imread('5-303022.jpg');
%  bbr1 =  imread('5-303023.jpg');
%  bbr2 =  imread('5-303024.jpg');
%  bbr3 =  imread('5-303026.jpg');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%适用于会灰度图像 
%  bbr = importdata('302shot0014.jpg');
%  bbr1 = importdata('302shot0015.jpg');
%  bbr2 = importdata('302shot0025.jpg');
%  bbr3 = importdata('302shot0026.jpg');
 
%   a1 = rgb2gray(importdata('1.avi0007.bmp'));
%  a2 = rgb2gray(importdata('1.avi0009.bmp'));
% a3 = rgb2gray(importdata('1.avi0010.bmp'));
% a4 = rgb2gray(importdata('1.avi0012.bmp'));
% 
%  bbr = imresize(a1,[400,400]);
%  bbr1 =  imresize(a2,[400,400]);
%  bbr2 = imresize(a3,[400,400]);
%  bbr3 = imresize(a4,[400,400]);
 
%   a1 = importdata('3.avi0016.bmp');
%  a2 = importdata('3.avi0018.bmp');
% a3 = importdata('3.avi0019.bmp');
% a4 = importdata('3.avi0021.bmp');
%  bbr = imresize(a1,[400,400]);
%  bbr1 =  imresize(a2,[400,400]);
%  bbr2 = imresize(a3,[400,400]);
%  bbr3 = imresize(a4,[400,400]);
 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 a1 = importdata('2012年12月25日-22秒.avi0005.bmp');
 a2 = importdata('2012年12月25日-22秒.avi0006.bmp');
 a3 = importdata('2012年12月25日-22秒.avi0007.bmp');
 a4 = importdata('2012年12月25日-22秒.avi0008.bmp');
 bbr = imresize(a1,[400,400]);
 bbr1 =  imresize(a2,[400,400]);
 bbr2 = imresize(a3,[400,400]);
 bbr3 = imresize(a4,[400,400]);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%  bbr = importdata('5-301-shot0002.jpg');
%  bbr1 = importdata('5-301-shot0004.jpg');
%  bbr2 = importdata('5-301-shot0008.jpg');
%  bbr3 = importdata('5-301-shot0007.jpg');
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Im = double(bbr(:,:,1));
Im1 = double(bbr1(:,:,1));
Im2 = double(bbr2(:,:,1));
Im3 = double(bbr3(:,:,1));


% generate measurement matrix
p = randperm(N);           %%产生随机数         
picks = p(1:M); 
% picks2=p(1:5);
for ii = 1:M
    if picks(ii) == 1
        picks(ii) = p(M+1);
        break;
    end
end
perm = randperm(N); % column permutations (排列)allowable    产生随机数

A = @(x,mode)dfA(x,picks,perm,mode);%带入参数四个
% observation观测结果
b = A(Im(:),1);     %%Im(:)将数组按列排成向量
b1= A(Im1(:),1);
b2= A(Im2(:),1);
b3= A(Im3(:),1);
b4=b-b1;
b5=b2-b1;
b6=b2-b3;
b6_a2=(b4+b6)./2;
b7=(b4+b5+b6)./3;
bz=b7-b6_a2;


clear opts
opts.mu = 2^6;               %primary penalty parameter
opts.beta = 2^4;              %secondary penalty parameter
opts.mu0 = 2^4;               % trigger continuation shceme
opts.beta0 = 2^-1;            % trigger continuation shceme
opts.maxcnt = 5;             %maximum outer iterations
opts.tol_inn = 1e-1;          %inner stopping tolerance
opts.tol = 1E-1;              %outer stopping tolerance
opts.maxit = 100;             %maximum total iterations
% reconstruction
% t = cputime;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 [estIm4, out4] = TVAL3(A,b6_a2,sidelength,sidelength,opts);
 [estIm5, out5] = TVAL3(A,bz,sidelength,sidelength,opts);
tic; [estIm7, out7] = TVAL3(A,b7,sidelength,sidelength,opts);toc;
times=toc(time);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estIm4=uint8(estIm4);
%    estIm5=uint8(estIm5);
%     estIm7=uint8(estIm7);
%  estIm4= estIm4 - min(estIm4(:));
%  estIm5= estIm5 - min(estIm5(:));
% estIm7= estIm7 - min(estIm7(:));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%将重建后图像灰度统一为0~255
% maxEstIm=max(max(estIm7));
% estIm7=estIm7/maxEstIm.*255;
% maxEstIm1=max(max(estIm4));
% estIm4=estIm4/maxEstIm1.*255;
% maxEstIm2=max(max(estIm5));
% estIm5=estIm5/maxEstIm2.*255;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
estIm8=zeros(400,400);
for i=1:400
     for j=1:400
         if  estIm7(i,j)-estIm5(i,j)>0
             estIm8(i,j)=estIm7(i,j)-estIm5(i,j);
         end
     end
end
estIm9=zeros(400,400);
for i=1:400
     for j=1:400
         if  estIm4(i,j)-estIm5(i,j)>0
             estIm9(i,j)=estIm4(i,j)-estIm5(i,j);
         end
     end
end
% estIm8=estIm7-estIm5;
% estIm9=estIm4-estIm5;

figure(1),subplot(2,2,1),imshow(bbr);
          subplot(2,2,2),imshow(bbr1);
          subplot(2,2,3),imshow(bbr2);
          subplot(2,2,4),imshow(bbr3);
figure(2),subplot(1,3,1),imshow(estIm4,[]);title(sprintf('a'),'fontsize',13);
          subplot(1,3,2),imshow(estIm7,[]);title(sprintf('b'),'fontsize',13);
          subplot(1,3,3),imshow(estIm5,[]);title(sprintf('c'),'fontsize',13);
figure(3),subplot(2,2,1),imshow(estIm9,[]);title(sprintf('a'),'fontsize',13);
          subplot(2,2,2),imshow(estIm8,[]);title(sprintf('b'),'fontsize',13);
          
            figure(4), subplot('position',[0.02,0.375,.21,.25]), imshow(estIm8,[]);title(sprintf('a'),'fontsize',10);
            subplot('position',[0.52,0.375,.21,.25]), imshow(estIm9,[]);title(sprintf('c'),'fontsize',10);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%画三维灰度图
gg=double(estIm8);             % 转为数值矩阵
             % 将彩色值转为 0-1 的渐变值
[x,y]=size(gg);             % 取原图大小
[X,Y]=meshgrid(1:y,1:x); % 以原图大小构建网格
% x=0:20:240;
% y=0:20:240;
% z=0:50:250;
 figure(4), subplot('position',[0.27,0.375,.21,.25]), imshow(estIm8);title(sprintf('b'),'fontsize',10);
plot3(X,Y,gg);
% title('Line in 3-D Space');
xlabel('X');ylabel('Y');zlabel('Z');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gg=double(estIm9);             % 转为数值矩阵
             % 将彩色值转为 0-1 的渐变值
[x,y]=size(gg);             % 取原图大小
[X,Y]=meshgrid(1:y,1:x); % 以原图大小构建网格
% x=0:20:240;
% y=0:20:240;
% z=0:50:250;
 figure(4), subplot('position',[0.77,0.375,.21,.25]), imshow(estIm9);title(sprintf('d'),'fontsize',10);
plot3(X,Y,gg);
% title('Line in 3-D Space');
xlabel('X');ylabel('Y');zlabel('Z');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%3.24% 
 H = fspecial('average',[4 4]);   %%滤波算子
 estIm8 = imfilter(estIm8,H);   %%滤波
 estIm9 = imfilter(estIm9,H);   %%滤波

 estIm02=uint8(estIm8);
 estIm03=uint8(estIm9);
threshold1=qiuyuzhi(estIm02);
threshold2=qiuyuzhi(estIm03);

 bw1= im2bw(estIm02,threshold1);
  bw2= im2bw(estIm03,threshold2);
  bw=bw1&bw2;
 figure(5),subplot(1,3,1),imshow(bw1),title(sprintf('a'),'fontsize',13); 
           subplot(1,3,2),imshow(bw2),title(sprintf('b'),'fontsize',13); 
           subplot(1,3,3),imshow(bw),title(sprintf('c'),'fontsize',13); 
  
  

