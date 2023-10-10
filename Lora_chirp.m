clear all

% Parameters
SF = 12;                  %spreading factor
BW = 1000;               %Bandwidth
Fs = 1000;               % Sampling frequency (Hz)
S=30;                    %send symbol
SNR=-20;      

%t = 0:1/fs:1;            % Time vector (0 to 1 second)
%f0 = 100;                % Starting frequency (Hz)
%f1 = 400;                % Ending frequency (Hz)

% Generate a data symbol
num_samples=(2^SF)*Fs/BW;
K=S; 
lora_symbol=zeros(1, num_samples);
for n=1:num_samples
    if K>= (2^SF)
        K=K-2^SF;
    end
    K=K+1;
    lora_symbol(n)= (1/(sqrt(2^SF)))*exp(1i*2*pi*(K)*(K/(2^SF*2)));
end

for j=1:100


%Add noise
lora_symbol_noisy = awgn(lora_symbol, SNR, 'measured');

%Transmit
%Receiver below
%--------------Generate the base down chirp---------

base_down_chirp = zeros(1,num_samples);
K=0;
for n=1:num_samples
    if K>= (2^SF)
        K=K-2^SF;
    end
    K=K+1;
    base_down_chirp(n) = (1/(sqrt(2^SF)))*exp(-1i*2*pi*(K)*(K/(2^SF*2)));
end

dechirped = lora_symbol_noisy.*(base_down_chirp);

corrs = (abs(fft(dechirped)).^2);
plot(corrs)
[~, ind] = max(corrs);
ind2(j) = ind;

pause(0.1)

end

histogram(ind2, 2^SF)
symbol_error_rate = sum(ind2~=s+1)/j;

%spectogram(lora_symbol)




