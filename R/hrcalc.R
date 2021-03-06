library(JADE)

hrcalc <- function(heartRateData)
{
  totalRecords <- (sum(lengths(heartRateData[1])))
  time <- 15/1000

  frameRate <- totalRecords/time

  S <- cbind(heartRateData$red, heartRateData$green, heartRateData$blue)
  A <- matrix(rnorm(16), ncol=3)
  X <- S %*% t(A)

  res<-JADE(X,3)

  ica1 <- res$S[,1]
  ica2 <- res$S[,2]
  ica3 <- res$S[,3]

  ica1_fft <- fft(ica1)
  ica2_fft <- fft(ica2)
  ica3_fft <- fft(ica3)

  pwr1 <- sqrt(Re(ica1_fft)^2+Im(ica1_fft)^2)
  pwr2 <- sqrt(Re(ica2_fft)^2+Im(ica2_fft)^2)
  pwr3 <- sqrt(Re(ica3_fft)^2+Im(ica3_fft)^2)

  #only take half of the values leaving off first record
  pwr1 <- pwr1[1:(totalRecords/2)]
  pwr2 <- pwr2[1:(totalRecords/2)]
  pwr3 <- pwr3[1:(totalRecords/2)]

  bpm1 <- max(pwr1)
  bpm2 <- max(pwr2)
  bpm3 <- max(pwr3)

  freq <- frameRate/2 * seq(0,1,length=totalRecords/2+1)
  lowHz <- 0.75/(frameRate/2)
  lowHzIndex <- which(freq < lowHz)
  lowHzIndex <- lowHzIndex[(length(lowHzIndex))] + 1
  highHz <- 4/(frameRate/2)
  highHzIndex <- which(freq > highHz)
  highHzIndex <- highHzIndex[1] - 1

  hr1 <- max(pwr1[lowHzIndex:highHzIndex])
  hr2 <- max(pwr2[lowHzIndex:highHzIndex])
  hr3 <- max(pwr3[lowHzIndex:highHzIndex])

  return(c(hr1, hr2, hr3))
}
