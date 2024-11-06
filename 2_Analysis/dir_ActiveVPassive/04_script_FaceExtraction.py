# Before starting, do not forget to load the virtual environment by running
# source /data/Uncertainty/scripts/ProjPyEnv/bin/activate

import os
import face_recognition
import numpy as np
import pandas as pd
import sys

def face_extract(input_dir, output, TR = 2, framerate = 7.5):
        
    # Frame rate and TR details
    frames_per_tr = int(framerate * TR)

    # Initialize list to store presence of faces for each TR
    face_presence = []

    # Get the list of frame files sorted by name
    frame_files = sorted(os.listdir(input_dir))

    # Iterate through frames in batches of 15 (one TR)
    for i in range(0, len(frame_files), frames_per_tr):
       
        tr_contains_face = False

        # Check each frame in the current TR
        for j in range(i, min(i + frames_per_tr, len(frame_files))):

            frame_path = os.path.join(input_dir, frame_files[j])
            
            # Load the image
            image = face_recognition.load_image_file(frame_path)
            
            # Detect faces in the image
            face_locations = face_recognition.face_locations(image)
            
            # If faces are detected, mark the TR as containing a face
            if face_locations:
                tr_contains_face = True
                break

        # Append 1 if any frame in the TR contains a face, otherwise 0
        face_presence.append(1 if tr_contains_face else 0)

        # Print progress
        print(f"Completed processing {(i/len(frame_files)) * 100} % of TRs | {output}")

    # Convert to numpy array for further processing
    face_presence_array = np.array(face_presence)

    # Save the face_presence_array to a CSV file
    df = pd.DataFrame(face_presence_array, columns=["face_presence"])
    df.to_csv(output, index=False)

face_extract(input_dir = f"/data/Uncertainty/data/visuals/StimVidTest{sys.argv[1]}Half/",
               output = f"/data/Uncertainty/data/visuals/StimVidTest{sys.argv[1]}Half_faces.csv")