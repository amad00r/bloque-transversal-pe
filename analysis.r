data_vectors <- read.csv("results.csv", header = TRUE)

library(ggplot2)

summary(data_vectors)

print(ggplot() + 
      geom_point(data=data_vectors,
                 aes(x=vector_size, y=cpp_sorting_time_ms), 
                 color='blue') +
      geom_point(data=data_vectors, 
                 aes(x=vector_size, y=python_sorting_time_ms), 
                 color='red')
      + labs(y = "sorting_time_ms"))



plot(data_vectors$vector_size, data_vectors$python_sorting_time_ms, col = "red", main = "Paired Variables Plot",
     xlab = "X Axis", ylab = "Y Axis")

points(data_vectors$vector_size, data_vectors$cpp_sorting_time_ms, col = "blue")








plot(data_vectors$vector_size, data_vectors$python_sorting_time_ms, col = "red", main = "Datos emparejados y grupos seleccionados",
     xlab = "vector_size", ylab = "sorting_time_ms")

points(data_vectors$vector_size, data_vectors$cpp_sorting_time_ms, col = "blue")

abline(v = 0)
abline(v = 45000)
abline(v = 2^19 - 22500)
abline(v = 2^19 + 22500)
abline(v = 2^20 - 45000)
abline(v = 2^20)

legend("topleft", legend = c("C++", "Python"), col = c("blue", "red"), pch = 16, title = "Groups")





# demostrar tamaños de vectores uniformes (tal vez preguntar al profe???????????????????????????)
hist(data_vectors$vector_size, breaks = seq(2, 2^20 + 2^17, by = 2^17), xlim = c(2, 2^20), 
      main = "Histograma de vectores por tamaño", xlab = "Tamaño del vector", col = "royalblue4")



sorted_vector <- sort(data_vectors$vector_size)
plot(sorted_vector)
#vector_groups <- cut(sorted_vector, breaks = seq(2, 2^20 + 2^17, by = 2^17))
vectors_small <- subset(data_vectors, data_vectors$vector_size >= 2 & data_vectors$vector_size <= 45000)
vectors_big <- subset(data_vectors, data_vectors$vector_size >= 2^20 - 45000 & data_vectors$vector_size <= 2^20)
vectors_medium <- subset(data_vectors, data_vectors$vector_size >= 2^19 - 22500 & data_vectors$vector_size <= 2^19 + 22500)


n_small <- length(vectors_small$vector_size)
n_medium <- length(vectors_big$vector_size)
n_big <- length(vectors_medium$vector_size)




cpp_small_v_mean <- mean(vectors_small$cpp_sorting_time_ms)
python_small_mean <- mean(vectors_small$python_sorting_time_ms) 
small_mean_diff <- cpp_small_v_mean - python_small_mean

plot(vectors_small$vector_size, vectors_small$python_sorting_time_ms, col = "red", main = "Paired Variables Plot",
     xlab = "X Axis", ylab = "Y Axis")

points(vectors_small$vector_size, vectors_small$cpp_sorting_time_ms, col = "blue")

small_var <- var(vectors_small$cpp_sorting_time_ms - vectors_small$python_sorting_time_ms)
small_se <- sqrt(small_var)/sqrt(n_small)

small_confint = small_mean_diff + c(-small_se, small_se)*qt(1 - 0.05/2, n_small - 1)




###### SMALL

cpp_small_v_mean <- mean(vectors_small$cpp_sorting_time_ms)
cpp_small_sd <- sd(vectors_small$cpp_sorting_time_ms)

python_small_mean <- mean(vectors_small$python_sorting_time_ms) 
python_small_sd <- sd(vectors_small$python_sorting_time_ms)

small_sd_coefficient <- python_small_sd / cpp_small_sd 
small_mean_diff <- cpp_small_v_mean - python_small_mean

t.test(vectors_small$cpp_sorting_time_ms, vectors_small$python_sorting_time_ms, paired = TRUE)

small_var <- var(vectors_small$cpp_sorting_time_ms - vectors_small$python_sorting_time_ms)
sqrt(small_var)
small_se <- sqrt(small_var)/sqrt(n_small)

small_confint = small_mean_diff + c(-small_se, small_se)*qt(1 - 0.05/2, n_small - 1)


##### MEDIUM

cpp_medium_v_mean <- mean(vectors_medium$cpp_sorting_time_ms)
cpp_medium_sd <- sd(vectors_medium$cpp_sorting_time_ms)

python_medium_mean <- mean(vectors_medium$python_sorting_time_ms) 
python_medium_sd <- sd(vectors_medium$python_sorting_time_ms)

medium_sd_coefficient <- python_medium_sd / cpp_medium_sd
medium_mean_diff <- cpp_medium_v_mean - python_medium_mean

t.test(vectors_medium$cpp_sorting_time_ms, vectors_medium$python_sorting_time_ms, paired = TRUE)

medium_var <- var(vectors_medium$cpp_sorting_time_ms - vectors_medium$python_sorting_time_ms)
sqrt(medium_var)
medium_se <- sqrt(medium_var)/sqrt(n_medium)

medium_confint = medium_mean_diff + c(-medium_se, medium_se)*qt(1 - 0.05/2, n_medium - 1)

###### BIG

cpp_big_v_mean <- mean(vectors_big$cpp_sorting_time_ms)
cpp_big_sd <- sd(vectors_big$cpp_sorting_time_ms)

python_big_mean <- mean(vectors_big$python_sorting_time_ms) 
python_big_sd <- sd(vectors_big$python_sorting_time_ms)

big_sd_coefficient <- python_big_sd / cpp_big_sd
big_mean_diff <- cpp_big_v_mean - python_big_mean

t.test(vectors_big$cpp_sorting_time_ms, vectors_big$python_sorting_time_ms, paired = TRUE)

big_var <- var(vectors_big$cpp_sorting_time_ms - vectors_big$python_sorting_time_ms)
sqrt(big_var)
big_se <- sqrt(big_var)/sqrt(n_big)

big_confint = big_mean_diff + c(-big_se, big_se)*qt(1 - 0.05/2, n_big - 1)



par(mfrow = c(1, 1))

groups <- c(rep("small_group", 2), rep("medium_group", 2), rep("big_group", 2))
language <- rep(c("C++", "Python"), 3)
means <- c(cpp_small_v_mean, python_small_mean,
           cpp_medium_v_mean, python_medium_mean,
           cpp_big_v_mean, python_big_mean)

data_frame_means <- data.frame(groups, language, means)

data_frame_means$groups <- factor(data_frame_means$groups, 
                                  levels = c("small_group", "medium_group", "big_group"))

ggplot(data_frame_means, aes(fill=language, y=means, x=groups)) + 
       geom_bar(position="dodge", stat="identity")







######## REGRESIÓn lineal

par(mfrow = c(1, 1))

lmvectors_python <- lm(data_vectors$python_sorting_time_ms ~ data_vectors$vector_size)
lmvectors_cpp <- lm(data_vectors$cpp_sorting_time_ms ~ data_vectors$vector_size)

python_prediction <- function(vsize) {
  return(coef(lmvectors_python)[1] + coef(lmvectors_python)[2]*vsize)
}
cpp_prediction <- function(vsize) {
  return(coef(lmvectors_cpp)[1] + coef(lmvectors_cpp)[2]*vsize)
}



plot(data_vectors$vector_size, data_vectors$python_sorting_time_ms, col = "red", 
     main = "Muestras emparejadas con rectas ajustadas",
     xlab = "vector_size", ylab = "sorting_time_ms")
points(data_vectors$vector_size, data_vectors$cpp_sorting_time_ms, col = "blue")
abline(lmvectors_python, col = "green", lwd = 2)
abline(lmvectors_cpp, col = "green", lwd = 2)

legend("topleft", legend = c("C++", "Python"), col = c("blue", "red"), pch = 16, title = "Groups")

par(mfrow = c(1, 1))

plot(lmvectors_cpp)[1]
plot(lmvectors_python)



points(data_vectors$vector_size, data_vectors$cpp_sorting_time_ms, col = "blue")






###### residuals vs order

par(mfrow = c(1, 2))

tmp <- 1:length(data_vectors$cpp_sorting_time_ms)
lm_nuevo_cpp <- lm(data_vectors$cpp_sorting_time_ms ~ tmp)
res_cpp_nuevo <- residuals(lm_nuevo_cpp)
plot(tmp, res_cpp_nuevo, type = "l", xlab = "Order", ylab = "Residuals", main = "C++")

tmp <- 1:length(data_vectors$python_sorting_time_ms)
lm_nuevo_python <- lm(data_vectors$python_sorting_time_ms ~ tmp)
res_python_nuevo <- residuals(lm_nuevo_python)
plot(tmp, res_python_nuevo, type = "l", xlab = "Order", ylab = "Residuals", main = "Python")


par(mfrow = c(1, 3))

##### comprobación de las premisas para el cálculo de los intervalos de confianza
hist(vectors_small$cpp_sorting_time_ms,
     col = "blue", 
     main = "Histograma de tiempos de ordenación en small",
     xlab = "sorting_time", ylab = "frequency")
hist(vectors_medium$cpp_sorting_time_ms,
     col = "blue", 
     main = "Histograma de tiempos de ordenación en medium",
     xlab = "sorting_time", ylab = "frequency")
hist(vectors_big$cpp_sorting_time_ms,
     col = "blue", 
     main = "Histograma de tiempos de ordenación en big",
     xlab = "sorting_time", ylab = "frequency")

hist(vectors_small$python_sorting_time_ms,
     col = "red", 
     main = "Histograma de tiempos de ordenación en small",
     xlab = "sorting_time", ylab = "frequency")
hist(vectors_medium$python_sorting_time_ms,
     col = "red", 
     main = "Histograma de tiempos de ordenación en medium",
     xlab = "sorting_time", ylab = "frequency")
hist(vectors_big$python_sorting_time_ms,
     col = "red", 
     main = "Histograma de tiempos de ordenación en big",
     xlab = "sorting_time", ylab = "frequency")

hist(vectors_small$cpp_sorting_time_ms - vectors_small$python_sorting_time_ms,
     col = "royalblue4", 
     main = "Histograma de diferencias en small",
     xlab = "difference", ylab = "frequency")
hist(vectors_medium$cpp_sorting_time_ms - vectors_medium$python_sorting_time_ms,
     col = "royalblue4", 
     main = "Histograma de diferencias en medium",
     xlab = "difference", ylab = "frequency")
hist(vectors_big$cpp_sorting_time_ms - vectors_big$python_sorting_time_ms,
     col = "royalblue4", 
     main = "Histograma de diferencias en big",
     xlab = "difference", ylab = "frequency")


par(mfrow = c(1, 1))

hist(vectors_big$cpp_sorting_time_ms)

