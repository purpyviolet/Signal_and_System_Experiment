% 读入.wav文件
[y, Fs] = audioread('myvoice.wav');

% 只取单声道进行处理
y = y(:,1);

% 生成白噪声
noise_amplitude = 0.01;% 噪声的振幅系数，根据需要调整

% Generate white noise
white_noise = noise_amplitude * randn(length(y), 1);

% Save the white noise as a .wav file
white_noise_path = 'white_noise.wav';
audiowrite(white_noise_path, white_noise, Fs);

% 将白噪声添加到原始音频信号中
y_noisy = y + white_noise;

% 计算白噪声的FFT
N = length(white_noise);
f = Fs*(0:(N/2))/N;
White_noise_fft = fft(white_noise);
P2_wn = abs(White_noise_fft/N);
P1_wn = P2_wn(1:N/2+1);
P1_wn(2:end-1) = 2*P1_wn(2:end-1);

% 计算混合音频的FFT
Noisy_fft = fft(y_noisy);
P2_n = abs(Noisy_fft/N);
P1_n = P2_n(1:N/2+1);
P1_n(2:end-1) = 2*P1_n(2:end-1);

% 绘制白噪声的频谱
figure;
subplot(2,1,1);
plot(f, P1_wn);
title('Frequency Spectrum of White Noise');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% 绘制混合音频的频谱
subplot(2,1,2);
plot(f, P1_n);
title('Frequency Spectrum of Noisy Speech Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');


% 播放原始音频文件
sound(y, Fs);
pause(length(y)/Fs + 1);  % 等待原始音频播放完毕

% 播放添加了白噪声的音频文件
sound(y_noisy, Fs);
pause(length(y_noisy)/Fs + 1);  % 等待带噪声音频播放完毕

% 将带噪声的音频保存到新文件
audiowrite('myvoice_noisy.wav', y_noisy, Fs);