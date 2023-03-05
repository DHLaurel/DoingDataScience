# Beers and Breweries

## Abstract
We are pleased to present the results of our analysis of the data you provided. Our objective was to gain a deeper understanding of the relationship between alcohol by volume (ABV) and various other factors, such as the number of breweries in each state, the bitterness of beer, and the correlation between bitterness and alcohol content.

In conducting our analysis, we utilized various statistical tools and techniques, including scatter plots, bar charts, and KNN classifiers. Our findings have uncovered several interesting insights that we believe will be of great value to Budweiser.

Please find below a summary of our key findings. If you have any questions or comments, we would be happy to discuss them further. Our aim is to provide you with results that are clear, concise, and actionable.

## Breweries by State

The data set contained 558 breweries across the United States, with the top five states accounting for 31% of the total (175 breweries). The states were ranked in order of largest to smallest, with Colorado being the largest with 8.42% of the total, followed by California (6.99% of the total), Michigan (5.73% of the total), Oregon (5.20% of the total), and Texas (5.02% of the total).

## Missing Values

Several values were missing for both the ABV and IBU columns. We needed to make sure that we were approaching these missing values in the correct way. First we determined that these were Missing-At-Random. Then we determined that the proportion of missing rows to total was somewhat significant at 41.7%. Unfortunately, this high number means some of our predictions using IBU may be slightly skewed towards the mean.

At this point, to deal with the missing values, we used an algorithm known as multivariate imputation by chaining predictive means equations. This method works by predicting missing values using the average value and basing this on surrounding factors that are known (e.g. predicting missing ABV using IBU).

## Median ABV and IBU by State

This chart presents a summary of the median Alcohol by Volume (ABV) and International Bitterness Unit (IBU) values of beers produced in different states across the United States. To compile the information, the Beer and Breweries datasets were merged and the median values of ABV and IBU were calculated for each state of production. The states with the highest median IBU values are Montana (80 IBU), Delaware (77.5 IBU), and Vermont (75 IBU). The states with the highest median ABV values are Nevada (0.085), South Carolina (0.0765), Vermont (0.0715), and Kansas (0.0715).

## Highest ABV & IBU Beers

### ABV

We could pick the states which produce beers with the greatest ABV and IBU, respectively, but it might be more interesting to determine trends of states that are producing these high-scoring beers. To make sure we were only picking beers with true ABV/IBU numbers, we used the original data set without missing values imputed. From these results, we found the states that tended to produce higher ABV beers were Colorado, Kentucky, Indiana, New York, and Michigan.

From the plot below, the data appears to indicate that while Colorado produces the single highest-ABV beer, "Lee Hill Series Vol. 5 - Belgian Style Quadrupel Ale," it is outpaced by Kentucky in concentration of high-ABV beers produced.

### IBU

We see a similar trend happen when we discuss IBU for these beers as well. The aptly named, "Bitter Bitch Imperial IPA" brings Oregon to the top of the list, despite appearing to have fewer beers at the high end of the IBU distribution.

## Alcohol By Volume

In this analysis, the distribution of Alcohol by Volume (ABV) in 2,410 beers was examined. The histogram of the ABV revealed a right-skewed distribution, with the mean ABV of 5.97% and median of 5.60%.

## Testing the Correlation Between IBU and ABV

As hinted to earlier, during the missing value imputation for ABV and IBU, we noticed that the two columns seemed to be adequate predictors for one another. The data indicates there is a strong positive correlation between ABV and IBU at an r-value of 0.652 (r-values range between -1.0 and 1.0).

## IPAs vs. Ales:

### Using K-Nearest Neighbors to Predict IPAs and Ales from IBU/ABV

It was wondered whether there was a strong predictive factor that we could use to test the hypothesis that IPAs tend to be more bitter and have a higher alcohol content than other types of ales. In order to perform this analysis, we first filtered out all non-ales from the data set, then we used a predictive machine learning algorithm known as K-nearest neighbors, which clumps beers together based on IBU and ABV, and uses these clusters to predict whether a test beer is likely an IPA or another type of ale.

From the model we built using the K-nearest neighbors approach, we were able to predict with 79.6% accuracy whether a given ale was an IPA or not.

## Interesting Findings:

In this analysis, the relationship between Alcohol by Volume (ABV) in beer produced by a state and the corresponding DUI arrest rate was examined. A correlation was calculated between the two variables and the results showed a negative correlation coefficient of -0.07, indicating that there is no positive relationship between the two variables. This suggests that producing beer with higher alcohol content does not necessarily result in an increase in DUI arrests.

## Conclusion
From our investigations, we raised a number of considerable questions we were able to answer. We found that just five states accounted for 31% of all breweries, with Colorado alone accounting for an impressive 8%. We found there was a significant portion of the available beer data which had not listed International Bitterness Units (IBU), opening the field to furhter investigation and analysis. We found both the median and mean Alcohol-by-Volume (ABV) metrics for American beers to rest around 5.6%. And the data indicated there was a strongly predictive factor (~79% accuracy) between IBU, ABV, and whether or not a beer would be considered an Indian Pale Ale (IPA). 

Outside of the initial topics proposed for investigation, we went out of our way to gather relevant Driving Under the Influence (DUI) statistics on a state basis. We compared these additional findings with the data from the beers and breweries provided, and we found the data to indicate that there was not a strong correlation between states that produce high-ABV beers and number of DUI incidents. Although this may be confounded by the fact that the beers produced in these states tend to ship both domestically and abroad, we determined this should have an overall positive impact on the marketing and sales division for these more high-caliber products. 

## Contact Information
O'Neal Gray, (214) 724-2020, ogray@mail.smu.edu
David Laurel, (956) 635-6463, dlaurel@mail.smu.edu
