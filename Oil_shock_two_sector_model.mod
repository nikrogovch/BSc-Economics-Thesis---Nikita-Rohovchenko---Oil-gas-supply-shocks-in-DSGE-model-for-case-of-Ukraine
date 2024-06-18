%% *****************************************************************************
% Thesis BSc Economics - Spring Term 2023/2024
% Oil/gas shock in NK model with differentiated consumption goods and 2 production sectors
% Nikita Rohovchenko - Tilburg University
% 18/06/2024
% ******************************************************************************
% ------------------------------------------------------------------------------
% I) Define Variables and Parameters
% ------------------------------------------------------------------------------

var
    Y_r         ${Y_r}$         (long_name='Real Output regular consumption')
    Y_e         ${Y_e}$         (long_name='Real Output energy consumption')
    L           ${L}$           (long_name='Total Hours')
    L_r         ${L_r}$         (long_name='Total Hours in regular consumption')
    L_e         ${L_e}$         (long_name='Total Hours in energy consumption')
    K           ${K}$           (long_name='Capital Stock')
    K_r         ${K_r}$         (long_name='Capital Stock in regular consumption')
    K_e         ${K_e}$         (long_name='Capital Stock in energy consumption')
    O_r         ${O_r}$         (long_name='Oil supply in regular consumption')
    O_e         ${O_e}$         (long_name='Oil supply in energy consumption')
    C           ${C}$           (long_name='Real Consumption')
    C_r         ${C_r}$         (long_name='Real regular Consumption sector')
    C_e         ${C_e}$         (long_name='Real energy Consumption sector')
    C_ER        ${C_ER}$        (long_name='Relative consumption bundle')
    w           ${w}$           (long_name='Real Wage')
    w_e         ${w_e}$         (long_name='Real Wage energy sector (not adjusted)')
    r           ${r}$           (long_name='Real Rental Rate')
    r_e         ${r_e}$         (long_name='Real Rental Rate energy sector (not adjusted)')
    or          ${or}$          (long_name='Real price of oil')
    or_e        ${or_e}$        (long_name='Real price of oil energy sector (not adjusted)')
    q           ${q}$           (long_name='Nominal Bond Price')
    mc_r        ${mc}$          (long_name='Real Marginal Costs')
    mc_e        ${mc_e}$        (long_name='Real Marginal Costs energy sector (not adjusted)')
    pii_r       ${\pi_r}$       (long_name='Price Inflation regular consumption')
    pii_e       ${\pi_e}$       (long_name='Price Inflation energy consumption')
    pii_er      ${\pii_er}$     (long_name='Relative price change')
    pii         ${\pi}$         (long_name='CPI')
    P_ER        ${\P_ER}$       (long_name='Relative price of energy to regular consumption')
    z           ${z}$           (long_name='Productivity Growth Rate')
    m           ${m}$           (long_name='Monetary Policy Distortion')
    o           ${o}$           (long_name='Change in oil supply')
    ;

predetermined_variables
    K
    ;

varexo
    eZ          ${\varepsilon_A}$   (long_name='Productivity Shock')
    eM          ${\varepsilon_M}$   (long_name='Monetary Policy Shock')
    eO          ${\varepsilon_O}$   (long_name='Oil supply Shock')   
    ;   

parameters 
    betta       ${\beta}$           (long_name='Period Discount Rate')
    beta_r      ${\beta_r}$         (long_name='Oil Elasticity w.r.t. Regular Output')
    beta_e      ${\beta_e}$         (long_name='Oil Elasticity w.r.t. Energy Output')
    alp_r       ${\alpha_r}$        (long_name='Capital Elasticity w.r.t. Regular Output')
    alp_e       ${\alpha_e}$        (long_name='Capital Elasticity w.r.t. Energy Output')
    alp_C       ${\alpha_C}$        (long_name='Consumption share in total consumption')
    Oil         ${Oil}$             (long_name='Oil supply')
    phi         ${\phi}$            (long_name='Labor Disutility parameter')
    phiC        ${\phiC}$           (long_name='Habit Formation parameter')
    gam         ${\gamma}$          (long_name='Inverse Frisch Labor Supply Elasticity')
    delt        ${\delta}$          (long_name='Capital Depreciation Rate')
    rho_r       ${\rho_r}$          (long_name='Regular Goods Elasticity of Substitution')
    rho_e       ${\rho_e}$          (long_name='Energy Goods Elasticity of Substitution')
    rho_C       ${\rho_C}$          (long_name='Consumption Elasticity of Substitution')
    kap_r       ${\kappa_r}$        (long_name='Price Adjustment Costs Parameter Regular Consumption sector')
    kap_e       ${\kappa_e}$        (long_name='Price Adjustment Costs Parameter Energy Consumption sector')
    pibar       ${\bar{\pi}}$       (long_name='Target Inflation Rate')
    tetQ        ${\theta_{R}}$      (long_name='Interest Rate Smoothing')
    tetPi       ${\theta_{\pi}}$    (long_name='Taylor Coefficient w.r.t. Inflation')
    tetY        ${\theta_{Y}}$      (long_name='Taylor Coefficient w.r.t. Real GDP')
    stdZ        ${\sigma_Z}$        (long_name='Standard Deviation Productivity Shock')
    stdM        ${\sigma_M}$        (long_name='Standard Deviation Monetary Policy Shock')
    stdO        ${\sigma_O}$        (long_name='Standard Deviation oil Shock')
    rhoZ        ${\rho_Z}$          (long_name='Autocorrelation Productivity Shock')
    rhoM        ${\rho_M}$          (long_name='Autocorrelation Monetary Policy Shock')
    rhoO        ${\rho_O}$          (long_name='Autocorrelation oil Shock')
    ;

% ------------------------------------------------------------------------------
% II) Define Parameter Values
% ------------------------------------------------------------------------------

% Calibrated to Ukrainian economy - are assigned from the files used to run the model
set_param_value('betta',par.betta);
set_param_value('beta_r',par.beta_r);
set_param_value('beta_e',par.beta_e);
set_param_value('alp_r',par.alp_r);
set_param_value('alp_e',par.alp_e);
set_param_value('alp_C',par.alp_C);
set_param_value('Oil',par.Oil);
set_param_value('phi',par.phi);
set_param_value('phiC',par.phiC);
set_param_value('gam',par.gam);
set_param_value('delt',par.delt);
set_param_value('rho_r',par.rho_r);
set_param_value('rho_e',par.rho_e);
set_param_value('rho_C',par.rho_C);
set_param_value('kap_r',par.kap_r);
set_param_value('kap_e',par.kap_e);
set_param_value('pibar',par.pibar);
set_param_value('tetQ',par.tetQ);
set_param_value('tetPi',par.tetPi);
set_param_value('tetY',par.tetY);
set_param_value('stdZ',par.stdZ);
set_param_value('stdM',par.stdM);
set_param_value('rhoZ',par.rhoZ);
set_param_value('rhoM',par.rhoM);

% Extension parameters

set_param_value('stdO',par.stdO); 
set_param_value('rhoO',par.rhoO);

%-------------------------------------------------------------------------------
% III) Model Block
%-------------------------------------------------------------------------------

model;

%-------------------------------------------------------------------------------
% Sticky price economy
%-------------------------------------------------------------------------------

% Household
% ---------------------------------

[name='Labor supply through Regular sector']

w   = phi * L^gam  * (1/    ((alp_C*C_r^(rho_C-1)*(alp_C*C_r^rho_C+(1-alp_C)*C_e^rho_C)^(1/rho_C-1))/((alp_C*C_r^rho_C+(1-alp_C)*C_e^rho_C)^(1/rho_C)-phiC*(alp_C*C_r(-1)^rho_C+(1-alp_C)*C_e(-1)^rho_C)^(1/rho_C)) -(phiC * betta*(alp_C*C_r^(rho_C-1)*(alp_C*C_r^rho_C+(1-alp_C)*C_e^rho_C)^(1/rho_C-1)))/(((alp_C*C_r(+1)^rho_C+(1-alp_C)*C_e(+1)^rho_C)^(1/rho_C)-phiC*(alp_C*C_r^rho_C+(1-alp_C)*C_e^rho_C)^(1/rho_C)))           ));


[name='Labor supply through Energy sector']

w_e = phi * L^gam * P_ER * (1/    (((1-alp_C)*C_e^(rho_C-1)*(alp_C*C_r^rho_C+(1-alp_C)*C_e^rho_C)^(1/rho_C-1))/((alp_C*C_r^rho_C+(1-alp_C)*C_e^rho_C)^(1/rho_C)-phiC*(alp_C*C_r(-1)^rho_C+(1-alp_C)*C_e(-1)^rho_C)^(1/rho_C)) - (phiC * betta*((1-alp_C)*C_e^(rho_C-1)*(alp_C*C_r^rho_C+(1-alp_C)*C_e^rho_C)^(1/rho_C-1)))/(((alp_C*C_r(+1)^rho_C+(1-alp_C)*C_e(+1)^rho_C)^(1/rho_C)-phiC*(alp_C*C_r^rho_C+(1-alp_C)*C_e^rho_C)^(1/rho_C)))           ));


[name='Capital allocation (Tobins Q/Euler equation)']
1   = (betta * L(+1)^gam * w * (r(+1)+(1-delt))) / (w(+1) * L^gam);

[name='Bond demand (Euler equation)']
q   = (betta * L(+1)^gam * w)/((1+pii_r(+1)) * w(+1) * L^gam);



% Intermediate good firm Regular Sector
% ---------------------------------

[name='Labor demand Regular Sector']
w   = (1-alp_r-beta_r)*Y_r/L_r*mc_r;

[name='Capital demand Regular Sector']
r   = alp_r*Y_r/K_r*mc_r;

[name='Oil demand Regular Sector']
or   = beta_r*Y_r/O_r*mc_r;

[name='NK Phillips curve Regular Sector']
kap_r*(pii_r-steady_state(pii_r))*(1+pii_r)*(1-rho_r)*mc_r = (1+kap_r/2*(pii_r-steady_state(pii_r))^2)*mc_r - rho_r
                   + q*(1+pii_r(+1))*kap_r*(pii_r(+1)-steady_state(pii_r))*(1+pii_r(+1))*Y_r(+1)/Y_r*mc_r(+1)*(1-rho_r);



% Intermediate good firm Energy Sector
% ---------------------------------


[name='Labor demand Energy Sector']
w_e   = (1-alp_e-beta_e)*Y_e/(L_e)*mc_e;

[name='Capital demand Energy Sector']
r_e   = alp_e*Y_e/(K_e)*mc_e;

[name='Oil demand Energy Sector']
or_e   = beta_e*Y_e/(O_e)*mc_e;

[name='NK Phillips curve Energy Sector']
kap_e*(pii_e-steady_state(pii_e))*(1+pii_e)*(1-rho_e)*mc_e = (1+kap_e/2*(pii_e-steady_state(pii_e))^2)*mc_e - rho_e*P_ER
                   + q*(1+pii_e(+1))*kap_e*(pii_e(+1)-steady_state(pii_e))*(1+pii_e(+1))*Y_e(+1)/Y_e*mc_e(+1)*(1-rho_e)*P_ER/P_ER(+1);



% Constraints
% ---------------------------------

[name='Resource constraint Regular Consumption']
C_r   = Y_r - K(+1) + (1-delt)*K;

[name='Resource constraint Energy Consumption']
C_e   = Y_e;

[name='Production function Regular Sector']
Y_r   = exp(z)*(L_r^(1-alp_r-beta_r))*(K_r^alp_r)*(O_r^beta_r);

[name='Production function Energy Sector']
Y_e   = exp(z)*(L_e^(1-alp_e-beta_e))*(K_e^alp_e)*(O_e^beta_e);

[name='Capital clearing condition']
K     = K_e + K_r;

[name='Oil clearing condition']
O_e   = exp(o)*Oil - O_r;

[name='Labor clearing condition']
L     = L_e + L_r;

[name='Total Consumption']
C     = C_r + P_ER*C_e;

[name='Relative Consumption bundle']
C_ER  = C_e*P_ER/C_r;

[name='Real Wage condition']
w     = w_e;

[name='Real Rental price of capital condition']
r     = r_e;

[name='Real price of oil condition']
or     = or_e;

[name='Inflation condition']

pii_r = (1 + pii_e) * P_ER(-1) / P_ER - 1;

[name='Relative price change']

pii_er = P_ER/P_ER(-1)-1;

[name='CPI']

pii = ((1+pii_e)/(1+pii_er) - 1)  * (P_ER*C_e)/C + pii_r *C_r/C;

% Policy rules
% ---------------------------------

[name='Interest rate rule']
 (1/q) = (1/q(-1))^tetQ * (1/steady_state(q))^(1-tetQ)
                        * ((1+pii)/(1+steady_state(pii)))^((1-tetQ)*tetPi)
                        * (Y_r/steady_state(Y_r))^((1-tetQ)*tetY)
                        * exp(m);

%-------------------------------------------------------------------------------
% IV) Define Exogenous processes
%-------------------------------------------------------------------------------

[name='Productivity growth process']
z   = rhoZ*z(-1) - eZ;

[name='Monetary policy shock process']
m   = rhoM*m(-1) + eM;

[name='Energy Shock process']
o   = rhoO*o(-1) - eO;


end;
% ------------------------------------------------------------------------------
% V) Steady State Calculations
% ------------------------------------------------------------------------------


resid;
check;

% ------------------------------------------------------------------------------
% VI) Define Shock Processes
% ------------------------------------------------------------------------------

shocks;
    var eZ  = stdZ^2;
    var eM  = stdM^2;
    var eO  = stdO^2;
end;

% ------------------------------------------------------------------------------
% VII) Simulation
% ------------------------------------------------------------------------------

stoch_simul(
            order=@{approx_order},
            nodisplay,
            nograph,
            pruning,
            irf=@{irf_periods},
            periods=@{sim_periods},
            replic=@{replic_number},
            simul_replic=@{simul_replic_number},
            drop=@{drop_number}
);% Y_r Y_e pii pii_r pii_e L K C_r C_e q mc_r w C L_r L_e K_r K_e;


%----------------------------- End of File --------------------------------