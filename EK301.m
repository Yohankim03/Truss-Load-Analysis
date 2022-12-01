load('TrussDesign1_AC_A4.mat','C','Sx','Sy','X','Y','L')

[j, m] = size(C);

A = zeros(2 * j, m);
mem_len = zeros(1,2*length(X)-3);

temp = zeros(2);
counter = 1;

% x segment
for i = 1:m
    for k = 1:j
        if (C(k,i) == 1)
            temp(counter) = k;
            counter = counter + 1;
        end
    end
    mem_len(i) = sqrt(power(X(temp(2)) - X(temp(1)),2) + power(Y(temp(2)) - Y(temp(1)),2));
    calc = (X(temp(2)) - X(temp(1)))/mem_len(i);
    calc2 = -1*calc;

    A(temp(1),i) = calc;
    A(temp(2),i) = calc2;
    counter = 1;
end


% y segment
for i = 1:m
    for k = 1:j
        if (C(k,i) == 1)
            temp(counter) = k;
            counter = counter + 1;
        end
    end
    calc = (Y(temp(2)) - Y(temp(1)))/sqrt(power(X(temp(2)) - X(temp(1)),2) + power(Y(temp(2)) - Y(temp(1)),2));

    calc2 = -1 * calc;
A(temp(1) + j,i) = calc;
    A(temp(2) + j,i) = calc2;
    counter = 1;
end
% inserting final columns
S = [Sx; Sy];
final = [A S];

% compute all forces
T = final^-1 * L;

disp("% EK301, Section A4, Group Apple Connoisseurs: Cristian P., Yohan K., Ryan L. 11/11/2022")

for i=1:length(L)
    if(abs(L(i)) > 0)
        val = abs(L(i));
    end
end

fprintf("Load: %.2f \n", val)
disp("Member forces in oz")

for i=1:length(T) - 3
    if(T(i) > 0)
        fprintf("m%i: %.3f (T)\n",i, abs(T(i)))
    elseif(T(i) < 0)
        fprintf("m%i: %.3f (C)\n",i, abs(T(i)))
    else
        fprintf("m%i: %.3f\n",i, T(i))
    end
end

% show reaction forces
disp("Reaction forces in oz:")
fprintf("Sx1: %.2f\n",T(length(T) - 2))
fprintf("Sy1: %.2f\n",T(length(T) - 1))
fprintf("Sy2: %.2f\n",T(length(T)))

% 10 * num of joints + total length of all members
% cost calculation 
cost = 10 * j;

for i=1:length(mem_len)
    cost = cost + mem_len(i);
end

% compute maximum load
maximumLoads = zeros(1,m);
Rms = zeros(1,m);
pCrits = zeros(1,m);
uPcrits = zeros(1,m);
for i=1:length(maximumLoads)
    if (T(i) ~= 0)
        Rms(i) = (T(i)/val);
        pCrits(i) = 2945/(mem_len(i)^2);
        uPcrits(i) = 54/mem_len(i);
        maximumLoads(i) = (-pCrits(i))/Rms(i);
    else 
        maximumLoads(i) = 0;
    end
end

pot_mem_buckle = zeros(1,m);

buckle=abs(maximumLoads(1));
counter = 1;
for i=1:length(maximumLoads)
    if maximumLoads(i)>0
        if maximumLoads(i)<buckle
            buckle = maximumLoads(i);
            pot_mem_buckle(counter) = i;
            counter = counter + 1;
        end
    end
end
loadToCost = buckle/cost;

fprintf("Cost of truss: $%.2f \n", cost)
fprintf("Theoretical max load/cost ratio in oz/$: %.4f \n", loadToCost)