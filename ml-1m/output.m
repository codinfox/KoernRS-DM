fid = fopen('rat_train.txt','wt');
for i = 1 : size(rat_train,1)
    fprintf(fid,'%d::%d::%d::%d\n',rat_train(i,1),rat_train(i,2),rat_train(i,3),rat_train(i,4));
end
fclose(fid);

fid = fopen('rat_test.txt','wt');
for i = 1 : size(rat_test,1)
    fprintf(fid,'%d::%d::%d::%d\n',rat_test(i,1),rat_test(i,2),rat_test(i,3),rat_test(i,4));
end
fclose(fid);