function pic = cut_pic_black(pic)

[xsize,ysize] = size(pic);
minx = 0;
maxx = 0;
miny = 0;
maxy = 0;
delta = 10;

% 寻找左边最小的边界
for i = 1:size(pic,1)
    if( sum(pic(i,:))~=0 )
        minx = i;
        break
    end
end
minx = max(1,minx-delta);

%寻找右边边最小的边界
for i = size(pic,1):-1:1
    if( sum(pic(i,:))~=0 )
        maxx = i;
        break
    end
end
maxx = min(xsize,maxx+delta);

%寻找底部最小边界
for i = 1:size(pic,2)
    if( sum(pic(:,i))~=0 )
        miny = i;
        break
    end
end
miny = max(1, miny-delta);

% 寻找顶部最小边界
for i = size(pic,2):-1:1
    if( sum(pic(:,i))~=0 )
        maxy = i;
        break
    end
end
maxy = min(ysize, maxy+delta);

pic = pic(minx:maxx, miny:maxy);


