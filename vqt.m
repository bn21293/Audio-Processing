clear all
close all
clc
cd('C:\Users\')% folder path
load('vq.mat')% filename
vq = fliplr(rot90(rot90(vq)));
imagesc(log(abs(vq)))
