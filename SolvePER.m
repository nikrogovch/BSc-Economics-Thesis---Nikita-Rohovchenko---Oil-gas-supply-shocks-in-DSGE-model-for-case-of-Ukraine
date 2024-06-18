function F = SolvePER(vars, alp_C, rho_C, rho_e, betta, alp_r,  beta_e, beta_r, alp_e, mc_r, delt, Oil, gam, phiC, phi)
% Equations are solved for zero (F(1) and F(2))

% I note that this file is used in fsolve function in file
% "Oil_shock_two_sector_model_steadystate" to solve system of non-linear
% equations and solve remaining part of steady state.

% Define endogenous variables that we want to solve for
L           = vars(1);

P_ER        = vars(2);


% Set of equations below is based on the order presented in Appendix A.5 (second last paragraph)
% Each equation depends on the variables defined before it. 

mc_e        = rho_e*P_ER;

YeK_e       = (1 / betta - 1 + delt) / (alp_e * mc_e);

KY_r        = (     (alp_r / alp_e * mc_r / mc_e) + 1 / (((1 - alp_C) / (alp_C * P_ER)) ^ (1 / (rho_C - 1)))      )      / ( (1 / betta - 1 + delt) / (alp_e * mc_e) +  delt / (((1 - alp_C) / (alp_C * P_ER)) ^ (1 / (rho_C - 1))));

YeYr        = KY_r * (1 / betta - 1 + delt) / (alp_e * mc_e) - (alp_r * mc_r) / (alp_e * mc_e);

L_e         = ( (1-alp_e-beta_e) * (1 - alp_C) * (1 - betta * phiC) * mc_e   )                / (  phi * (L ^ gam) * P_ER * (1 - phiC) * (alp_C * ((1 - alp_C) / (alp_C * P_ER)) ^ (rho_C / (rho_C - 1))  + (1 - alp_C)) );

L_r         = (   (1-alp_r-beta_r) * alp_C * (1 - betta * phiC) * mc_r    )                / (  phi * (L ^ gam) * (1 - delt * KY_r) * (1 - phiC) * ((1 - alp_C) / (alp_C * P_ER)) ^ (rho_C / (1 - rho_C)) * (alp_C * ((1 - alp_C) / (alp_C * P_ER)) ^ (rho_C / (rho_C - 1))  + (1 - alp_C))    );

O_e         = Oil / (1 + (beta_r / beta_e) * (mc_r / mc_e) / YeYr);
O_r         = Oil / (1 + (beta_e / beta_r) * (mc_e / mc_r) * YeYr);

K_r         = ( (((alp_r * mc_r) / (alp_e * mc_e)) / YeK_e) * L_r^(1-alp_r-beta_r) * O_r^beta_r ) ^ ( 1 / (1 - alp_r) );

K_e         = YeYr * ((alp_e * mc_e) / (alp_r * mc_r)) * K_r;


% Once all the variables are defined, I use equations A.5.20 and A.5.45
% from Appendix A.5 to solve for total labor (L) and for relative price
% P_{ER}.

F(1)    = L - L_e - L_r;

F(2)    = ((L_r^(1-alp_r-beta_r))*(K_r^alp_r)*(O_r^beta_r)) / ((L_e^(1-alp_e-beta_e))*(K_e^alp_e)*(O_e^beta_e)) - (((1 - alp_C) / (alp_C * P_ER)) ^ (1 / (rho_C - 1)) + (delt * alp_e * mc_e)/(1 / betta - 1 + delt) )/ (1 - (delt * alp_r * mc_r)/(1 / betta - 1 + delt));


end 