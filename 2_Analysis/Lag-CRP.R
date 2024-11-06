#===={Finding all lags for Lag-CRP}====
# Copy the dataframe with all the scenes for each PID recalled
 df_lag <- df_recall

 df_lag <- df_lag[-69, ]

# Add the Lag column
 df_lag <- df_lag %>%
     group_by(PID) %>%
     mutate(Lag = Scenes - lag(Scenes))
 
# Replace NA with "n/a"
  df_lag$Lag[is.na(df_lag$Lag)] <- "n/a"


#===={Making an empty df}====

 PIDs <- unique(df_lag$PID)
 
# Specifying the names of rows and columns in the new dataframe
 cols <- c("PID", "PossibleLag", "ActualLag")
 rows <- 1:((length(PIDs)) * 69) #"69" is so that you have PID rows for each possible lag from -34 to +34 since there are a total of 35 scenes in the video
 
# Creating  the new dataframe
 df_lag_wide <- as.data.frame(matrix(NA, 
                                        nrow = length(rows), 
                                        ncol =  length(cols),
                                        dimnames = list(rows,
                                                        cols)))
 
# Cleaning space
 rm(cols,rows)


#===={Filling in Constant Information (i.e., PID and PossibleLag)}====

# Make a variable for all possible lags -34 to +34
 LAGs <- paste(-34:34, collapse = ", ")

# Repeating each of the unique PIDs a number of times equivalent to the number of possible lags there are and sorting them alphanumerically
 df_lag_wide$PID <- PIDs %>%
     rep(., 69) %>%
     sort()

# Repeating the numbers 1 through 35 a number of times equivalent to the number of unique PIDs there are
 df_lag_wide$PossibleLag <- LAGs %>%
     length() %>%
     rep(-34:34, .)


#===={Filling in Recall Data}====
# Make all data equal to 0
 df_lag_wide$ActualLag <- 0

# Iterate through every PID
for (PID in PIDs){
    
    # Iterate through every scene
    for (LAG in unique(df_lag_wide$PossibleLag)){
        
        # If any PID / Scene combo is present in the original dataframe
        if (any(df_lag$PID == PID & df_lag$Lag == LAG)){
            
            # Then find that PID / Scene Combo in the new dataframe and change the 0 to a 1
            df_lag_wide$ActualLag[df_lag_wide$PID == PID & df_lag_wide$PossibleLag == LAG] <- 1
        }
    }
}


#===={Pivoting the Dataframe to Wider Format}====
# Patching up the PID variable names (Can't have variable names that start with numbers)
df_lag_wide$PID <- paste0("SR-", sprintf("%04d", as.integer(df_lag_wide$PID)))
PIDs <- paste0("SR-", sprintf("%04d", PIDs))

# Pivoting to a wider format
df_lag_wide <- pivot_wider(df_lag_wide,
                              names_from = PID,
                              values_from = ActualLag)


#===={Calculating the Average}====

df_lag_wide$GroupAvg <- rowMeans(df_lag_wide[,2:ncol(df_lag_wide)], na.rm = T)

#Delete the row containing "0" in PossibleLag (should not exist)
 df_lag_wide <- df_lag_wide[-35, ]

#===={Plotting the data}====
plot(df_lag_wide$PossibleLag, df_lag_wide$GroupAvg, type = "l")