function x = calcx(A,b)
r = 1;
e = 0.1;
b = b';
x = zeros(size(b));
while sqrt(r'*r) > e
    r = A*x - b
    mask = x == 0
    mask_r = r .* mask
    mask_r = mask_r < 0
    mask_r = 1 - mask_r
    r = r .* mask_r
    return;
    alpha = r'*r/(r'*A*r);
    mask_r_2 = r < 0;
    mask_r_2 = r .* mask_r_2;
    
    tmp = -x ./ mask_r_2;
    tmp(isnan(tmp))=inf;
    
    tmp = min(tmp);
    if (tmp < alpha) 
        alpha = tmp;
    end
    
    x = x + alpha*r;
end