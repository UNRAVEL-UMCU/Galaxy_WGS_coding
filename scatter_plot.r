library(readr)
library(ggplot2)
library(dplyr)

# Input data in csv format
ao_dp_data <- read_csv("input.csv")

# Check column names and structure of the data
print(names(ao_dp_data))
print(head(ao_dp_data))

# Removing any potential whitespace from column names
names(ao_dp_data) <- trimws(names(ao_dp_data))

# Convert columns to numeric if not already
ao_dp_data$AO_Percentage <- as.numeric(ao_dp_data$AO_Percentage)
ao_dp_data$DP <- as.numeric(ao_dp_data$DP)

# Calculate Spearman's rank correlation
spearman_result <- cor.test(ao_dp_data$AO_Percentage, ao_dp_data$DP, method = "spearman")

# Print the correlation result, but not saved 
print(spearman_result)

# Create the scatter plot with the cleaned data using tryCatch for error handling
plot_ao_dp <- tryCatch({
    ggplot(ao_dp_data, aes(x = AO_Percentage, y = DP)) +
      geom_point(size = 0.1, show.legend = FALSE) +
      xlim(0, 100) + # Set the limits of the x-axis
      ylim(0, max(ao_dp_data$DP, na.rm = TRUE)) + # Set the limits of the y-axis dynamically
      ggtitle("") +
      labs(x = "Percentage of reads supporting the observed allele (AO)", y = "Read depth (DP)") +
      theme_minimal() +
      theme(
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_line(size = 1), # Apply bold lines to x and y axis only
        axis.line.x = element_line(size = 1, color = "black"), # Bold and black line for x-axis
        axis.line.y = element_line(size = 1, color = "black"), # Bold and black line for y-axis
        panel.background = element_rect(fill = 'transparent', color = NA), # Set transparent panel background
        plot.background = element_rect(fill = 'white', color = NA) # Set white plot background
      )
}, error = function(e) {
    print(e)
    NULL # Return NULL if an error occurs, otherwise the plot object will be returned
})

# Check if the plot object was created
if (!is.null(plot_ao_dp)) {
    # Display the plot
    print(plot_ao_dp)

    # Save the plot in a desired format, png or pdf
    ggsave("plot.png", plot_ao_dp, width = 250, height = 150, units = "mm")
} else {
    print("An error occurred in plot creation.")
}
