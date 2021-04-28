% Demo for f-SOBI.
% The sources are spectra made of are four lorentzian lines
clear all ;
close all;

sw = 4000.0 ; % spectral width
td = 2048 ; % points in the time domain
si = 2*td ; % points in the frequency domain

s = zeros(4,si) ;

A = [1 1 1 1] ;
nu0 = [-1000, -500, 600, 1200] ;
T2 = [0.005 0.008 0.02 0.03] ;

for k=1:4,
    [nu, s(k,:)] = lorentz(sw,td,si,A(k),nu0(k),T2(k)) ;
end

a = [1 2 2 2 ; 2 1 2 2 ; 2 2 1 2 ; 2 2 2 1] ;
x = a * s ;
% WTmp=hadamard(4096);
% W=WTmp(1:5,:);
% cos(2*pi*(0:(T-1))/T) ;

[F, U, z] = csobi(x, 4) ;






figure(1)
plots(nu, s)
figure(2)
plots(nu, x)
figure(3)
plots(nu, z)

