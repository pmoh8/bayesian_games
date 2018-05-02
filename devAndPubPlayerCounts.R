

## get the dataset.all.Rdata file from https://github.com/trnenym/GamesPred/tree/master/DataProcess/Datasets

load(file="dataset.all.RData")

completeFun <- function(data, desiredCols) {
  completeVec <- complete.cases(data[, desiredCols])
  return(data[completeVec, ])
}

df <- completeFun(dataset.all, "Players")

#2012, 6, 29 is earliest date

df$DaysPassed = (df$Year-2012)*365+(df$Month-6)*31+(df$Day-27)

df$devPriorCount = sum(df$Players[df$Developer==df$Developer ])
df$pubPriorCount = 5

for (row in 1:nrow(df)) {
  dev <- df[row, "Developer"]
  pub <- df[row,"Publisher"]
  id <- df[row,"ID"]
  days  <- df[row, "DaysPassed"]
  df[row,"devPriorCount"] = sum(df$Players[which(df$Developer==dev & df$DaysPassed <= days & df$ID != id)])
  df[row,"pubPriorCount"] = sum(df$Players[which(df$Publisher==pub & df$DaysPassed <= days & df$ID != id)])
}

developerAndPublisherPriorPlayerCounts = subset(df, select = c(ID,devPriorCount,pubPriorCount,DaysPassed))

steam = read.csv(file="steamwithscore.csv")

steam = merge(steam,developerAndPublisherPriorPlayerCounts,by="ID")

write.csv(steam,file="steam.csv")