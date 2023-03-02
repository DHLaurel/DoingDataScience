library(tidyverse) # merge
library(ggplot2)
library(ggpmisc)
library(ggthemes)
library(mice) # multi-variate imputation
library(class) # knn
library(caret) # confusion matrix

# 3.

# breweries_file = file.choose()
# beer_file = file.choose()
mj_file = file.choose()
# brew_dat = read.csv(breweries_file)
beer_dat = read.csv(beer_file)
mj_dat = read.csv(mj_file)

beer_brews = merge(x = brew_dat, y = beer_dat, by.x = "Brew_ID", by.y = "Brewery_id")
colnames(beer_brews)[colnames(beer_brews) == "Name.x"] <- "Brew_Name"
colnames(beer_brews)[colnames(beer_brews) == "Name.y"] <- "Beer_Name"

beer_brews$State <- trimws(beer_brews$State) # States have extra whitespace, unnecessary

beer_brews[!complete.cases(beer_brews),]

ggplot(beer_brews[complete.cases(beer_brews),], aes(x = ABV, y = IBU)) +
  geom_point(position = "jitter") +
  geom_smooth(method='lm')

summary(beer_brews[,c("ABV", "IBU")])
cor(beer_brews$ABV, beer_brews$IBU, use = "complete.obs") # 0.67 correlation between ABV and IBU, good predictor for multi-imputation, mice

md.pattern(beer_brews) # Data is missing only from ABV and IBU columns

beer_brew_whole <- beer_brews
mice(beer_brew_whole, method="pmm")

beer_brew_whole$ABV <- complete(mice(beer_brew_whole, method="pmm"))$ABV # Use predictive mean imputation for now, fill in just ABV rows (fewer) before IBU
beer_brew_whole$IBU <- complete(mice(beer_brew_whole, method="pmm"))$IBU 

beer_brew_whole[!complete.cases(beer_brew_whole),] #No more missing rows
summary(beer_brew_whole[,c("ABV","IBU")])

# 5.
# We can pick the blind maximum, but might be more interesting to take 5 maximum states and compare density distributions
# Find 5 max ABV beers
beer_brew_abv = beer_brews
beer_brew_abv = beer_brew_abv[!(is.na(beer_brew_abv$ABV)),]
beer_brew_abv[order(beer_brew_abv$ABV, decreasing = TRUE )[1:6],] # CO, KY, IN, _CO_, NY, MI

hi_abv = beer_brew_abv[beer_brew_abv$State %in% c("CO", "MI", "KY", "IN", "NY"),]

ggplot(data = hi_abv, aes(x = ABV * 100, fill = State, linetype = (State != "CO"), color = (State != "CO"))) +
  geom_density(alpha = 0.3, position="identity") +
    labs(x = "Alcohol By Volume (%)", y = "Density", title="Density of High-ABV Beers by State") +
  guides(color = "none", linetype = "none") +
  theme_wsj()+
  theme(axis.title=element_text(size=12))

# From the above, Colorado has the single highest ABV beer, "Lee Hill Series Vol. 5 - Belgian Style Quadrupel Ale", but Kentucky appears to have a much greater
# concentration of beers at the high-ABV end

# Do the same for IBU
beer_brew_ibu = beer_brews
beer_brew_ibu = beer_brew_ibu[!(is.na(beer_brew_ibu$IBU)),]
beer_brew_ibu[order(beer_brew_ibu$IBU, decreasing = TRUE )[1:6],] # OR, VA, MA, IL, MI

hi_ibu = beer_brew_complete[beer_brew_complete$State %in% c("OR", "VA", "MA", "OH", "MN"),]

ggplot(data = hi_ibu, aes(x = IBU, fill = State, linetype = (State != "OR"), color = (State != "OR"))) +
  geom_density(alpha = 0.3, position="identity") +
  labs(x = "International Bitterness Units (IBU)", y = "Density", title="Density of High-IBU Beers by State") +
  guides(color = "none", linetype = "none") +
  theme_wsj()+
  theme(axis.title=element_text(size=12))


# 7.
summary(beer_brews[,c("ABV", "IBU")])
cor(beer_brew_whole$ABV, beer_brew_whole$IBU) # 0.66037, down from before values were imputed

ggplot(beer_brew_whole, aes(x = ABV, y = IBU)) +
  geom_point(position = "jitter") +
  geom_smooth(method='lm') +
  labs(x = "ABV", y = "IBU", title = "IBU vs. ABV in American Beers", subtitle = "Correlation = 0.66037" ) +
  theme_wsj()   +
  theme(axis.title=element_text(size=12))

# 8.
pick_k <- function(trainData, testData, trainColumns, testColumn, kUpper){
  cl <- trainData[,testColumn]
  kTest = testData[,trainColumns]
  k_frame <- data.frame(matrix(ncol = 2, nrow = 0))
  colnames(k_frame) = c("KVal", "Accuracy")
  for (k in 1:kUpper)
  {
    predicted <- knn(trainData[,trainColumns], kTest, cl, k)
    num_incorrect <- sum(predicted != testData[,testColumn])
    miss_rate <- num_incorrect / nrow(testData)
    accuracy = 1 - miss_rate
    k_frame[nrow(k_frame) + 1,] <- c(k, accuracy)
    #print(paste('k: ', k, ', miss_rate: ', miss_rate))
  }
  [order(k_frame$Accuracy, decreasing = TRUE )[1],][[1]]
  k = k_frame
  k
}
bb_ales <- beer_brew_whole[grepl("Ale", beer_brew_whole$Style, ignore.case = TRUE) | grepl("IPA", beer_brew_whole$Style, ignore.case=TRUE), ]
bb_ales <- bb_ales[!grepl("Lager", bb_ales$Style, ignore.case=TRUE),]

bb_ales$IsIPA <- grepl("IPA", bb_ales$Style, ignore.case=TRUE)

k_index = sample(seq(1:nrow(bb_ales)),round(0.7*nrow(bb_ales)))

bb_train = bb_ales[k_index,]
bb_test = bb_ales[-k_index,]
# k = pick_k(bb_train, bb_test, c("IBU", "ABV"), "IsIPA", nrow(bb_test)) # __7__
cl <- bb_train[,"IsIPA"]
truth <- as.factor(bb_test$IsIPA)

pred = knn(bb_train[,c("IBU", "ABV")], bb_test[,c("IBU", "ABV")], cl, k)
table(predicted = pred, true = truth)

knn(bb_train[,c("IBU", "ABV")], bb_test[,c("IBU", "ABV")], cl, k, prob=TRUE)

bb_ales$IsIPA[bb_ales$IsIPA == TRUE] <- "IPA" 
bb_ales$IsIPA[bb_ales$IsIPA == FALSE] <- "Not an IPA" 

ggplot(bb_ales, aes(x = IBU, y = ABV * 100.0, color = IsIPA)) +
  geom_point(position = "jitter", alpha = 0.7) +
  labs(title = "IPA prediction by ABV and IBU", color = "", y = "ABV (%)") +
  theme_wsj()   +
  theme(axis.title=element_text(size=12)) +
  xlim(0, 150) + ylim(2,10)

confusionMatrix(pred, truth)


# 9.
# Any correlation between ounces and abv?

ggplot(beer_brew_whole, aes(y=ABV * 100.0, x=as.factor(Ounces))) +
  geom_point(position = "jitter", alpha=0.7)

# Any correlation between high abv states and marijuana legalization? "Party States" 
mj_dat$State <- state.abb[match(mj_dat$State, state.name)]
mj_dat$State[is.na(mj_dat$State)] <- "DC"

mj_beers <- beer_brew_whole
mj_beers <- reduce(list(mj_beers, mj_dat), full_join, by='State')
names(mj_beers)[names(mj_beers) == 'Status'] <- 'MarijuanaStatus'

ggplot(mj_beers, aes(x=as.factor(State), y=ABV * 100.0, color=MarijuanaStatus)) +
  geom_point(position = "jitter", alpha=0.7) # +
  # theme(axis.text.x = element_x(angle=85))
