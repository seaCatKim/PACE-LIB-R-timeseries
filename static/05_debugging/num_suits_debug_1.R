# This scripts estimates the probability distribution of the numbers of suits
# in a random draw of five poker cards.

cards <- rep(c("diamonds","clubs","spades","hearts"), 13)

for(i in 1:10000){
  
  # random draw of 5 cards
  s <- sample(cards, 5)
  
  # number of suits in this draw
  n <- length(s)
  
  # increment observation of n
  obs[n] <- obs[n] + 1
  
}

barplot(obs/sum(obs),
        main = "Number of suits in a random draw of 5 poker cards",
        xlab = "Number of suits",
        ylab = "Estimated probability",
        names.arg = 1:4)