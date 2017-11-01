%% Box-Muller vs Envelope-Rejection
n = 10000000;
uniform = rand(2,n/2);

%% Generate Box-Muller-distributed numbers
box_muller = [
  sqrt(-2 .* log( uniform(1,:) )) .* cos(2*pi .* uniform(2,:)) ...
  sqrt(-2 .* log( uniform(1,:) )) .* sin(2*pi .* uniform(2,:))
];

%% Generate Envelope-Rejection-distributed numbers
half_er = @(r) r(1, r(2,:) > (r(1,:)-1).^2/2);

exp_dist = -log(uniform);
envelope_rejection = [-half_er(exp_dist) half_er(exp_dist)];

exp_dist = -[log(uniform) log(uniform([2,1],:))]; %use twice
envelope_rejection_double = [-half_er(exp_dist) half_er(exp_dist)];

%% Evaluate
my_cdf = @(x, randoms) sum(randoms' < x) / size(randoms,2);
evalset = (0 : 0.05 : 2);

reference = cdf('Normal', evalset, 0, 1);
fehler = @(result) sum(abs(result - reference));

result_bm = fehler( my_cdf(evalset, box_muller) )
result_bmd = fehler( my_cdf(evalset, [box_muller -box_muller]) )
result_er = fehler( my_cdf(evalset, envelope_rejection) )
result_erd = fehler( my_cdf(evalset, envelope_rejection_double) )

% The d-versions (doubled by reusing random numbers) evaluate more precise
% but are more expensive. This can be easily improved exploiting symmetry.
% Evaluation is most expensive. Sorting can speed up evaluation even more.
% Then a much larger evaluation set could be used.