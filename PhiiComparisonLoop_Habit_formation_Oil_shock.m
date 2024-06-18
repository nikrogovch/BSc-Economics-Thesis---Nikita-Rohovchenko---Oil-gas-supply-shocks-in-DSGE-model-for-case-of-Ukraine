

% Clear workspace
clear all;
clc;

% Dynare options and setup workspace
approxorder     = 1;        % Set Approximation Order
irfperiod       = 20;       % Set Impulse Response Function Periods
simperiod       = 20000;    % Set Simulation Periods
replicnumber    = 10;       % Set Number of Replications
simreplicnumber = 10;       % Set Number of Simulation Replications
dropnumber      = 1000;     % Set Number of Simulation Periods dropped



%% ------------------------------------------------------------------------
% Impulse Response Analysis - Robustness Analysis with Phi_C Comparison (FOR loops)
% -------------------------------------------------------------------------

%% Set parameters
% Calibrated to Ukrainian economy
% I run a loop on basic calibration of Ukrainian economy 
% (this includes the Taylor rule coefficients with mild inflation targeting)

par.betta   = 0.933; 
par.beta_r  = 0.1082;
par.beta_e  = 0.2059;
par.alp_r   = 1/3;
par.alp_e   = 0.6341;
par.alp_C   = 0.57;
par.Oil     = 0.001;
par.phi     = 0.3;
par.phiC    = 0.7;
par.gam     = 1.1;
par.delt    = 0.1;
par.rho_r   = 0.5;
par.rho_e   = 0.83;
par.rho_C   = 0.15;
par.kap_r   = 26.8116;
par.kap_e   = 26.8116;
par.pibar   = 0.05;
par.tetQ    = 0;
par.tetPi   = 1.5;
par.tetY    = 0;
par.stdZ    = 0.01;
par.stdM    = 0.001;
par.stdO    = 0.04; 
par.rhoZ    = 0.91;
par.rhoM    = 0.5;
par.rhoO    = 0.983; 
 


tic;



original_phiC = 0.7; % Define the original value of PhiC

%% Define values of Phi_C for comparison for comparison to use it later in loop
phiC_values = [0.1, 0.4, 0.7];

% For each value of PhiC I run a loop. 
for phi_idx = 1:length(phiC_values)
    phi_val = phiC_values(phi_idx);
    par.phiC = phi_val; % Set PhiC parameter

    % Call Dynare to initialize model
    eval(['dynare Oil_shock_two_sector_model.mod -Dreplic_number=' num2str(replicnumber) ...
        ' -Dsimul_replic_number=' num2str(simreplicnumber) ' -Ddrop_number=' num2str(dropnumber) ...
        ' -Dapprox_order=' num2str(approxorder) ' -Dirf_periods=' num2str(irfperiod) ...
        ' -Dsim_periods=' num2str(simperiod) ' noclearall;']);

    % Calculate Steady States
    for ii = 1:length(oo_.dr.ys)
        eval(['stst.' strjoin(cellstr(M_.endo_names(ii))) ' = oo_.dr.ys(' num2str(ii) ');']);
    end

    % Productivity shock (calculate either deviations from steady state values or 
    % for inflation rates calculate the change in inflation)
    irf_eZ.output_regular(:, phi_idx) = Y_r_eZ./stst.Y_r;
    irf_eZ.output_energy(:, phi_idx) = Y_e_eZ./stst.Y_e;
    irf_eZ.CPI(:, phi_idx) = pii_eZ;
    irf_eZ.inflation_regular(:, phi_idx) = pii_r_eZ;
    irf_eZ.inflation_energy(:, phi_idx) = pii_e_eZ;
    irf_eZ.hours(:, phi_idx) = L_eZ./stst.L;
    irf_eZ.capital(:, phi_idx) = K_eZ./stst.K;
    irf_eZ.consumption_regular(:, phi_idx) = C_r_eZ./stst.C_r;
    irf_eZ.consumption_energy(:, phi_idx) = C_e_eZ./stst.C_e;
    irf_eZ.bond_price(:, phi_idx) = q_eZ./stst.q;
    irf_eZ.marginal_cost_regular(:, phi_idx) = mc_r_eZ./stst.mc_r;
    irf_eZ.wage_regular(:,phi_idx) = w_eZ./stst.w;
    irf_eZ.labor_regular(:,phi_idx) = L_r_eZ./stst.L_r;
    irf_eZ.labor_energy(:,phi_idx) = L_e_eZ./stst.L_e;
    irf_eZ.capital_regular(:,phi_idx) = K_r_eZ./stst.K_r;
    irf_eZ.capital_energy(:,phi_idx) = K_e_eZ./stst.K_e;

    % Monetary shock (calculate either deviations from steady state values or 
    % for inflation rates calculate the change in inflation)
    irf_eM.output_regular(:, phi_idx) = Y_r_eM./stst.Y_r;
    irf_eM.output_energy(:, phi_idx) = Y_e_eM./stst.Y_e;
    irf_eM.CPI(:, phi_idx) = pii_eM;
    irf_eM.inflation_regular(:, phi_idx) = pii_r_eM;
    irf_eM.inflation_energy(:, phi_idx) = pii_e_eM;
    irf_eM.hours(:, phi_idx) = L_eM./stst.L;
    irf_eM.capital(:, phi_idx) = K_eM./stst.K;
    irf_eM.consumption_regular(:, phi_idx) = C_r_eM./stst.C_r;
    irf_eM.consumption_energy(:, phi_idx) = C_e_eM./stst.C_e;
    irf_eM.bond_price(:, phi_idx) = q_eM./stst.q;
    irf_eM.marginal_cost_regular(:, phi_idx) = mc_r_eM./stst.mc_r;
    irf_eM.wage_regular(:,phi_idx) = w_eM./stst.w;
    irf_eM.labor_regular(:,phi_idx) = L_r_eM./stst.L_r;
    irf_eM.labor_energy(:,phi_idx) = L_e_eM./stst.L_e;
    irf_eM.capital_regular(:,phi_idx) = K_r_eM./stst.K_r;
    irf_eM.capital_energy(:,phi_idx) = K_e_eM./stst.K_e;


    % Oil supply shock (calculate either deviations from steady state values or 
    % for inflation rates calculate the change in inflation)
    irf_eO.output_regular(:, phi_idx) = Y_r_eO./stst.Y_r;
    irf_eO.output_energy(:, phi_idx) = Y_e_eO./stst.Y_e;
    irf_eO.CPI(:, phi_idx) = pii_eO;
    irf_eO.inflation_regular(:, phi_idx) = pii_r_eO;
    irf_eO.inflation_energy(:, phi_idx) = pii_e_eO;
    irf_eO.hours(:, phi_idx) = L_eO./stst.L;
    irf_eO.capital(:, phi_idx) = K_eO./stst.K;
    irf_eO.consumption_regular(:, phi_idx) = C_r_eO./stst.C_r;
    irf_eO.consumption_energy(:, phi_idx) = C_e_eO./stst.C_e;
    irf_eO.bond_price(:, phi_idx) = q_eO./stst.q;
    irf_eO.marginal_cost_regular(:, phi_idx) = mc_r_eO./stst.mc_r;
    irf_eO.wage_regular(:,phi_idx) = w_eO./stst.w;
    irf_eO.labor_regular(:,phi_idx) = L_r_eO./stst.L_r;
    irf_eO.labor_energy(:,phi_idx) = L_e_eO./stst.L_e;
    irf_eO.capital_regular(:,phi_idx) = K_r_eO./stst.K_r;
    irf_eO.capital_energy(:,phi_idx) = K_e_eO./stst.K_e;
end

% Define shocks and variables
shocks = {'eZ', 'eM', 'eO'}; 
variables = {'output_regular', 'output_energy', 'CPI','inflation_regular', 'inflation_energy','hours', 'capital', 'consumption_regular', 'consumption_energy', 'bond_price', 'marginal_cost_regular', 'wage_regular', 'labor_regular', 'labor_energy', 'capital_regular', 'capital_energy'}; 
variable_titles = {'Output regular', 'Output energy', 'Inflation Aggregate', 'Inflation regular', 'Inflation energy', 'Total Hours', 'Capital Stock', 'Regular consumption', 'Energy consumption', 'Bond Price', 'Real MC in regular sector', 'Real Wage','Labor in Regular Sector', 'Labor in Energy Sector', 'Capital in Regular Sector', 'Capital in Energy Sector'}; % Define human-readable variable titles for plotting

% Plotting and comparing IRFs for each shock seperately
for shock_idx = 1:length(shocks)
    shock_name = shocks{shock_idx};

   
    figure;
    tiledlayout(4, 4); 
    sgtitle(['']);
    

    for var_idx = 1:length(variables)
        var_name = variables{var_idx};

       
        nexttile;
        hold on;
        title(variable_titles{var_idx}); 

        % Plot IRFs for all PhiC values
        for phi_idx = 1:length(phiC_values)
            phi_val = phiC_values(phi_idx);
            label = ['Phi_C=' num2str(phi_val)];
            plot(eval(['irf_' shock_name '.' var_name '(:, ' num2str(phi_idx) ')']) .* 100, 'LineWidth', 2.5, 'DisplayName', label);
        end

        xlabel('Periods');
        ylabel('%-Dev. St.St.');
        axis tight;
        yline(0,'r');
        hold off;
    end
leg = legend('0.1','0.5','0.7', 'Orientation', 'horizontal');
leg.Layout.Tile = 'north';
title(leg, '${\emptyset}_C$ parameter values:', 'Interpreter', 'latex','FontSize', 12);  
end



toc;