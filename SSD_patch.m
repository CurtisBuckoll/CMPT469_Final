function cost = SSD_patch(imA, imB, x1, y1, x2, y2, patch_size)
    half_sz = floor( patch_size / 2);
    
    [imAh, imAw] = size(imA);
    [imBh, imBw] = size(imB);
    
    if (round(y1)-half_sz < 1 || round(y1)+half_sz > imAh || round(x1)-half_sz < 1 ||  round(x1)+half_sz > imAw )
        cost = 999999999999;
        return;
    end
    
    if (round(y2)-half_sz < 1 || round(y2)+half_sz > imBh || round(x2)-half_sz < 1 ||  round(x2)+half_sz > imBw )
        cost = 999999999999;
        return;
    end
    
    patch1 = imA(round(y1)-half_sz : round(y1)+half_sz, round(x1)-half_sz : round(x1)+half_sz);
    patch2 = imB(round(y2)-half_sz : round(y2)+half_sz, round(x2)-half_sz : round(x2)+half_sz);
    
    %imshow(patch1);
    
    %imshow(patch2);
    
    diff = patch2 - patch1;
    
    cost = sum(sum(sum((diff).^2)));
    
    %keyboard;
end