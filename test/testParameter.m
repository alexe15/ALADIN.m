clear all;
close all;

 run ../examples/booth_example.m   
 assert(full(norm(vertcat(sol_par.xxOpt{:}) -vertcat(sol_normal.xxOpt{:}),inf)) < 1e-6, 'Out of tolerance for local minimizer!')