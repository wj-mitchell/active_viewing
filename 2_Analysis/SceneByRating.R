# SceneByRating.R (formerly func_RatingCor.R)

#' @title SceneByRating
#'
#' @description Data Wrangling for rating data from the Social Regulation (i.e., 'Uncertainty') Project into summary statistics for each scene
#'
#' @param Data (string) filepath to a .csv file containing subject data to be wrangled
#' @param Condition (string) must take the value of 'A' or 'B'; used to filter subjects who rated different stimuli and thus have different SceneBreaks
#' @param SceneBreaks (array) an array of numeric values representing the boundaries of each scene; they will constitute the unit by which summary statistics are calculated
#' @param RunCor (boolean) if true, pairwise spearman-rank correlations will be calculated for each subject
#' @param Detrend (boolean) if true, ratings will be detrended such that only changes in ratings will be present rather than raw rating values
#' @param AbsVal (boolean) if true, rating absolute value will be used instead of a directional value
#' @param Summary (string) must take the value of 'sum' or 'mean'; represents the summary statistic we are seeking for each scene
#' 
#' @return (dataframe) a dataframe representing the data you requested
#'
#' @export
#'

RatingCor <- function(Data,
                       Condition,
                       SceneBreaks,
                       RunCor = F,
                       Detrend = F,
                       AbsVal = F,
                       Summary = "mean"){

# ----- PIVOTING DATAFRAMES INTO WIDE FORMAT -----

## If the pacman package manager is not currently installed on this system, install it.
if (require("pacman") == FALSE){
  install.packages("pacman")
}

## Loading in my packages with my pacman manager
pacman::p_load(reshape2,
               tidyverse)

# ----- CLEANING DATA FOR FIRST HALF RATERS

## Load the csv file in R as a dataframe
df_new <- read.csv(Data, 
                   row.names = 1) %>%
  
             ## selecting only participants who rated the first half
             subset(.$Conditionition == Condition) %>%
      
             ## selecting the desired/necessary columns for pivoting
             select('PID', 'CertRate','SecondEnd')

## Fixing a PID mistake
df_new$PID[df_new$PID == "SR-30461"] <- "SR-3046"

## pivot your dataframe with the 'pivot_wider' function and save it with a different name ('names_from': The column whose values will be used as names for the new columns (e.g: participant name), 'values_from': The column whose values will be used as cell values for the new columns (e.g: certainty ratings)). You should end up with a dataframe that has a total of 660 rows
df_new <- df_new %>%
          pivot_wider(names_from = PID, values_from = CertRate)

# ----- DETRENDING RATING DATA FROM THE PIVOTED TABLE -----

## Copy the pivoted dataframe to a new one
df <- df_new

## If we want detrended data
if (Detrend == T){
  
  ## Specify the columns containing participant data
  participant_columns <- which(names(df_new) != "SecondEnd")
   
  ## Iterate through each participant column...
  for (col in participant_columns) {
  
      ## Detrend the ratings using the 'mutate' and 'diff' columns. 
      ## (the 'c(0 ,...)' is used to add a row of 0s to the detrended dataframe so that you still have a total of 660 rows. 
      ## The 'mutate' and 'across(all_of ())' function essentially says that we are going to transform our data and then apply it to all of the specified columns, 
      ## The transformation we are applying is the 'c(0, diff(.))', aka, "detrending".    
      df <- df %>%
                         mutate(across(all_of(col), ~ c(0, diff(.))))
  }
}

## ---- Generating a scene-level dataframe ----

## Creating a variable to calculate how many scenes there are minus 1 for the zero that starts SceneBreaks off
Scenes <- length(SceneBreaks) - 1

## Creating a new empty dataframe to capture scene-level changes
df_scenelvl <- as.data.frame(matrix(data = NA, 
                                    nrow = Scenes, 
                                    ncol = ncol(df), 
                                    dimnames = list(1:Scenes, 
                                                    names(df))))

## Iterating through each scene and calculating the average absolute change
for (SCENE in 1:Scenes){
  
  ## Iterating through each participant too
  for (PID in 2:ncol(df)){
    
    ## Calculating the summary statistic  of every rating in column PID whose SecondEnd value is greater or equal to the time that this SCENE starts, but also less than the time that the next SCENE starts and copying that to the new dataframe in the column and row for that PID and SCENE respectively
    ## If we want absolute value and sum summary statistics 
    if (AbsVal == T & Summary == "sum") {
      df_scenelvl[SCENE,PID] <- which(df$SecondEnd >= SceneBreaks[SCENE] & df$SecondEnd < SceneBreaks[SCENE + 1]) %>%
                                df[., PID] %>%
                                abs() %>%
                                unlist() %>%
                                as.numeric() %>%
                                sum()
      
    ## If we want absolute value and sum summary statistics 
    } else if (AbsVal == T & Summary == "mean") {
      df_scenelvl[SCENE,PID] <- which(df$SecondEnd >= SceneBreaks[SCENE] & df$SecondEnd < SceneBreaks[SCENE + 1]) %>%
                                      df[., PID] %>%
                                      abs() %>%
                                      unlist() %>%
                                      as.numeric() %>%
                                      mean()
      
    ## If we want absolute value and sum summary statistics   
    } else if (AbsVal == F & Summary == "sum") {
      df_scenelvl[SCENE,PID] <- which(df$SecondEnd >= SceneBreaks[SCENE] & df$SecondEnd < SceneBreaks[SCENE + 1]) %>%
                                df[., PID] %>%
                                unlist() %>%
                                as.numeric() %>%
                                sum()
      
    ## If we want absolute value and sum summary statistics    
    } else if (AbsVal == F & Summary == "mean") {
      df_scenelvl[SCENE,PID] <- which(df$SecondEnd >= SceneBreaks[SCENE] & df$SecondEnd < SceneBreaks[SCENE + 1]) %>%
                                df[., PID] %>%
                                unlist() %>%
                                as.numeric() %>%
                                mean()
    }
  }
}

## Removing SecondEnd from the scene level dataframe
df_scenelvl <- df_scenelvl[,-which(names(df_scenelvl) == "SecondEnd")]

## If we don't want correlations ...
if (RunCor == F){
  return(as.data.frame(t(df_scenelvl)))  
}

## If we want correlations ...
if (RunCor == T){
  ## Constructing a correlation matrix
  df_cor <- cor(df_scenelvl,
                method = "spearman")
  # Convert the correlation matrix to a long format dataframe
  df_long <- melt(df_cor)
  
  # Name the columns for clarity
  names(df_long) <- c("PID_2", "PID_1", "Correlation")
  
  # Remove redundant pairs (upper triangle and diagonal)
  Delete_Rows <- NULL
  for (ROW in 1:nrow(df_long)){
    if (which(df_long$PID_1[ROW] == sort(names(df)[participant_columns])) >= which(df_long$PID_2[ROW] == sort(names(df)[participant_columns])))
      Delete_Rows <- c(Delete_Rows, ROW)
  }
  df_long <- df_long[-Delete_Rows,]
  
  return(df_long)  
}
}