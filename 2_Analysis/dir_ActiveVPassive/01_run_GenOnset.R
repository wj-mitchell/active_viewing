## Libraries
pacman::p_load(here, tidyverse)

# Loading the custom cleaning function
source("https://raw.githubusercontent.com/wj-mitchell/neuRotools/main/rucleaner.R", local= T)

# Noting the index number of all .csv files in the directory
dir <- paste0(here(), "/../data/behav/")
files <- list.files(path = dir, 
                    full.names = F) %>%
         .[grep(pattern = "*\\.csv",
              x = .)]

# Iterating through sequential integers up to the total number of .csvs
# Taking this approach rather than using the index numbers directly makes
# this code robust to any ordering changes that might occur in the files.
# (i.e., if the .csv files were listed after the .txts for some reason,
# the conditional statements binding the data together would get confused)
for (INDEX in 1:length(files)) {
  
  # Running the cleaner function for an individual file within the noted directory
  df_temp <- rucleaner(file = files[INDEX],
                       dir = dir,
                       unit_secs = NA,
                       shave_secs = 0)
  
  # if this is the first file we're cleaning . . .
  if (INDEX == 1) {
    
    # Make it the master dataframe
    df <- df_temp
    
    # Remove the temporary dataframe
    rm(df_temp)
    
  }
  
  # If this is not the first file we're cleaning . . .
  if (INDEX != 1) {
    
    # Append it to the end of the master dataframe
    df <- rbind(df, df_temp)
    
    # Remove the temporary dataframe
    rm(df_temp)
    
  }
  
}

# Coercing the stucture of my data into a numeric format
df$CertRate <- df$CertRate %>% as.numeric()

# Creating a function to clean the data into subsets
subsetter <- function(data = ., condition){

  # Return these values
  return( 
    
    # Subset data from select columns that is not from the control video and comes from the specified condition
   subset(data, 
           data$Video != "StimVidControl.mp4" & data$Video != "StimVidControl_Undoing.mp4" & data$Condition == condition, 
           select = c(PID, CertRate, Seconds)) %>%
      
    # Group this data by PID
    group_by(PID) %>%
      
    # Sort this data by PID and time
    arrange(PID, Seconds) %>% 
      
    # Calculate changes in certainty rating and prepend 0 for the first row to keep the length of the column equal
    mutate(Change = c(0, diff(CertRate))) %>% 
      
    # Identify all finger button presses, based upon rating changes, within a given two second interval
    mutate(ButtonPress = if_else(abs(Change) == 5, 1, 0), Interval = floor(Seconds / 2) * 2) %>%  
      
    # Group the data by Intervals
    group_by(PID, Interval) %>%  
      
    # Count the number of button presses for each interval.
    summarize(TotalButtonPresses = sum(ButtonPress), .groups = 'drop')
  )
}

# Creating a function to write the data into text files
file_writer <- function(data = ., condition){
  
  # Iterating through each unique PID present in the dataframe
  for (PID in unique(data$PID)){
    
    # Subset out this specific subjects observations
    df_ <- data[data$PID == PID,]
    
    # Searching for a specific case of a subject ID being entered incorrectly and correcting it
    if (PID == "SR-30461"){
      df_$PID <- "SR-3046"
      PID <- "SR-3046"
    }
    
    # Add a constant for the duration
    df_$Dur <- 2
    
    # Reorder the columns
    df_ <- subset(df_,select = c("Interval", "Dur", "TotalButtonPresses"))

    # If the subject ID is one of the following
    if (PID %in% c("SR-0035", "SR-4590", "SR-6943", "SR-6799", "SR-6977", "SR-8746", "SR-5006")){
      
      # Add 90 seconds to the interval to represent when the stimulus starts (following fixation, visual baseline)
      df_$Interval <- df_$Interval + 90
    }
    
    # If the subject ID is one of the others
    if (!(PID %in% c("SR-0035", "SR-4590", "SR-6943", "SR-6799", "SR-6977", "SR-8746", "SR-5006"))){
      
      # Add 60 seconds to the interval to represent when the stimulus starts (following fixation, visual baseline)
      df_$Interval <- df_$Interval + 60
    }
    
    # Function to identify groups of consecutive even intervals
    get_consecutive_groups <- function(interval){
      cumsum(c(TRUE,diff(interval) != 2))
    }
    
    # Creating event files based upon parametric modulator
    df_rating <- df_ %>%
                 subset(.$TotalButtonPresses > 0) %>%
                 mutate(TotalButtonPresses = 1) %>%
                 mutate(group = get_consecutive_groups(Interval)) %>%
                 group_by(group) %>%
                 summarize(Interval = first(Interval),
                           Dur = sum(Dur),
                           Parametric = 1) %>%
                 select(-group)
    
    # Creating event files based upon parametric modulator
    df_notrating <- df_ %>%
                    subset(.$TotalButtonPresses == 0) %>%
                    mutate(TotalButtonPresses = 1) %>%
                    mutate(group = get_consecutive_groups(Interval)) %>%
                    group_by(group) %>%
                    summarize(Interval = first(Interval),
                              Dur = sum(Dur),
                              Parametric = 1) %>%
                    select(-group)
    
    # Creating an onset file for the not rated video
    df_othervideo <- df_ %>%
                      mutate(group = get_consecutive_groups(Interval)) %>%
                      group_by(group) %>%
                      summarize(Interval = first(Interval),
                                Dur = sum(Dur),
                                Parametric = 1) %>%
                      select(-group)  
    
    # Z standardize the entire time course of ratings within subject
    df_$TotalButtonPresses <- scale(df_$TotalButtonPresses) %>% as.numeric()
    
    # If this is condition A
    if (condition =="A"){
      
      # Writing the first run worth of data 
      df_ %>%
        write.table(., paste0(here(), "/../data/deriv/pipeline_1/fmriprep/sub-",
                              str_extract(PID, pattern = "....$"),"/onset/sub-",
                              str_extract(PID, pattern = "....$"),
                              "_task-Run1_paramod.txt"),
                    sep = "\t", col.names = F, row.names = F)
      
      df_rating %>%
        write.table(., paste0(here(), "/../data/deriv/pipeline_1/fmriprep/sub-",
                              str_extract(PID, pattern = "....$"),"/onset/sub-",
                              str_extract(PID, pattern = "....$"),
                              "_task-Run1_rating.txt"),
                    sep = "\t", col.names = F, row.names = F)
      
      df_notrating %>%
        write.table(., paste0(here(), "/../data/deriv/pipeline_1/fmriprep/sub-",
                              str_extract(PID, pattern = "....$"),"/onset/sub-",
                              str_extract(PID, pattern = "....$"),
                              "_task-Run1_notrating.txt"),
                    sep = "\t", col.names = F, row.names = F)
      
      df_othervideo %>%
        write.table(., paste0(here(), "/../data/deriv/pipeline_1/fmriprep/sub-",
                              str_extract(PID, pattern = "....$"),"/onset/sub-",
                              str_extract(PID, pattern = "....$"),
                              "_task-Run2_notrating.txt"),
                    sep = "\t", col.names = F, row.names = F)
    }
    
    # If this is condition B
    if (condition =="B"){
      
      # Writing the first run worth of data 
      df_ %>%
        write.table(., paste0(here(), "/../data/deriv/pipeline_1/fmriprep/sub-",
                              str_extract(PID, pattern = "....$"),"/onset/sub-",
                              str_extract(PID, pattern = "....$"),
                              "_task-Run2_paramod.txt"),
                    sep = "\t", col.names = F, row.names = F)
      
      df_rating %>%
        write.table(., paste0(here(), "/../data/deriv/pipeline_1/fmriprep/sub-",
                              str_extract(PID, pattern = "....$"),"/onset/sub-",
                              str_extract(PID, pattern = "....$"),
                              "_task-Run2_rating.txt"),
                    sep = "\t", col.names = F, row.names = F)
      
      df_notrating %>%
        write.table(., paste0(here(), "/../data/deriv/pipeline_1/fmriprep/sub-",
                              str_extract(PID, pattern = "....$"),"/onset/sub-",
                              str_extract(PID, pattern = "....$"),
                              "_task-Run2_notrating.txt"),
                    sep = "\t", col.names = F, row.names = F)
      
      df_othervideo %>%
        write.table(., paste0(here(), "/../data/deriv/pipeline_1/fmriprep/sub-",
                              str_extract(PID, pattern = "....$"),"/onset/sub-",
                              str_extract(PID, pattern = "....$"),
                              "_task-Run1_notrating.txt"),
                    sep = "\t", col.names = F, row.names = F)
      
    }
    
    
    
  }
}

## Creating a dataframe of only first half raters
subsetter(data = df, condition = "A") %>%
file_writer(condition = "A")

## Creating a dataframe of only second half raters 
subsetter(data = df, condition = "B") %>%
file_writer(condition = "B")
