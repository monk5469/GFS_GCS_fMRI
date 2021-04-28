function MULtimes(data,ICA_Options)
for n = 1:100  %100 trials
[iteration_ICA(n),W, sphere, icasig_tmp] = icatb_runica_MUL(data, ICA_Options{1:length(ICA_Options)});
[iteration_fSOBI(n),A, W, icasig_tmp] = fsobi_MUL(data, size(data,1)); 
[iteration_cSOBI(n),A, W, icasig_tmp] = csobi_MUL(data, size(data,1)); 
[iteration_SOBI(n),A, W, icasig_tmp] = sobi_MUL(data, size(data,1)); 
end

figure();
statisticMUL = [3*size(data,2)*mean(iteration_ICA); size(data,2)*(1+mean(iteration_fSOBI)); size(data,2)*(1+mean(iteration_cSOBI)); size(data,2)*(1+mean(iteration_SOBI))];  %the number of multiplications of statistics
tranMUL = [0;  (size(data,2)/2)*log(size(data,2)); (size(data,2)/4)*log(size(data,2)); 0];  %the number of multiplications of transformations

b=bar([statisticMUL tranMUL],0.9);
axis([0.5 4.5 0 4500000]);  
for n =1:4
    text(n-0.4,statisticMUL(n)+100000,num2str(round(statisticMUL(n))));
    text(n+0.05,tranMUL(n)+100000,num2str(round(tranMUL(n))),'color','r');
end
grid on;
ch = get(b,'children');
set(gca,'XTickLabel',{'FastICA','GFS','GCS','SOBI'},'FontSize',14)
set(ch{1},'FaceColor',[1 0 1])
set(ch{2},'FaceColor',[0 0 0])
ylabel('The number of multiplication','FontSize',14);
xlabel('Algorithm','FontSize',14);
legend('Statistics', 'Transform','FontSize',14);
end