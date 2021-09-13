
function [daughter,fourier_factor,coi,dofmin] = ...
	wave_bases(mother,k,scale,param);

mother = upper(mother);
n = length(k);

if (strcmp(mother,'MORLET'))  %-----------------------------------  Morlet
	if (param == -1), param = 6.;, end
	k0 = param;
	expnt = -(scale.*k - k0).^2/2.*(k > 0.);
	norm = sqrt(scale*k(2))*(pi^(-0.25))*sqrt(n);    % total energy=N   
	daughter = norm*exp(expnt);
	daughter = daughter.*(k > 0.);     % Heaviside step function
	fourier_factor = (4*pi)/(k0 + sqrt(2 + k0^2)); % Scale-->Fourier 
	coi = fourier_factor/sqrt(2);                  % Cone-of-influence 
	dofmin = 2;                                    % Degrees of freedom
elseif (strcmp(mother,'PAUL'))  %--------------------------------  Paul
	if (param == -1), param = 4.;, end
	m = param;
	expnt = -(scale.*k).*(k > 0.);
	norm = sqrt(scale*k(2))*(2^m/sqrt(m*prod(2:(2*m-1))))*sqrt(n);
	daughter = norm*((scale.*k).^m).*exp(expnt);
	daughter = daughter.*(k > 0.);     % Heaviside step function
	fourier_factor = 4*pi/(2*m+1);
	coi = fourier_factor*sqrt(2);
	dofmin = 2;
elseif (strcmp(mother,'DOG'))  %--------------------------------  DOG
	if (param == -1), param = 2.;, end
	m = param;
	expnt = -(scale.*k).^2 ./ 2.0;
	norm = sqrt(scale*k(2)/gamma(m+0.5))*sqrt(n);
	daughter = -norm*(i^m)*((scale.*k).^m).*exp(expnt);
	fourier_factor = 2*pi*sqrt(2./(2*m+1));
	coi = fourier_factor/sqrt(2);
	dofmin = 1;
else
	error('Mother must be one of MORLET,PAUL,DOG')
end

return


