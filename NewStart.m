function [ x0 ] = NewStart( xData )
    
    xDatamin = floor(min(xData));
    xDatamax = ceil(max(xData));
    
    D = size(xDatamin,2);
    x0 = zeros(1,D);
    for i=1:D
        x0(i) = xDatamin(i) + (xDatamax(i)-xDatamin(i)).*rand(1,1);
    end
end

