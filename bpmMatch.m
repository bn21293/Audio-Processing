fr = 1024;  %フレームのサンプル数
bpm_spc = 0.1;
bpm_min = 60;
bpm_max = 240;

[y,fs] = audioread('soukaPiano.wav');

%音量データ-->音量差分データ
len = floor(length(y)/fr);
y = mean(y,2);  %L/Rで平均をとりモノラルへ

y_fr = zeros(len,1);
for i = 1:len
    y_fr(i) = rms(y(1+(i-1)*fr:i*fr));
end

y_fr_diff = diff(y_fr);

%BPM マッチの計算
N = length(y_fr);
s = fs/fr;
bpm_seq = bpm_min:bpm_spc:bpm_max;
bpm_match = zeros(length(bpm_seq),1);

for i = 1:length(bpm_seq)
    bpm = bpm_seq(i);
    a_bpm = 0;
    b_bpm = 0;
    for j = 1:N
        a_bpm = a_bpm + y_fr(j)*cos(2*pi*(bpm/60)*j/s);
        b_bpm = b_bpm + y_fr(j)*sin(2*pi*(bpm/60)*j/s);
    end
    bpm_match(i) = rms([a_bpm,b_bpm]);
end

bpm_match = bpm_match ./ max(bpm_match);

plot(bpm_seq , bpm_match);
grid on;
xlim([bpm_min , bpm_max]);
ylim([0 , 1.1]);
xlabel('BPM');
ylabel('Matching Ratio (Normalized)');
