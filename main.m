close all;
clear all;
clc;
target=imread('img/1.jpg'); % 模板
test=imread('img/2.jpg'); % 测试的图片
% 把图像二值化，使用最大类间方差法找到图片的一个合适的阈值（threshold）
test = im2bw(test,graythresh(test));
target = im2bw(target,graythresh(target));
% imshow(test);
% imshow(target);
% 去除白边框
i = 1;
while i <= size(target,1)
    if(sum(target(i,:)) == size(target,2))
        target(i,:)=[];
    else
        i = i+1;
    end
end
i = 1;
while i <= size(target,2)
    if(sum(target(:,i)) == size(target,1))
        target(:,i)=[];
    else
        i = i+1;
    end
end

target = cut_pic_black(target);% 去除多余的黑边
imshow(target)

% 以15度等差进行旋转
ang = 15;
figure(1);
for z=1:360/ang
    % 旋转
    target_B=imrotate(target,z*ang,'bicubic','crop'); %旋转，双立方体插值，剪切为相同大小
    target_B=cut_pic_black(target_B); % 裁剪去黑边
    [m,n]=size(test);  
    [m0,n0]=size(target_B);  
    result=zeros(m-m0+1,n-n0+1); %逐像素判断 
    vec_sub = double( target_B(:) );  
    norm_sub = norm( vec_sub ); %便于后面相似性判断  
    for i=1:m-m0+1  
        for j=1:n-n0+1  
            subMatr=test(i:i+m0-1,j:j+n0-1);  
            vec=double( subMatr(:) );  
            result(i,j)=vec'*vec_sub / (norm(vec)*norm_sub+eps);  %相似性
        end
    end
    
    [iMaxPos,jMaxPos]=find( result==max( result(:))); % 找到最大相关位置
    MaxPos(z,:)=[iMaxPos(1),jMaxPos(1)]; % 在当前角度最大的匹配位置
    
    % 计算相似性
    best_pic = test(iMaxPos:iMaxPos+m0-1,jMaxPos:jMaxPos+n0-1);
    accuracy(1,z) = 1.0*(m0*n0 - sum(sum(abs(best_pic - target_B))))/(m0*n0);
    angle(1,z) = z*ang; %记录角度信息
    
    % 显示24个旋转后的图片
    subplot(ceil(sqrt(360/ang)),ceil(sqrt(360/ang)),z);
    imshow(target_B);
    title([int2str(z*ang),' Degree']);
end

% 旋转角度与匹配指标
[angle' accuracy']

% 得到模板最佳匹配位置
[best_accuracy,best_index] = max(accuracy);
angle(best_index);
iMax = MaxPos(best_index,1);
jMax = MaxPos(best_index,2);


% 画图
figure(2);
subplot(121);
imshow(target);
title('target');  
subplot(122);  
imshow(test);  
title('test'); 
hold on;
plot(jMax,iMax,'c*');% 绘制最大相关点  
% 用矩形框标记出匹配区域  
plot([jMax,jMax+n0-1],[iMax,iMax],'y-');  
plot([jMax+n0-1,jMax+n0-1],[iMax,iMax+m0-1],'g-');  
plot([jMax,jMax+n0-1],[iMax+m0-1,iMax+m0-1]),'b-';  
plot([jMax,jMax],[iMax,iMax+m0-1],'r-');