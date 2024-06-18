% New Keynesian model with differentiated consumption goods and 2 production sectors

% Clear workspace
clear all;
clc;

% Dynare options and setup workspace
approxorder = 1;        % No. Approximation Order
irfperiod = 25;         % No. Impulse Response Function Periods
simperiod = 20000;      % No. Simulation Periods
replicnumber = 10;      % No. Number of Replications
simreplicnumber = 10;   % No.Number of Simulation Replications
dropnumber = 1000;      % No. Number of Simulation Periods dropped

% Looping Parameters
tetPi_values = linspace(1.5, 4.5, 4);
tetY_values = linspace(1.5, 4.5, 4);
fixed_tetPi = 1.5; % Fixed inflation target coefficient
fixed_tetY = 0;  % Fixed output coefficient

% Set parameters - calibrated to Ukrainian economy
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

%% Define shock names and variable names as per Dynare outputs
shock_types = {'Z', 'M', 'O'};
variable_names = {'Y_r', 'Y_e', 'pii', 'pii_r','pii_e', 'L', 'K', 'C_r', 'C_e', 'q', 'mc_r', 'w', 'L_r', 'L_e', 'K_r', 'K_e'}; 
var_titles = {'Output regular', 'Output energy', 'Inflation total','Inflation regular', 'Inflation energy', 'Total Hours', 'Capital Stock', 'Regular consumption', 'Energy consumption', 'Bond Price', 'Real MC in regular sector', 'Real Wage','Labor in Regular Sector', 'Labor in Energy Sector', 'Capital in Regular Sector', 'Capital in Energy Sector'}; % Define human-readable variable titles for plotting

% Container for the IRFs
IRFs = struct();

% Simulations for varying inflation target coefficient
for pi_idx = 1:length(tetPi_values)
    par.tetPi = tetPi_values(pi_idx);
    par.tetY = fixed_tetY; % Keeping output coefficient fixed

    % Call Dynare to initialize model
eval(['dynare Oil_shock_two_sector_model.mod -Dreplic_number=' num2str(replicnumber) ...
	' -Dsimul_replic_number=' num2str(simreplicnumber) ' -Ddrop_number=' num2str(dropnumber) ...
	' -Dapprox_order=' num2str(approxorder) ' -Dirf_periods=' num2str(irfperiod) ...
	' -Dsim_periods=' num2str(simperiod) ' noclearall;']);

    % Retrieving and storing IRFs for each variable and shock
    for var_idx = 1:length(variable_names)
        for shock_idx = 1:length(shock_types)
            shock = shock_types{shock_idx};
            var_name = variable_names{var_idx};
            IRFs.(shock).(var_name)(:, pi_idx) = eval(['oo_.irfs.' var_name '_e' shock]);
        end
    end
end

% Plotting IRFs for varying tetPi
for shock_idx = 1:length(shock_types)
    shock = shock_types{shock_idx};
    figure('Name', ['IRFs for varying tetPi - Shock: ', shock]);
    sgtitle(['IRFs for Varying Inflation Target Coefficient for Contractionary: ' shock]);
   
    % Create a 4x4 grid layout
    t = tiledlayout(4, 4);
    title(t, ['']);

    for var_idx = 1:length(variable_names)
        var_name = variable_names{var_idx};
        nexttile; % Add subplot to the next tile in the grid
        hold on;
        for pi_idx = 1:length(tetPi_values)
            plot(IRFs.(shock).(var_name)(:, pi_idx), 'LineWidth', 2.5);
        end
        hold off;
        title(var_titles{var_idx}, 'Interpreter', 'none'); 
        xlabel('Periods');
        ylabel('%-Dev. St.St.');
        axis tight;
        yline(0, 'r');
    end
    
    lg = legend(arrayfun(@num2str, tetPi_values, 'UniformOutput', false), 'Position', [0.5, 0.01, 0.01, 0.01], 'Orientation', 'horizontal');
    title(lg, 'Coefficient values:', 'FontSize', 12);
    lg.Layout.Tile = 'north'; 
    
    saveas(gcf, ['IRFs_varying_tetPi_Contractionary_Shock_' shock '.png']);
end


% Simulations for varying output coefficient
for Y_idx = 1:length(tetY_values)
    par.tetY = tetY_values(Y_idx);
    par.tetPi = fixed_tetPi; % Keeping inflation target coefficient fixed

    % Call Dynare to initialize model
eval(['dynare Oil_shock_two_sector_model.mod -Dreplic_number=' num2str(replicnumber) ...
	' -Dsimul_replic_number=' num2str(simreplicnumber) ' -Ddrop_number=' num2str(dropnumber) ...
	' -Dapprox_order=' num2str(approxorder) ' -Dirf_periods=' num2str(irfperiod) ...
	' -Dsim_periods=' num2str(simperiod) ' noclearall;']);


    % Retrieving and storing IRFs for each variable and shock
    for var_idx = 1:length(variable_names)
        for shock_idx = 1:length(shock_types)
            shock = shock_types{shock_idx};
            var_name = variable_names{var_idx};
            IRFs.(shock).(var_name)(:, Y_idx) = eval(['oo_.irfs.' var_name '_e' shock]);
        end
    end
end

% Plotting IRFs for varying tetY
for shock_idx = 1:length(shock_types)
    shock = shock_types{shock_idx};
    figure('Name', ['IRFs for varying tetY - Shock: ', shock]);
    sgtitle(['IRFs for Varying Output Coefficient for Contractionary: ' shock]);
   
    % Create a 4x4 grid layout
    t = tiledlayout(4, 4);
    title(t, ['']);

    for var_idx = 1:length(variable_names)
        var_name = variable_names{var_idx};
        nexttile; % Add subplot to the next tile in the grid
        hold on;
        for Y_idx = 1:length(tetY_values)
            plot(IRFs.(shock).(var_name)(:, Y_idx), 'LineWidth', 2.5);
        end
        hold off;
        title(var_titles{var_idx}, 'Interpreter', 'none'); 
        xlabel('Periods');
        ylabel('%-Dev. St.St.');
        axis tight;
        yline(0, 'r');
    end

    lg = legend(arrayfun(@num2str, tetY_values, 'UniformOutput', false), 'Position', [0.5, 0.01, 0.01, 0.01], 'Orientation', 'horizontal');
    title(lg, 'Coefficient values:', 'FontSize', 12); 
    lg.Layout.Tile = 'north'; 

    drawnow;

    saveas(gcf, ['IRFs_varying_tetY_Contractionary_Shock_' shock '.png']);
end


toc;
