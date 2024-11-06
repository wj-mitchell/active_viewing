# Before starting, do not forget to load the virtual environment by running
# source /data/Uncertainty/scripts/ProjPyEnv/bin/activate

import whisper
import numpy as np
import pandas as pd
import math

def speech_extract(input, output, TR = 2, stim_length = 1337):

    # Load the Whisper model
    model = whisper.load_model("base")

    # Transcribe the audio file
    result = model.transcribe(input)

    # Extract segments with timestamps
    speech_segments = []
    for segment in result['segments']:
        start_time = segment['start']
        end_time = segment['end']
        speech_segments.append((start_time, end_time))

    # Define TR duration and number of TRs based on your video length
    num_TRs = math.ceil(int(stim_length / TR))

    # Initialize dummy variable array
    dummy_variable = np.zeros(num_TRs)

    for segment in speech_segments:
        start_TR = int(segment[0] / TR)
        end_TR = int(segment[1] / TR)
        dummy_variable[start_TR:end_TR + 1] = 1
    
    # Create a dataframe from the dummy variable array
    df = pd.DataFrame(dummy_variable, columns = ["speech_presence"])

    # Save the dataframe to a csv file
    df.to_csv(output, index = False)

speech_extract(input = "/data/Uncertainty/data/audio/StimVidTestFirstHalf_comp_audio.wav",
               output = "/data/Uncertainty/data/audio/StimVidTestFirstHalf_dialogue.csv")

speech_extract(input = "/data/Uncertainty/data/audio/StimVidTestLastHalf_comp_audio.wav",
               output = "/data/Uncertainty/data/audio/StimVidTestLastHalf_dialogue.csv")