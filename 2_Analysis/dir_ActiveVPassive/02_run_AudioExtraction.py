import librosa
import numpy as np
import pandas as pd

def quantify_sound(wav_file, csv_output, TR = 2):

    # Load the audio file
    y, sr = librosa.load(wav_file, sr=None)

    # Define the window length (2 seconds)
    window_length = TR * sr  # 2 seconds

    # Calculate the number of windows
    num_windows = len(y) // window_length

    # Initialize a list to hold the average volume levels
    average_volumes = []

    # Calculate the average volume for each window
    for i in range(num_windows):
        start = i * window_length
        end = start + window_length
        window = y[start:end]
        avg_volume = 20 * np.log10(np.mean(np.abs(window)))
        average_volumes.append(avg_volume)

    # Create a DataFrame from the results
    time_intervals = [i * 2 for i in range(num_windows)]
    df = pd.DataFrame({'Time (s)': time_intervals, 'Average Volume (dB)': average_volumes})

    # Save the DataFrame to a CSV file
    df.to_csv(csv_output, index=False)

    print(f"Average volumes saved to {csv_output}")

quantify_sound(wav_file = "/data/Uncertainty/data/audio/StimVidTestFirstHalf_comp_audio.wav", 
               csv_output = "/data/Uncertainty/data/audio/StimVidTestFirstHalf_comp_audio.csv")

quantify_sound(wav_file = "/data/Uncertainty/data/audio/StimVidTestLastHalf_comp_audio.wav", 
               csv_output = "/data/Uncertainty/data/audio/StimVidTestLastHalf_comp_audio.csv")