import cv2
import numpy as np
import os
import pandas as pd

# I some how fucking lost my original luminance calculation function and I don't have the time to recreate it exactly so this is a quick and dirty means of recreating it. I'm very livid because I was 99.99% sure it was on Github and Dropbox, but I just cannot find it anywhere whether it be those accounts, locally on the linux, lab computer, home computer, or laptop. How do you just lose a function? A lesson for whoever finds themself reading this I suppose. 

def calculate_luminance(image_path):
    # Load the image
    image = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    
    # Calculate the average luminance
    average_luminance = np.mean(image)
    
    return average_luminance

def process_video_frames(frame_folder, output_csv, interval_seconds, frame_rate):
    # List all frame files in the folder
    frame_files = sorted([f for f in os.listdir(frame_folder) if f.endswith(('.jpg', '.png'))])
    
    # Calculate the number of frames per interval
    frames_per_interval = int(interval_seconds * frame_rate)
    
    # Initialize a list to hold the luminance values
    luminance_values = []
    
    # Process frames in intervals
    num_intervals = len(frame_files) // frames_per_interval
    for i in range(num_intervals):
        start = i * frames_per_interval
        end = start + frames_per_interval
        interval_frames = frame_files[start:end]
        
        # Calculate the average luminance for the interval
        interval_luminance = []
        for frame_file in interval_frames:
            frame_path = os.path.join(frame_folder, frame_file)
            avg_luminance = calculate_luminance(frame_path)
            interval_luminance.append(avg_luminance)
        
        average_interval_luminance = np.mean(interval_luminance)
        luminance_values.append(average_interval_luminance)
    
    # Create a DataFrame from the results
    time_intervals = [i * interval_seconds for i in range(num_intervals)]
    df = pd.DataFrame({'Time (s)': time_intervals, 'Average Luminance': luminance_values})
    
    # Save the DataFrame to a CSV file
    df.to_csv(output_csv, index=False)
    
    print(f"Luminance values saved to {output_csv}")

# Example usage
frame_folder = 'path_to_exported_frames'  # Replace with your folder path
output_csv = 'luminance_values.csv'
interval_seconds = 2
frame_rate = 7.5  # Exported frame rate

process_video_frames(frame_folder = "/data/Uncertainty/data/visuals/StimVidTestFirstHalf", 
                     output_csv = "/data/Uncertainty/data/visuals/StimVidTestFirstHalf_luminance.csv", 
                     interval_seconds = 2, 
                     frame_rate = 7.5)


process_video_frames(frame_folder = "/data/Uncertainty/data/visuals/StimVidTestLastHalf", 
                     output_csv = "/data/Uncertainty/data/visuals/StimVidTestLastHalf_luminance.csv", 
                     interval_seconds = 2, 
                     frame_rate = 7.5)