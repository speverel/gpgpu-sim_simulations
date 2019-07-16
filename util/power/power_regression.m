input = csvread('combined_powers.csv');
A = input(:,1:30); % change 30 to number of power counters if different
b = input(:,31);
l = 0.01*ones(1,30); % lower bounds
u = 10*ones(1,30); % upper bounds
u(25:28) = 100; % off chip upper bounds
result = quadprog(2*A'*A, -2*A'*b, [], [], [], [], l, u);
csvwrite('scaled_coefficients.csv', result);