#############################

# Load the necessary package
library(rvest)

# Specify the URL
url <- "https://www.procyclingstats.com/race/tour-de-france/2023/stage-1"

# Read the HTML content from the URL
webpage <- read_html(url)

# Extract all tables from the webpage
tables <- html_table(html_nodes(webpage, "table"), fill = TRUE)

# Extract all list items within the specified <ul> element
list_items <- html_nodes(webpage, "ul.infolist li")

# Initialize an empty list to store the extracted data
extracted_data <- list()

# Loop through each list item and extract the data
for (item in list_items) {
  # Extract the key and value
  key <- html_text(html_node(item, "div:nth-child(1)"))
  value <- html_text(html_node(item, "div:nth-child(2)"))
  
  # Append to the list
  extracted_data[[key]] <- value
}

# Convert the list to a data frame
stage_info <- as.data.frame(t(unlist(extracted_data)), stringsAsFactors = FALSE)

# Print the extracted data
print(stage_info)

# Select the first table (or the specific table you need)
stage <- tables[[1]]
gc <- tables[[2]]
points_general <- tables[[3]]
points_today_sprint <- tables[[4]]
points_today_finish <- tables[[5]]
kom_general <- tables[[6]]
kom_today_ <- tables[[6]]
youth <- tables[[5]]
team <- tables[[6]]

# Display the extracted table
print(head(table1))


#############################
# Load the necessary package
library(rvest)
library(stringr)
library(lubridate)
library(tidyverse)

#############  -- Functions --  ###############

# Function to remove the suffix - used for bonus time
remove_suffix <- function(main_string, suffix_string) {
  # Check if the suffix_string is at the end of main_string
  if (endsWith(main_string, suffix_string)) {
    # Remove the suffix from the main_string
    main_string <- substring(main_string, 1, nchar(main_string) - nchar(suffix_string))
  }
  return(main_string)
}

############ -- Main -- #########################


base_url <- "https://www.procyclingstats.com/race/tour-de-france/2023/stage"
num_stages = 21


full_results <- list()
stage_info <- list()

for (i in 1:num_stages){
  url <- paste(base_url, i, sep = "-")
  # Read the HTML content from the URL
  webpage <- read_html(url)
  # Extract all tables from the webpage
  tables <- html_table(html_nodes(webpage, "table"), fill = TRUE)
  full_results[[i]] <- tables
  
  info <- list() #create empty list to store the info in 
  # Extract all list items within the specified <ul> element
  list_items <- html_nodes(webpage, "ul.infolist li")
  
  
  # Loop through each list item and extract the data
  for (item in list_items) {
    # Extract the key and value
    key <- html_text(html_node(item, "div:nth-child(1)"))
    value <- html_text(html_node(item, "div:nth-child(2)"))
    
    # Append to the list
    info[[key]] <- value
  }
  stage_info[[i]] <- info
}

stage_results <- list()
for (i in 1:num_stages){
  stage_results[[i]] <- data.frame("Rank" = as.integer(full_results[[i]][[1]][[1]]),"Rider" = full_results[[i]][[1]][[7]],"Time" = full_results[[i]][[1]][[13]],
                                   "Bonus" = full_results[[i]][[1]][[12]],"Timelag" = full_results[[i]][[1]][[3]])
}

# determine the leader's time in each stage so we can use that to get everyone's time
for (i in 1:num_stages){
  
  lead_time <-  stage_results[[i]]$Time[[1]] # need to keep it as a string to take off the suffix
  
  if (!is.na (stage_results[[i]]$Bonus[[1]])){          # if there's bonus time - fix the format in the Time column
    lead_time<-remove_suffix(stage_results[[i]]$Time[[1]], stage_results[[i]]$Bonus[[1]])
  }
  
  lead_time <- hms(lead_time)
  
  # now we make a new column for the fixed time
  stage_results[[i]] <- stage_results[[i]] %>%
    mutate("Time_fixed" = lead_time+ms(Timelag)) # need to change the data type of timelag)
  
  # median(stage_results[[1]]$Time_fixed, na.rm = TRUE)
}


# Add a column to indicate the source dataframe
stage_results <- lapply(seq_along(stage_results), function(i) {
  stage_results[[i]] %>%
    mutate(Stage =  i)
})

# Bind all dataframes into one
results <- bind_rows(stage_results)

# Print the combined dataframe
print(results)

##### plotting

line_results <- ggplot(data=results, aes(x=Stage, y=Time_fixed, group=Rider)) +
  geom_line()+
  geom_point()
plot(line_results)
# need to do some filtering and stuff but this is a good start

  
  ##################### Example Code ################

# ######## Geting specific chars from a string

# install.packages("stringr")
# library(stringr)
# 
# # Example string
# string <- "Hello"
# 
# # Get the last character
# last_char <- str_sub(string, -1, -1)
# print(last_char)


# ########### Function to remove the suffix

# remove_suffix <- function(main_string, suffix_string) {
#   # Check if the suffix_string is at the end of main_string
#   if (endsWith(main_string, suffix_string)) {
#     # Remove the suffix from the main_string
#     main_string <- substring(main_string, 1, nchar(main_string) - nchar(suffix_string))
#   }
#   return(main_string)
# }
# 
# # Call the function
# result <- remove_suffix(main_string, suffix_string)
# print(result)  # Output: "Hello"
  


# ############### histogram of time

# t_hist_mo <- ggplot(data=full_data, aes(x=ride_time, fill=member_casual)) + 
#   geom_histogram(binwidth=3000, position="dodge")+
#   scale_y_continuous(trans='log10')+ #use log scale to see the lower counts easier
#   labs(x = "Ride Duration (s)", y = "Count (log)", title = "Number of rides per duration")+
#   facet_wrap(~month(started_at))
# plot(t_hist_mo)


########## List into one dataframe

# # Load necessary library
# library(dplyr)
# 
# # Sample dataframes
# df1 <- data.frame(A = 1:3, B = 4:6)
# df2 <- data.frame(A = 7:9, B = 10:12)
# df3 <- data.frame(A = 13:15, B = 16:18)
# df4 <- data.frame(A = 19:21, B = 22:24)
# df5 <- data.frame(A = 25:27, B = 28:30)
# 
# # List of dataframes
# df_list <- list(df1, df2, df3, df4, df5)
# 
# # Add a column to indicate the source dataframe
# df_list <- lapply(seq_along(df_list), function(i) {
#   df_list[[i]] %>%
#     mutate(Source = paste0("df", i))
# })
# 
# # Bind all dataframes into one
# combined_df <- bind_rows(df_list)
# 
# # Print the combined dataframe
# print(combined_df)