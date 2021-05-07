function [iteration_SOBI,F,U,S]=sobi_MUL(X,m,p)
%
% SOBI fr�uentiel, SOBI modifi�par J.-M. et D. Nuzillard 
%
% [F,U,S]=SOBI2(X,m,p) produces a matrix F of dimension [n,m] and a matrix S
% of dimension [m,T] which are respectively an estimate of the mixture matrix and
% an estimate of the source signals of the linear model from where the 
% observation matrix X of dimension [n,T] derive.
% U [m,n] is an estimate of the separating matrix : U * X = S
% Note: > n: sensor number.
%       > m: source number by default m=n.
%       > T: sample number.
%	> p: number of correlation matrices to be diagonalized by default p=4.
%
% Adapted from:
%
% A. Belouchrani, K. Abed-Meraim, J.F. Cardoso and E. Moulines:
%      "A blind source separation technique using second order statistics",
%      IEEE Trans. on Signal Processing, vol. 45, no. 2,  pp. 434-444, Feb. 1997. 
%

[n,T]=size(X);
if nargin==2,
 p=4 ; % number of correlation matrices to be diagonalized
end; 
pm=p*m; % for convenience

%%% whitening

Rx = (X * X')/T/T ;
if m<n, %assumes white noise
  [U,D]=eig(Rx); [puiss,k]=sort(diag(D));
  ibl= sqrt(puiss(n-m+1:n)-mean(puiss(1:n-m)));
   bl = ones(m,1) ./ ibl ;
   BL=diag(bl)*U(1:n,k(n-m+1:n))';
  IBL=U(1:n,k(n-m+1:n))*diag(ibl);
else    %assumes no noise
   IBL=sqrtm(Rx);
   BL=inv(IBL);
end;

X=BL*X/T;


% W=hadamard(T);
% table = cos(2*pi*(0:(T-1))/T) ;
% table = exp(2*i*pi*(0:(T-1))/T) ;

Xn=X;
A=[];
for k=1:p
    Rz=X*Xn';
    Xn=[Xn(:,size(Xn,2)),Xn(:,1:size(Xn,2)-1)];
    A=[A,Rz];
end


%%%joint diagonalization
seuil=1/sqrt(T)/100; encore=1; V=eye(m);
iteration_SOBI = 0;
while encore, encore=0; 
    iteration_SOBI = iteration_SOBI+1;
 for p=1:m-1,
  for q=p+1:m,
   %%% Givens rotations
   g=[   A(p,p:m:pm)-A(q,q:m:pm)  ;
         A(p,q:m:pm)+A(q,p:m:pm)  ;
      i*(A(q,p:m:pm)-A(p,q:m:pm)) ];
	  [vcp,D] = eig(real(g*g')); [la,K]=sort(diag(D));
   angles=vcp(:,K(3));angles=sign(angles(1))*angles;
   c=sqrt(0.5+angles(1)/2);
   sr=0.5*(angles(2)-j*angles(3))/c; sc=conj(sr);
   oui = abs(sr)>seuil ;
     encore=encore | oui ;
   if oui , %%%update of the A and V matrices 
    colp=A(:,p:m:pm);colq=A(:,q:m:pm);
    A(:,p:m:pm)=c*colp+sr*colq;A(:,q:m:pm)=c*colq-sc*colp;
    rowp=A(p,:);rowq=A(q,:);
    A(p,:)=c*rowp+sc*rowq;A(q,:)=c*rowq-sr*rowp;
    temp=V(:,p);
    V(:,p)=c*V(:,p)+sr*V(:,q);V(:,q)=c*V(:,q)-sc*temp;
    
   end%% if
  end%% q loop
 end%% p loop
end%% while


%%%estimation of the mixing matrix and signal separation
F=IBL*V*T ; U=inv(V)*BL/T; S=V'*X;

neg = find(sum(S')<0) ;
S(neg,:) = -S(neg,:) ;
F(:,neg) = -F(:,neg) ;
U(neg,:) = -U(neg,:) ;
end

