
function [signif,fft_theor] = ...
	wave_signif(Y,dt,scale1,sigtest,lag1,siglvl,dof,mother,param);

if (nargin < 9), param = -1;, end
if (nargin < 8), mother = -1;, end
if (nargin < 7), dof = -1;, end
if (nargin < 6), siglvl = -1;, end
if (nargin < 5), lag1 = -1;, end
if (nargin < 4), sigtest = -1;, end
if (nargin < 3)
	error('Must input a vector Y, sampling time DT, and SCALE vector')
end

n1 = length(Y);
J1 = length(scale1) - 1;
scale(1:J1+1) = scale1;
s0 = min(scale);
dj = log(scale(2)/scale(1))/log(2.);

if (n1 == 1)
	variance = Y;
else
	variance = std(Y)^2;
end

if (sigtest == -1), sigtest = 0;, end
if (lag1 == -1), lag1 = 0.0;, end
if (siglvl == -1), siglvl = 0.95;, end
if (mother == -1), mother = 'MORLET';, end

mother = upper(mother);

% get the appropriate parameters [see Table(2)]
if (strcmp(mother,'MORLET'))  %----------------------------------  Morlet
	if (param == -1), param = 6.;, end
	k0 = param;
	fourier_factor = (4*pi)/(k0 + sqrt(2 + k0^2)); % Scale-->Fourier 
	empir = [2.,-1,-1,-1];
	if (k0 == 6), empir(2:4)=[0.776,2.32,0.60];, end
elseif (strcmp(mother,'PAUL'))  %--------------------------------  Paul
	if (param == -1), param = 4.;, end
	m = param;
	fourier_factor = 4*pi/(2*m+1);
	empir = [2.,-1,-1,-1];
	if (m == 4), empir(2:4)=[1.132,1.17,1.5];, end
elseif (strcmp(mother,'DOG'))  %---------------------------------  DOG
	if (param == -1), param = 2.;, end
	m = param;
	fourier_factor = 2*pi*sqrt(2./(2*m+1));
	empir = [1.,-1,-1,-1];
	if (m == 2), empir(2:4) = [3.541,1.43,1.4];, end
	if (m == 6), empir(2:4) = [1.966,1.37,0.97];, end
else
	error('Mother must be one of MORLET,PAUL,DOG')
end

period = scale.*fourier_factor;
dofmin = empir(1);     % Degrees of freedom with no smoothing
Cdelta = empir(2);     % reconstruction factor
gamma_fac = empir(3);  % time-decorrelation factor
dj0 = empir(4);        % scale-decorrelation factor

freq = dt ./ period;   % normalized frequency
fft_theor = (1-lag1^2) ./ (1-2*lag1*cos(freq*2*pi)+lag1^2);  
fft_theor = variance*fft_theor;  % include time-series variance
signif = fft_theor;
if (dof == -1), dof = dofmin;, end

if (sigtest == 0)    % no smoothing, DOF=dofmin 
	dof = dofmin;
	chisquare = chisquare_inv(siglvl,dof)/dof;
	signif = fft_theor*chisquare ;  
elseif (sigtest == 1)  % time-averaged significance
	if (length(dof) == 1), dof=zeros(1,J1+1)+dof;, end
	truncate = find(dof < 1);
	dof(truncate) = ones(size(truncate));
	dof = dofmin*sqrt(1 + (dof*dt/gamma_fac ./ scale).^2 );  
	truncate = find(dof < dofmin);
	dof(truncate) = dofmin*ones(size(truncate));   % minimum DOF is dofmin
	for a1 = 1:J1+1
		chisquare = chisquare_inv(siglvl,dof(a1))/dof(a1);
		signif(a1) = fft_theor(a1)*chisquare;
	end
elseif (sigtest == 2)  % time-averaged significance
	if (length(dof) ~= 2)
		error('DOF must be set to [S1,S2], the range of scale-averages')
	end
	if (Cdelta == -1)
		error(['Cdelta & dj0 not defined for ',mother, ...
			' with param = ',num2str(param)])
	end
	s1 = dof(1);
	s2 = dof(2);
	avg = find((scale >= s1) & (scale <= s2));  % scales between S1 & S2
	navg = length(avg);
	if (navg == 0)
		error(['No valid scales between ',num2str(s1),' and ',num2str(s2)])
	end
	Savg = 1./sum(1 ./ scale(avg));       
	Smid = exp((log(s1)+log(s2))/2.);     % power-of-two midpoint
	dof = (dofmin*navg*Savg/Smid)*sqrt(1 + (navg*dj/dj0)^2);  
	fft_theor = Savg*sum(fft_theor(avg) ./ scale(avg));  
	chisquare = chisquare_inv(siglvl,dof)/dof;
	signif = (dj*dt/Cdelta/Savg)*fft_theor*chisquare;    
else
	error('sigtest must be either 0, 1, or 2')
end

return


