Aij = zeros(3952,3952);
i = 1;
while i <= 3952
    j = i
    while j <= 3952
        mask = um(i,:)~=0;
        mask_2 = um(j,:)~=0;
        mask = mask .* mask_2;
        user = find(mask>0);
        for n=1:size(user,2)
            Aij(i,j) = Aij(i,j) + um(i,user(n))*um(j,user(n));
        end
%         Aij(i,j) = Aij(i,j)/nij(i,j);
        Aij(j,i) = Aij(i,j);
        j = j+1;
    end
    i = i+1;
end