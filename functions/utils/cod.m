function r2 = cod(x,y)

my = mean(y);
r2 = 1 - sum((x-y).^2)/sum((y-my).^2);

end