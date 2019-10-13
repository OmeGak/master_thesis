%% test random number generation
clc, clear all, close all

N = 5;

rng(10)
random_numbers_a = zeros(1,N);
for n=1:N
    random_numbers_a(n) = rand;
end

rng(10)
random_numbers_b = zeros(1,N);
for n=1:N
    random_numbers_b(n) = test_random_number_generation;
end

display(random_numbers_a)
display(random_numbers_b)


function x = test_random_number_generation
    x = rand;
end