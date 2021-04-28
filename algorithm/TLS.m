
function Ew_vec=TLS(IND,RT)  

% N=size(X,1); % numbers of mixed signals
% NumComp=BBS.NumComp; % the number of componets
% algorithm =BBS.algorithm;
% 
% if BBS.whitenFlag==1
% %%%1.Preprocessing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 
% %%%%%%%%%%%%1.1 Remove average value %%%%%%%%%%%%%%%%% 
%   [M,T]=size(X);     
%   average=mean(X')';   
%   for i=1:M  
%     X(i,:)=X(i,:)-average(i)*ones(1,T);  
%   end
% 
% %%%%%%%%%%%%1.2 whiten %%%%%%%%%%%%%%%%%
%   Cx=cov(X',1);  % Covaraince  
%   [eigvector,eigvalue]=eig(Cx);    
% %%%%%%%%%% 1.2.1 Whiten Matrix for Reduce dimension %%%%%%%%%
%   IndexTmp=N-NumComp+1:N;
%   Diag_tmp=eigvalue(IndexTmp,IndexTmp)^(-0.5); 
%   W=Diag_tmp*eigvector(:,N-NumComp+1:N)';
% %%%%%%%%%% 1.2.2 Multipiled by whiten matrix %%%%%%%%%
%   Z=W*X; 
%   
% elseif BBS.whitenFlag==0
%     
%   Z=X;
%   
% end
% 
% 
%   switch algorithm 
%     case 'basic'
%         % %%%%%%% basic %%%%%%%%%%%%
%         ind=BBS.basic.ind;
%         M=NumComp;
%         Atmp=zeros(M,M*ind);
%         for imat=1:ind
%              cols		= 1+(imat-1)*M:imat*M;
%              Rz=(Z(:,1:end-imat)*Z(:,1+imat:end)')/(size(Z,2)-imat);
%              Atmp(:,cols)	= Rz;
%         end;
% %       Rz=(Z(:,1:end-ind)*Z(:,1+ind:end)')/(size(Z,2)-ind);
% %       [Rz_eigvector,Rz_eigvalue]=eig(Rz);
%         seuil =1.0e-10;
%         [Rz_eigvector,Rz_eigvalue] = joint_diag_r(Atmp,seuil);
%         U=Rz_eigvector;
% %         ITest=U'*W*A;
% %         SEst=pinv(AEst)*X;
%         SEst=U'*Z;
%     case 'geig'
%         % %%%%%%%%%%%%%%%% gen eig %%%%%%%%%%%
%         ind1=BBS.geig.ind1;
%         ind2=BBS.geig.ind2;
%         R1=(Z(:,1:end-ind1)*Z(:,1+ind1:end)')/(size(Z,2)-ind1);
%         R2=(Z(:,1:end-ind2)*Z(:,1+ind2:end)')/(size(Z,2)-ind2);
%         [R_eigvector,R_eigvalue]=eig(R1,R2,'qz');
%         % whether1=R1*R_eigvector;
%         % whether2=R2*R_eigvector*R_eigvalue;
%         % U=R_eigvector(:,2:3);
%         U=R_eigvector;
%         % AEst=inv(W)*U;
%         ITest=U'*W*A;
%         SEst=U'*Z;
%         
%     case 'tls'
     %%%%%%%%%%%%%%%% 2. TLS for Genral Eig %%%%%%%%%%%%%%%%%%
     %%%%%%%%%%%%%%%% 2.1 Find Ex and Ey %%%%%%%%%%%%%%%%%%
%      IND=BBS.IND; % the maximum time delay 
%         RT=[];
%         for ind=1:IND
%            R=(Z(:,1:end-ind)*Z(:,1+ind:end)')/(size(Z,2)-ind);
%            RT=[RT;R];
%         end
        Rzz=RT*RT';
        [Rzz_vec Rzz_val]=eig(Rzz);
        NumComp=size(RT,2);
        NRzz=IND*NumComp;
       ET=[];
       % Ex=R1*C, where C is a diag matrix
       % Or Ex=R2*B*C, where B and C are both diag matrixs
       for ind=1:IND
          lin=(ind-1)*NumComp+1:ind*NumComp;
          col=NRzz-NumComp+1:NRzz;
          Ex=Rzz_vec(lin,col);
          ET=[ET;Ex];
       end

       %%%%%%%%%%%%%%%% 2.2 Establish Exy %%%%%%%%%%%%%%%%%%

       Exy=ET*ET';
       [E_vec E_val]=eig(Exy);

       %%%%%%%%%%%%%%%% 2.3 Substituting TLS equation %%%%%%%%%%%%%%%%%%
       Ew=0;
       Atmp=zeros(NumComp,NumComp*(IND-1));
       for ind=1:IND
          lin=(ind-1)*NumComp+1:ind*NumComp;
          col=1:NRzz-NumComp;
          if ind==1
              w1=Rzz_vec(lin,col);
          else
              w=Rzz_vec(lin,col);
              indd=ind-1;
              cols=(indd-1)*NumComp+1:indd*NumComp;
              Atmp(:,cols)	= -w*pinv(w1);
          end
       end
       seuil =1.0e-5;
       [Ew_vec Ew_val]=joint_diag_r(Atmp);
       % ITest=Ew_vec'*W*A;
%        SEst=Ew_vec'*Z;
  end
  







