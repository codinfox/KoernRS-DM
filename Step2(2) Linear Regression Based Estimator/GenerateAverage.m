A = Aij ./ nij;
A(isnan(A)) = 0;
A(A==inf) = 0;

avg_diagonal = sum(diag(A))/sum(sum(diag(A)~=0))
A = A - A .* eye(3952);
avg_non_diagonal = sum(A(:))/sum(sum(A~=0))