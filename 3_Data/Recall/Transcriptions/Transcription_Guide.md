---
output:
  pdf_document: default
  html_document: default
---
# Transcription Guide
### v2023.09.11

## General Premise: 
Participants in our study watched a murder mystery (episode 4 of the HBO series *The Undoing*) and, at the end unbeknownst to them while watching, were expected to recall everything that they could remember from the episode. We recorded this free recall data, which we'll eventually use in a project that Chelsea and I are working on, but there's cleaning that has to be done to it first. The data first has to be converted from speech to text and we have software to do that, but it's imperfect. What we need someone to do is to go through and check the speech-to-text results manually and create as accurate of an account as possible of what participants said. 

## Warning: 
This data must be secured at all times. Do not share it with unauthorized individuals or move it to any locations or devices beyond the directory it is currently contained within. Ask [Billy Mitchell](mailto:billy.mitchell@temple.edu) if you have any questions about this. 

## Relevant Materials:
Within the dropbox directory shared with you, [`Certainty_Predicting_Memory`](https://www.dropbox.com/scl/fo/4wo068j2b20ep8gmx04p9/h?rlkey=zgjem3yp8i7a55hc3uc78v19y&dl=0), is the **Transcriptions** directory. Almost everything that you need should be in there (including this guide). This contains the **Transcription_Tracker.xlsx** document and four additional directories: **Final**, **Otter**, **Whisper**, and **Recordings**. Both *Otter* and *Whisper* contain output from automated transcription, or speech-to-text, tools that you will check and correct as needed. *Recordings* contains the `.wav` files of participants recollections. *Final* will be where you will store the transcriptions that you generate. Additionally, the main directory, contains another directory named **stimuli** which contains video of the stimuli that we are using (`StimVidTestFirstHalf_comp.mp4`; `StimVidTestLastHalf_comp.mp4`) and a sheet providing general background of characters and setting (`background.pdf`).

## Goals:
There are two types of cases that you'll primarily be working and they depend upon when the data was collected. 

1. In the case of participants who had completed this study early, we have likely already processed their audio recordings with *Otter* and generated transcriptions for them with the help of another RA. These cases are indicated with a 'Yes' under the `Otter_Transcriptions` column of the **Transcription_Tracker.xlsx** document. 

2. In the case of participants who had completed this study late, we have also already processed their audio recordings, but instead using *Whisper*. These have ***NOT*** been reviewed by an RA yet. These cases are indicated with a 'No' under the `Otter_Transcriptions` column of the **Transcription_Tracker.xlsx** document.

In both cases, what we ultimately want is a single `.txt` file containing an accurate account of what participants recalled, but what this requires changes depending upon which case a recording falls into. 

## Timeline:
We hope to have all participants completed by October 13th, 2023. We will check in weekly. If we cannot meet this deadline, let Billy know as soon as possible. 

## Instructions:
1. Before reviewing any transcriptions or recordings, watch both stimuli (`StimVidTestFirstHalf_comp.mp4`; `StimVidTestLastHalf_comp.mp4`). A basic familiarity with the events, characters, and settings will help you understand what participants are recalling in these transcriptions.
2. Open the *Transcription_Tracker.xlsx* document and identify a recording which hasn't yet been completed (i.e., the `Final_Transcription` column for that participant says 'No')
3. Create a new `.txt` document using a text editor (e.g., *VSCode* is my preferred, but something like *Notepad*, *MS Word* also work). Save the blank `.txt` document in the *Final* directory using the four-digit Participant ID in the title (e.g., `Transcription_0000.txt`).
4. Open that participant's audio file from the *Recordings* directory. **Note:** Filenames for participants with leading 0 ID's may omit the leading 0s.

**If a participant has a 'Yes' in the `Otter_Transcriptions` column of the *Transcription_Tracker.xlsx* document**:

5. Open that participant's previously processed *Otter* file from the *Otter* directory (Should be formatted as `000_Completed.docx`). Also open that participant's raw *Whisper* file from the *Whisper* directory (Should be formatted as `0000_certainty_fr##.###.txt`). **Note**: You will likely primarily reference the *Otter* file; the *Whisper* file is for additional reference. Feel free to minimize it or bring it out only when you need it.
6. Copy the contents of the *Otter* transcription over to the new `.txt` document, ignoring timestamps, keywords or any other superfluous details from the *Otter* file. ***We only care about the audio transcription!***
7. Play the audio file while reading through the transcription:
    * If what is said in the recording matches what is written in the transcription, you do not have to do anything.
    * If what is said in the recording does not match what is written in the transcription and you are confident that you are correct, update the transcription.
    * If what is said in the recording does not match what is written in the transcription and you are not confident that you are correct, reference the *Whisper* transcription. 
        * If the *Whisper* recording increases your confidence, update the transcription accordingly (e.g., "...Hugh Grant's character then showed up at the husband's door..."). 
        * If the *Whisper* recording helps you get an idea of what was said, but you still are not confident, enter what you think is being said in brackets (e.g., "...Hugh Grant's character then [showed up at the] husband's door...").
        * If after consulting the *Whisper* recording you still cannot understand what was said at all, enter "[UNCLEAR]" (e.g., "...Hugh Grant's character then [UNCLEAR] husband's door...").
    * **Note**: Some recordings may be of such poor quality than any transcription is unlikely (0035 may be an example of this). In those cases, please try your best to capture what you can and note the difficulties in the *Transcription_Tracker.xlsx* document. 
    * **Note**: Try your best to capture long in-sentence pauses (using "...") and filler words (e.g., 'Umm', 'Ahh'). There is an extra degree of transcriber discernment or subjectivity in this aspect of the process, though, so don't overthink it much.  
    * **Note**: Though [UNCLEAR]'s may be inevitable in some cases, please try to use these sparingly. 

**If a participant has a 'No' in the `Otter_Transcriptions` column of the *Transcription_Tracker.xlsx* document**:

5. Open that participant's raw *Whisper* file from the *Whisper* directory (Should be formatted as `0000_certainty_fr##.###.txt`). This file has not been previously reviewed by an RA, and thus, should be subject to additional scrutiny in your review. **Note**: *Whisper* has a tendency to take a guess on words that it is unsure of, unlike *Otter*, which just will ignore audio it is unsure of. This also makes it more important to closely scrutinize *Whisper*'s output. 
6. Copy the contents of the *Whisper* transcription over to the new `.txt` document, ignoring any other superfluous details. ***We only care about the audio transcription!***
7. Play the audio file while reading through the transcription:
    * If what is said in the recording matches what is written in the transcription, you do not have to do anything.
    * If what is said in the recording does not match what is written in the transcription and you are confident that you are correct, update the transcription (e.g., "...Hugh Grant's character then showed up at the husband's door...").
    * If what is said in the recording does not match what is written in the transcription and you are not confident that what you think is being said is correct, enter what you think is being said in brackets (e.g., "...Hugh Grant's character then [showed up at the] husband's door...").
    * If what is said in the recording does not match what is written in the transcription and you are unsure what is being said, enter "[UNCLEAR]" (e.g., "...Hugh Grant's character then [UNCLEAR] husband's door...").
    * **Note**: Some recordings may be of such poor quality than any transcription is unlikely (0035 may be an example of this). In those cases, please try your best to capture what you can and note the difficulties in the *Transcription_Tracker.xlsx* document. 
    * **Note**: Try your best to capture long in-sentence pauses (using "...") and filler words (e.g., 'Umm', 'Ahh'). There is an extra degree of transcriber discernment or subjectivity in this aspect of the process, though, so don't overthink it much.  
    * **Note**: Though [UNCLEAR]'s may be inevitable in some cases, please try to use these sparingly. 

**For both Whisper- and Otter-transcribed participants**:

8. Once a recording has been thoroughly reviewed and updated, update the *Transcription_Tracker.xlsx* document to include: 
     * (a.) **How long they were speaking for (`Audio_Duration`)** - The duration of the recording in 00m 00s format; 
     * (b.) **Whether the file has severe issues (`Correction_Required`)** - If the file is so corrupted that you could not transcribe the majority of what was said, indicate as such here by marking 'Yes'; otherwise, put 'No'; 
     * (c.) **Whether the final transcription has been completed (`Final_Transcription`)** - Once you have finished someone, change this to 'Yes'; 
     * (d.) **Notes on any issues (`Notes`)** -For any information that you think might be relevant for us to know

## Contact:
If you have any questions or concerns, please contact Billy Mitchell at billy.mitchell@temple.edu