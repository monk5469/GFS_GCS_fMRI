function [nu, sp] = lorentz(sw, td, si, A, nu0, T2)

sp = zeros(1,si) ;

dt = 1.0/sw ;
t = [0:(td-1)]*dt ;
dnu = sw/si ;
nu = [(-si/2):(si/2-1)]*dnu ;
fid = A * exp((2*i*pi*nu0-1/T2)*t) ;
fid(1) = fid(1) / 2 ;
sp(1:td) = fid ;
sp = real(fftshift(fft(sp))) ;
