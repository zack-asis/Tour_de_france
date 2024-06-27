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

base_url <- "https://www.procyclingstats.com/race/tour-de-france/2023/stage"
num_stages = 2

tables_tables <- list()

for (i in 1:num_stages){
  url <- paste(base_url, i, sep = "-")
  # Read the HTML content from the URL
  webpage <- read_html(url)
  # Extract all tables from the webpage
  tables <- html_table(html_nodes(webpage, "table"), fill = TRUE)
  tables_tables[[i]] <- tables
}
# Specify the URL
# url <- "https://www.procyclingstats.com/race/tour-de-france/2023/stage-1"





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
