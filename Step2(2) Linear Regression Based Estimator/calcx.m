function x = calcx(A,b)
r = 1;
e = 0.1;
x = 0.04*ones(size(b)); 
for n=1:25
    r = A*x - b;
    mask = x == 0;
    mask_r = r .* mask;
    mask_r = mask_r < 0;
    mask_r = 1 - mask_r;
    r = r .* mask_r;
    x = x-0.001*r;
end