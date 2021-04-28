function plots(nu, m)

for k=1:4,
   subplot(2,2,k)
   plot(nu, m(k,:), 'LineWidth', 1)
end
