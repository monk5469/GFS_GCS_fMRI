clear all;

close all;

% N=10^9;
% 
% tic;
% for n=1:N
%     x=-1*33666555335;
% end
% toc;
% 
% tic;
% for n=1:N
%     y=8888888452452452358660*33666555335;
% end
% toc;

load data;

load W_hsobi_Simtb_part;
data=data(:,1:size(W_hsobi_Simtb_part,2));
%             tic
            for m=1:1
            [A, W, icasig_tmp] = fsobi(data, size(data,1),W_hsobi_Simtb_part);  
            end
%            toc