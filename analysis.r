data <- read.csv("results.csv", header = TRUE)
summary(data)

# plotting with ggplot2

library(ggplot2)
cpp_points <- geom_point(data = data,
                         aes(x = vector_size, y = cpp_sorting_time_ms),
                         color = "blue")
python_points <- geom_point(data = data,
                            aes(x = vector_size, y = python_sorting_time_ms),
                            color = "red")

print(ggplot() + cpp_points + python_points)

# # plotting with plot

# plot(data$vector_size, data$python_sorting_time_ms, col = "red", main = "Paired Variables Plot",
#      xlab = "X Axis", ylab = "Y Axis")

# points(data$vector_size, data$cpp_sorting_time_ms, col = "blue")
