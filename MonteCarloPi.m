%% Calculate pi using random numbers
max = 1000000;
zufall = rand(2,max);
im_kreis = @(x,y) x^2 + y^2 < 1;
ergebnisse = arrayfun(im_kreis, zufall(1,:), zufall(2,:));
kreiszahl = sum( ergebnisse ) / max * 4