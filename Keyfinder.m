[y,fs]=audioread('Akigara.wav');
%Stereo to Mono
y = mean(y,2);

Framesize=8192;
%divide into Frame
maxFrame= floor(length(y)/Framesize);

Framestart = 1;
Frameend = Framestart + Framesize - 1;

chroma12=zeros(12,maxFrame);

for fid=1:maxFrame %FrameID
    %Get framedata per 1 frame
    dataFrame = y(Framestart : Frameend);
    
    %set window
    window = hanning(Framesize);
    dataFrame = dataFrame .* window;
    
    fftsize=8192;
    dft = fft(dataFrame , fftsize);
    
    Adft = abs(dft);
    
    %frequency scale
    fscale = linspace(1,fs,fftsize);
    
    %frequency cent
    fc = 1200*log2(fscale/(440 * pow2(3/12-5)));
    [m,n]=size(fc);

    for p=1:12
        cv=0;
        for h=3:8
            Fch =1200 * h + 100* (p-1);
            BPFch = (1-cos(2*pi*(fc -(Fch - 100))/200))/2;
            
            %Get Fch-100 < fc < Fch+100
            a = fc > Fch-100 & fc < Fch + 100;
            BPFch = a .* BPFch;
            
            cv = cv + dot(BPFch' , Adft);
        end
        chroma12(p,fid)=+cv;
    end
    Framestart = Framestart + Framesize/2;
    Frameend = Frameend + Framesize/2;
end
chromavec=sum(chroma12,2);
bar(chromavec);
xticklabels({'C','C#','D','D#','E','F','F#','G','G#','A','A#','B'})

%Keyestimate
Key=maxk(chromavec,7);
Key7=zeros(1,7);
for keyid=1:7
    k=find(chromavec==(Key(keyid)));
    Key7(keyid)=k;
end
Keynum=sort(Key7);

C=[1 3 5 6 8 10 12];
G=[1 3 5 7 8 10 12];
D=[2 3 5 7 8 10 12];
A=[2 3 5 7 9 10 12];
E=[2 4 5 7 9 10 12];
B=[2 4 5 7 9 11 12];
Fs=[2 4 6 7 9 11 12];
Cs=[1 2 4 6 7 9 11];
Af=[1 2 4 6 8 9 11];
Ef=[1 3 4 6 8 9 11];
Bf=[1 3 4 6 8 10 11];
F=[1 3 5 6 8 10 11];

LiaC=ismember(Keynum,C);
mC=sum(LiaC);
LiaG=ismember(Keynum,G);
mG=sum(LiaG);
LiaD=ismember(Keynum,D);
mD=sum(LiaD);
LiaA=ismember(Keynum,A);
mA=sum(LiaA);
LiaE=ismember(Keynum,E);
mE=sum(LiaE);
LiaB=ismember(Keynum,B);
mB=sum(LiaB);
LiaFs=ismember(Keynum,Fs);
mFs=sum(LiaFs);
LiaCs=ismember(Keynum,Cs);
mCs=sum(LiaCs);
LiaAf=ismember(Keynum,Af);
mAf=sum(LiaAf);
LiaEf=ismember(Keynum,Ef);
mEf=sum(LiaEf);
LiaBf=ismember(Keynum,Bf);
mBf=sum(LiaBf);
LiaF=ismember(Keynum,F);
mF=sum(LiaF);
match=[mC mG mD mA mE mB mFs mCs mAf mEf mBf mF];
matchn=find(match==max(match));
if any(matchn==1)
    disp('C / Am')
end
if any(matchn == 2)
    disp('G / Em')
end
if any(matchn == 3)
    disp('D / Bm')
end
if any(matchn == 4)
    disp('A / F#m')
end
if any(matchn == 5)
    disp('E / C#m')
end
if any(matchn == 6)
    disp('B , C♭ / A♭m , G#m ')
end
if any(matchn == 7)
    disp('F# , G♭ / E♭m , D#m')
end
if any(matchn == 8)
    disp('C# , D♭ / B♭m , A#m')
end
if any(matchn == 9)
    disp('A♭ / Fm')
end
if any(matchn == 10)
    disp('E♭ / Cm')
end
if any(matchn == 11)
    disp('B♭ / Gm')
end
if any(matchn == 12)
    disp('F / Dm')
end
