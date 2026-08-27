#!/usr/bin/env python3
"""Minik Kasif icin oyun ses efektleri uretir. Disarida hazir ses aramaya gerek yok."""
import wave, struct, math, os, random

SR = 44100
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'assets', 'sounds')
os.makedirs(OUT, exist_ok=True)

def save(name, samples):
    path = os.path.join(OUT, name)
    with wave.open(path, 'w') as w:
        w.setnchannels(1); w.setsampwidth(2); w.setframerate(SR)
        frames = b''.join(struct.pack('<h', max(-32767, min(32767, int(s)))) for s in samples)
        w.writeframes(frames)
    print(name, len(samples)/SR, 's')

def env(i, n, attack=0.05, release=0.3):
    a = int(n*attack); r = int(n*release)
    if i < a: return i/max(a,1)
    if i > n-r: return max(0,(n-i)/max(r,1))
    return 1.0

def tone(freq, dur, vol=0.5, wave_fn=None, fm=None):
    n = int(SR*dur); out=[]
    for i in range(n):
        t = i/SR
        f = freq if fm is None else freq + fm(t)
        s = math.sin(2*math.pi*f*t)
        out.append(s*vol*env(i,n)*32767)
    return out

def sweep(f0, f1, dur, vol=0.5, shape='sin'):
    n=int(SR*dur); out=[]
    for i in range(n):
        t=i/SR
        f = f0 + (f1-f0)*(i/n)
        ph = 2*math.pi*f*t
        s = math.sin(ph) if shape=='sin' else (1 if math.sin(ph)>0 else -1)*0.6
        out.append(s*vol*env(i,n,0.02,0.4)*32767)
    return out

def chord(freqs, dur, vol=0.4):
    n=int(SR*dur); out=[0]*n
    for i in range(n):
        t=i/SR
        s=sum(math.sin(2*math.pi*f*t) for f in freqs)/len(freqs)
        out[i]=s*vol*env(i,n,0.01,0.5)*32767
    return out

def noise_burst(dur, vol=0.3):
    n=int(SR*dur); out=[]
    random.seed(7)
    for i in range(n):
        out.append((random.random()*2-1)*vol*env(i,n,0.01,0.6)*32767)
    return out

def concat(*parts):
    out=[]
    for p in parts: out.extend(p)
    return out

# --- Efektler ---
save('tap.wav', tone(880,0.08,0.35))
save('correct.wav', concat(tone(523,0.1,0.4), tone(659,0.1,0.4), tone(784,0.16,0.45)))  # do-mi-sol
save('wrong.wav', concat(tone(300,0.12,0.35), tone(220,0.18,0.35)))
save('flip.wav', sweep(400,900,0.12,0.3))
save('match.wav', concat(tone(659,0.09,0.4), tone(880,0.14,0.45)))
save('star.wav', concat(tone(784,0.08,0.4), tone(988,0.08,0.4), tone(1175,0.2,0.5)))
save('level_complete.wav', concat(
    chord([523,659,784],0.18), chord([587,740,880],0.18), chord([659,830,988],0.3)))
save('level_unlock.wav', sweep(300,1200,0.4,0.35))
save('button.wav', tone(700,0.06,0.3))
save('whoosh.wav', sweep(200,1500,0.25,0.25))
save('pop.wav', sweep(1200,300,0.08,0.35))
save('brush.wav', noise_burst(0.15,0.12))
save('confetti.wav', concat(tone(1046,0.06,0.3), tone(1318,0.06,0.3), tone(1568,0.06,0.3), tone(2093,0.1,0.35)))
save('collect_sticker.wav', concat(sweep(500,1500,0.15,0.35), tone(1568,0.12,0.4)))
save('bg_hum.wav', [0]*int(SR*0.1))  # placeholder sessiz - muzik eklenmiyor (dosya boyutu icin)
print('Tum sesler uretildi.')
