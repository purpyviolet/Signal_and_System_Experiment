% 温馨提示，本脚本处理效果较差，为了保护您的耳朵请一定要降低音量！
% 温馨提示，本脚本处理效果较差，为了保护您的耳朵请一定要降低音量！
% 温馨提示，本脚本处理效果较差，为了保护您的耳朵请一定要降低音量！
% 温馨提示，本脚本处理效果较差，为了保护您的耳朵请一定要降低音量！
% 读入语音信号和噪声样本
[y, Fs] = audioread('myvoice_noisy.wav');
y = y(:,1); % 假设是单声道
[noise, Fs_noise] = audioread('white_noise.wav');
noise = noise(:,1); % 假设是单声道

% 设置振幅调整系数
amplitude_factor = 0.5; % 例如，减少到原来的一半

% 调整噪声的振幅
noise_adjusted = noise * amplitude_factor;

% 确保噪声样本与语音信号的采样率相同
if Fs ~= Fs_noise
    error('采样率不匹配。确保语音信号和噪声样本的采样率相同。');
end

% 截断或重复噪声样本以匹配语音信号的长度
if length(noise) < length(y)
    noise = repmat(noise, ceil(length(y)/length(noise)), 1);
end
noise = noise(1:length(y));
% 确保噪声样本与语音信号的采样率相同
if Fs ~= Fs_noise
    error('采样率不匹配。确保语音信号和噪声样本的采样率相同。');
end

% 截断或重复噪声样本以匹配语音信号的长度
if length(noise) < length(y)
    noise = repmat(noise, ceil(length(y)/length(noise)), 1);
end
noise = noise(1:length(y));

% 归一化语音信号和噪声样本
y_max = max(abs(y));
noise_max = max(abs(noise));

if y_max > 0  % 防止除以零
    y_normalized = y / y_max;
else
    y_normalized = y;
end

if noise_max > 0  % 防止除以零
    noise_normalized = noise / noise_max;
else
    noise_normalized = noise;
end


% 设计一个带通滤波器，仅通过噪声样本的高频部分
bpFilt = designfilt('bandpassfir', 'FilterOrder', 20, ...
             'CutoffFrequency1', 1000, 'CutoffFrequency2', 3000, ...
             'SampleRate', Fs);

% 应用带通滤波器到噪声样本
noise_bp = filter(bpFilt, noise);

% 设计巴特沃斯带通滤波器
%[n, Wn] = buttord([1000 2000]/(Fs/2), [900 2100]/(Fs/2), 3, 40);
%[b, a] = butter(n, Wn, 'bandpass');

% 应用带通滤波器到噪声样本
%noise_bp = filter(b, a, noise);


% 自适应滤波器初始化
mu = 0.002;  % 步长大小
order = 100;  % 滤波器阶数
h = dsp.LMSFilter('Length', order, 'StepSize', mu);

% 使用LMS算法和带通过滤后的噪声来滤除原始语音信号中的噪声
y_filtered = zeros(size(y));
for n = 1:length(y)
    [y_filtered(n), ~] = step(h, y(n), noise_bp(n));
end

% 计算FFT
N = length(y);
Y_fft = fft(y, N);
Noise_fft = fft(noise, N);
Y_filtered_fft = fft(y_filtered, N);
f = Fs*(0:(N/2))/N;

% 绘制FFT图
figure;
subplot(3,1,1);
plot(f, abs(Y_fft(1:N/2+1)));
title('Voice with Noise Signal FFT');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(3,1,2);
plot(f, abs(Noise_fft(1:N/2+1)));
title('Noise FFT');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(3,1,3);
plot(f, abs(Y_filtered_fft(1:N/2+1)));
title('Filtered Speech Signal FFT');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% 规范化滤波后的信号以便播放
y_filtered_norm = y_filtered / max(abs(y_filtered));
y_filtered_norm = y_filtered_norm * 0.5;
% 播放原始和过滤后的语音信号
sound(y, Fs);
pause(length(y)/Fs + 1);
% 播放规范化后的滤波信号
sound(y_filtered_norm, Fs);
pause(length(y_filtered)/Fs + 1);
