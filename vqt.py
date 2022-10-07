import librosa
import librosa.display
import matplotlib.pyplot as plt
import numpy as np
import os.path
import scipy.io

#音のファイルパス指定
audio_path = r"soukaPiano.wav"
y, sr = librosa.load(audio_path)
#y,sr = librosa.load(audio_path,sr=16000)# サンプリング周波数をかえる場合は読み込み時に変える

D = librosa.vqt(y,sr=sr,bins_per_octave=12,gamma=None)  
# VQT(CQTもいける,詳細なパラメータはlibrosaのdocumentationを参照)


################  plot  #################
S, phase = librosa.magphase(D)  # 複素数を強度と位相へ変換
Sdb = librosa.amplitude_to_db(S,ref=np.max)  # 強度をdb単位へ変換
plt.figure()
img = librosa.display.specshow(Sdb, sr=sr, x_axis='time' ,y_axis='cqt_note')
plt.show()


################  save  #################
scipy.io.savemat(r'C:\Users\kk260\Desktop\ProjectItou2020\Script\vq.mat',{'vq':D})
