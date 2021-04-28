function TimeComplexity(data,ICA_Options,n)
t=zeros(4,n);
for x=1:n 
    %ICA
    tic;
    [W, sphere, icasig_tmp] = icatb_runica(data, ICA_Options{1:length(ICA_Options)});
    W = W*sphere;
    icasig_tmp = W*data;
    A = pinv(W);
    t(1,x)=toc;
    %FSOBI
    tic;
    [A, W, icasig_tmp] = fsobi(data, size(data,1));   
    icasig_tmp = real(icasig_tmp);            
    W = real(W);            
    A = real(A);
    t(2,x)=toc;
    %CSOBI
    tic;
    [A, W, icasig_tmp] = csobi(data, size(data,1));
    icasig_tmp = real(icasig_tmp);            
    W = real(W);            
    A = real(A);
    t(3,x)=toc;
    %SOBI
    tic;
    [A, W, icasig_tmp] = sobi(data, size(data,1));
    icasig_tmp = real(icasig_tmp);            
    W = real(W);            
    A = real(A);
    t(4,x)=toc;
end

tmean=(mean(t,2));

figure(1);
plot(1:n,t(1,:),'- b s','LineWidth',1);

hold on;
plot(1:n,t(2,:),'- m o','LineWidth',1);

hold on;
plot(1:n,t(3,:),'- y ^','LineWidth',1);

hold on;
plot(1:n,t(4,:),'- r x','LineWidth',1);

xlabel('Number of experiments');
ylabel('Running time');
legend('FastICA','GFS','GCS','SOBI');


figure(2);
bar(tmean);
xlabel('Algorithm');
ylabel('Average running time');
set(gca,'xticklabel',{'FastICA','GFS','GCS','SOBI'});

end