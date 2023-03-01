library(ggplot2)
library(ggpmisc)
library(ggthemes)
library(mice) # multi-variate imputation

# 3.

# breweries_file = file.choose()
# beer_file = file.choose()
brew_dat = read.csv(breweries_file)
beer_dat = read.csv(beer_file)

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





