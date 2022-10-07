clear all
close all
clc
cd('C:\Users\kk260\Desktop\ProjectItou2020\Script')% folder path
load('vq.mat')% filename
vq = fliplr(rot90(rot90(vq)));
imagesc(log(abs(vq)))