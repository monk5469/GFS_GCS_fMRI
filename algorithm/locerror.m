function locerror(icasig)
            X=icasig;
            
            load('D:\simtb_data_hcnr\aod_subject_001_SIM');             %Expect data

            load('mask_ind');                    %mask
%%Expected data is processed by mask
            SM1=zeros(size(SM,1),size(mask_ind,1));
            for i=1:size(SM,1)
                for j=1:size(mask_ind,1)
                    SM1(i,j)=SM(i,mask_ind(j,1));
                end
            end
%%Experimental data preprocessing
     %If the active region is negative, reverse all values in the row
            X1=zeros(size(X));
            for i=1:size(X,1)
                if abs(min(X(i,:)))>abs(max(X(i,:)))
                    for j=1:size(X,2)
                        X1(i,j)=-X(i,j);
                    end
                else 
                    for j=1:size(X,2)
                        X1(i,j)=X(i,j);
                    end
                end
            end
        %The normalized
            X2=zeros(size(X1));
             for i=1:size(X1,1)
                for j=1:size(X1,2)
                    X2(i,j)=(X1(i,j)-min(X1(i,:)))/(max(X1(i,:))-min(X1(i,:)));
                end
             end  
        %Remove the mean
            X3=zeros(size(X2));
            for i=1:size(X2,1) 
                X3(i,:)=X2(i,:)-mean(X2(i,:));
            end
%             X3=X2;
%Remove the mean of expect data
            SM2=zeros(size(SM1));
            for i=1:size(SM1,1) 
                SM2(i,:)=SM1(i,:)-mean(SM1(i,:));
            end
%定位误差计算
            M=zeros(size(X3,1),size(X3,1));
            for i=1:size(X3,1)
                for j=1:size(X3,2)
                    for k=1:size(X3,1)                  %计算期望数据第i个成分和每个实验数据成分的定位误差
                       M(i,k)=M(i,k)+abs(X3(k,j)-SM2(i,j));
                    end
                end
            end      
            %Calculate the error, and reorder the experimental data according to the calculation results, so that each component corresponds to the expected data one to one
            [K1,indx]=sort(M,2,'ascend');
            n=ones(1,size(indx,1));
            while 1
                s=0;
                for i=1:size(indx,1)-1
                        for j=i+1:size(indx,1)
                            if indx(i,1)==indx(j,1)
                                if K1(i,1)<K1(j,1)
                                    n(j)=n(j)+1;
                                    x=K1(j,n(j));
                                    K1(j,n(j))=K1(j,1);
                                    K1(j,1)=x;
                                    x=indx(j,n(j));
                                    indx(j,n(j))=indx(j,1);
                                    indx(j,1)=x;
                                else
                                    n(i)=n(i)+1;
                                    x=K1(i,n(i));
                                    K1(i,n(i))=K1(i,1);
                                    K1(i,1)=x;
                                    x=indx(i,n(i));
                                    indx(i,n(i))=indx(i,1);
                                    indx(i,1)=x;
                                end
                                s=s+1;
                            end
                        end
                end
                if s==0
                    break;
                end
            end
            X4=[];
            for i=1:size(X3,1)
               X4=[X4;X3(indx(i,1),:)];
            end

            %Experimental data back mask
            X5=SM;
            for i=1:size(X5,1)
                for j=1:size(mask_ind,1)
                    X5(i,mask_ind(j,1))=X4(i,j);
                end
            end  
            %%Set the threshold
            X6=zeros(size(X5,1),size(X5,2));
            for i=1:size(X5,1)
                y=0.05;
%                 if i==3||i==4
%                     y=0.4;
%                 end
                for j=1:size(X5,2)
                    if X5(i,j)>y
                       X6(i,j)=X5(i,j); 
                    end
                    if SM(i,j)<y
                           SM(i,j)=0; 
                    end
                end
            end
            %Experimental data normalization
            for i=1:size(X6,1)
                    X6(i,:)=(X6(i,:)-min(X6(i,:)))/(max(X6(i,:))-min(X6(i,:)));
            end
            %%
            %Calculate absolute error
            localerror=zeros(1,size(SM,1));
            for i=1:size(SM,1)
                for j=1:size(SM,2)
                    localerror(1,i)=localerror(1,i)+abs(X6(i,j)-SM(i,j));
                end
            end
            %Calculation of relative error
            relaerror=zeros(1,size(SM,1));
            for j=1:size(SM,1)
                relaerror(1,j)=localerror(1,j)/abs(sum(SM(j,:)));
            end

            %The mean of the relative error
            relaerror2=mean(relaerror,2);
            disp(['The mean of the relative error is ' num2str(relaerror2)]);
            
            figure(1);
            plot(localerror,'-bd','LineWidth',1);
            xlabel('Brain area');
            ylabel('Absolute error');
            
            figure(2);
            plot(relaerror,'-bd','LineWidth',1);
            xlabel('Brain area');
            ylabel('Relative error');

            simtb_showSM([SM;X6]);
end