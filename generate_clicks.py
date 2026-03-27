import wave, struct, math, os

os.makedirs('assets/audio', exist_ok=True)

def generate_beep(filename, frequency, duration=0.05, sample_rate=44100):
    obj = wave.open(filename, 'w')
    obj.setnchannels(1) # mono
    obj.setsampwidth(2) # 2 bytes
    obj.setframerate(sample_rate)
    
    # Envelope to avoid clicking at the end of the sound
    for i in range(int(duration * sample_rate)):
        # Apply exponential decay for percussive sound
        decay = math.exp(-i / (sample_rate * 0.01))
        value = int(32767.0 * math.sin(2.0 * math.pi * frequency * i / sample_rate) * decay)
        data = struct.pack('<h', value)
        obj.writeframesraw(data)
    obj.close()

generate_beep('assets/audio/click_accent.wav', 1200.0) # High pitch for accent
generate_beep('assets/audio/click_normal.wav', 800.0)  # Low pitch for normal
generate_beep('assets/audio/click_sub.wav', 500.0, 0.03) # Lower pitch, shorter for subdivisions
print("Audio generated in assets/audio/")
