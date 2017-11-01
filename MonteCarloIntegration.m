%% Function for integration over continuous functions
% It spans a rectangle over the function and places randomly dots into it.
% Test: MonteCarloIntegration(@(x) sin(x), 1,4,100000)
% And verify: http://www.wolframalpha.com/input/?i=integrate+sin(x)+from+1+to+4

function integral = MonteCarloIntegration(f, lower_limit, upper_limit, n)

  % Span rectangle over function
  min = f(fminbnd(f, lower_limit, upper_limit));
  max = f(fminbnd(@(x) - f(x), lower_limit, upper_limit));
  
  % Populate random values over rectangle
  width = upper_limit - lower_limit;
  x_values = rand(1,n) * (width) + lower_limit;
  y_values = rand(1,n) * (max-min) + min;
  
  % Count values less than f
  zaehler = sum( arrayfun(@(x,y) y<f(x), x_values, y_values) );
  
  % Calculate Integral
  integral = zaehler / n * (width) * (max - min) ...
    + min * (width);
end