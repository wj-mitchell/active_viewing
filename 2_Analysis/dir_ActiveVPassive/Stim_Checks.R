# Dependencies
library(tidyverse)

# Reading in the data
df <- read.csv("C:/Users/Wjpmi/Dropbox/PC (2)/Documents/GitHub/Neuro_Uncertainty/3_Data/Qualtrics/qualtrics.csv",
               na.strings = "")[-c(1:2),] %>%
      select(c(PID, RateReflect, Difficulty, Engagement, Audio, Plot, InstrucCheck)) %>%
      filter(!grepl("^SR-999", PID) & !(PID %in% c("SR-5351", "SR-0756", "SR-1371", "SR-0035", "SR-6943"))) %>%
      mutate(
        Engagement = case_when(
          grepl("not at all", Engagement, ignore.case = TRUE) ~ 0,
          grepl("somewhat", Engagement, ignore.case = TRUE) ~ 1,
          grepl("moderately", Engagement, ignore.case = TRUE) ~ 2,
          grepl("very", Engagement, ignore.case = TRUE) ~ 3,
          grepl("extremely", Engagement, ignore.case = TRUE) ~ 4,
          TRUE ~ as.numeric(Engagement)  # In case there are numeric values
        ),
        Plot = case_when(
          grepl("not at all", Plot, ignore.case = TRUE) ~ 0,
          grepl("somewhat", Plot, ignore.case = TRUE) ~ 1,
          grepl("moderately", Plot, ignore.case = TRUE) ~ 2,
          grepl("very", Plot, ignore.case = TRUE) ~ 3,
          grepl("extremely", Plot, ignore.case = TRUE) ~ 4,
          TRUE ~ as.numeric(Plot)
        ),
        Audio = case_when(
          grepl("not at all", Audio, ignore.case = TRUE) ~ 0,
          grepl("somewhat", Audio, ignore.case = TRUE) ~ 1,
          grepl("moderately", Audio, ignore.case = TRUE) ~ 2,
          grepl("very", Audio, ignore.case = TRUE) ~ 3,
          grepl("extremely", Audio, ignore.case = TRUE) ~ 4,
          TRUE ~ as.numeric(Audio)
        ),
        RateReflect = case_when(
          grepl("never", RateReflect, ignore.case = TRUE) ~ 0,
          grepl("sometimes", RateReflect, ignore.case = TRUE) ~ 1,
          grepl("usually", RateReflect, ignore.case = TRUE) ~ 2,
          grepl("always", RateReflect, ignore.case = TRUE) ~ 3,
          TRUE ~ as.numeric(RateReflect)
        )
      )

# Running analyses
t.test(x = df$Engagement, mu = 0)
t.test(x = df$Plot, my = 0)
t.test(x = df$Audio, my = 0)

# Running our correlation
cor.test(df$Engagement[!is.na(df$Plot)], df$Plot[!is.na(df$Plot)])
