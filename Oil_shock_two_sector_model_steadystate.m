function [ys,params,check] = oil_shock_two_sector_model_steadystate(ys,exo,M_,options_)

% read out parameters to access them with their name
NumberOfParameters = M_.param_nbr;
for ii = 1:NumberOfParameters
  paramname = M_.param_names{ii};
  eval([ paramname ' = M_.params(' int2str(ii) ');']);
end
% initialize indicator
check = 0;

%% Model equations block - Steady State
% Shock processes
z           = 0; 
m           = 0;
o           = 0;
% Inflation
pii_r       = pibar;
pii_e       = pii_r;
% Bond price
q           = betta / (1+pii_r);




% Marginal cost
mc_r        = rho_r;

% solve for P_ER and L
options = optimoptions('fsolve','MaxFunctionEvaluations', 20000);




function_handle  = @(vars) SolvePER(vars, alp_C, rho_C, rho_e, betta, alp_r,  beta_e, beta_r, alp_e, mc_r, delt, Oil, gam, phiC, phi);

[solution, fval, exitflag, output]     = fsolve(function_handle, [8,10], options);


L                = solution(1);
P_ER             = solution(2);

% Start solving rest of the equations as discussed in Appendix A.5.

mc_e        = rho_e*P_ER;


% Ratios

YrK_r       = (1 / betta - 1 + delt) / (alp_r * mc_r);
YeK_e       = (1 / betta - 1 + delt) / (alp_e * mc_e);


KY_r        = (     (alp_r / alp_e * mc_r / mc_e) + 1 / (((1 - alp_C) / (alp_C * P_ER)) ^ (1 / (rho_C - 1)))      )      / ( (1 / betta - 1 + delt) / (alp_e * mc_e) +  delt / (((1 - alp_C) / (alp_C * P_ER)) ^ (1 / (rho_C - 1))));
YeYr        = KY_r * (1 / betta - 1 + delt) / (alp_e * mc_e) - (alp_r * mc_r) / (alp_e * mc_e);



% Total hours worked
L_e         = ( (1-alp_e-beta_e) * (1 - alp_C) * (1 - betta * phiC) * mc_e   )                / (  phi * (L ^ gam) * P_ER * (1 - phiC) * (alp_C * ((1 - alp_C) / (alp_C * P_ER)) ^ (rho_C / (rho_C - 1))  + (1 - alp_C)) );

L_r         = (   (1-alp_r-beta_r) * alp_C * (1 - betta * phiC) * mc_r    )                / (  phi * (L ^ gam) * (1 - delt * KY_r) * (1 - phiC) * ((1 - alp_C) / (alp_C * P_ER)) ^ (rho_C / (1 - rho_C)) * (alp_C * ((1 - alp_C) / (alp_C * P_ER)) ^ (rho_C / (rho_C - 1))  + (1 - alp_C))    );

% Oil choice
O_e         = Oil / (1 + (beta_r / beta_e) * (mc_r / mc_e) / YeYr);
O_r         = Oil / (1 + (beta_e / beta_r) * (mc_e / mc_r) * YeYr);

% Private capital stock

K_r         = ( (((alp_r * mc_r) / (alp_e * mc_e)) / YeK_e) * L_r^(1-alp_r-beta_r) * O_r^beta_r ) ^ ( 1 / (1 - alp_r) );
K_e         = YeYr * ((alp_e * mc_e) / (alp_r * mc_r)) * K_r;
K           = K_e + K_r;

% Real GDP

Y_r         = (L_r^(1-alp_r-beta_r))*(K_r^alp_r)*(O_r^beta_r);
Y_e         = (L_e^(1-alp_e-beta_e))*(K_e^alp_e)*(O_e^beta_e);

% Private consumption
C_r         = Y_r - (delt)*K;
C_e         = Y_e;
C           = C_r + C_e*P_ER;
C_ER        = C_e*P_ER/C_r;

% Real wage
w           = (1-alp_r-beta_r) * Y_r / L_r * mc_r;
w_e         = (1-alp_e-beta_e) * Y_e / L_e * mc_e;


% Rental price of capital
r           = alp_r * Y_r / K_r * mc_r;
r_e         = alp_e * Y_e / K_e * mc_e;


% Oil real price
or          = beta_r * Y_r / O_r * mc_r; 
or_e        = beta_e * Y_e/ O_e * mc_e; 

share_of_oil_r = or*O_r/Y_r;
share_of_oil_e = or_e*O_e/Y_e;
% Inflation CPI

pii_er = (1+pii_e)/(1+pii_r)-1;

pii = ((1+pii_e)/(1+pii_er) - 1)  * (P_ER*C_e)/C + pii_r *C_r/C;

%% end own model equations

params=NaN(NumberOfParameters,1);
for iter = 1:length(M_.params) %update parameters set in the file
  eval([ 'params(' num2str(iter) ') = ' M_.param_names{iter} ';' ])
end

NumberOfEndogenousVariables = M_.orig_endo_nbr; %auxiliary variables are set automatically
for ii = 1:NumberOfEndogenousVariables
  varname = M_.endo_names{ii};
  eval(['ys(' int2str(ii) ') = ' varname ';']);
end

