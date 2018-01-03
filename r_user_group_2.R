library(readr)
library(tidyverse)

# first let's load in the data used in the example
forecast_ttc <- read_csv("forecast_ttc.csv",
                         col_types = cols(DATE_OF_ACCEPTED_DEMAND = col_date(format = "%d/%m/%Y")))
colnames(forecast_ttc) <- tolower(colnames(forecast_ttc))

# subset for the data we actually want
# this data is now in LONG format
forecast_long <- forecast_ttc[,c(1,2,4)]

# first we're going to turn the long data into wide data (using demand to fill in the cells)
forecast_wide <- spread(forecast_long, trading_title_code, demand)
View(forecast_wide)

# now let's take our wide data and turn it back into long data
# first we're going to use the na.rm flag = TRUE
forecast_unwide <- gather(forecast_wide, trading_title_code, demand, -date_of_accepted_demand, na.rm = TRUE)
View(forecast_unwide)

# however if we set na.rm = FALSE then it introduces NAs for things with number value
forecast_unwide <- gather(forecast_wide, trading_title_code, demand, -date_of_accepted_demand, na.rm = FALSE)

# let's look at smashing things together

# bind_rows takes two dataframes and smashes one on top of the other
# note where data doesn't exist it's NA
forecast_mega <- bind_rows(forecast_long, forecast_ttc)
View(forecast_mega)

# bind_cols takes two dataframes and smashes them side by side
forecast_awful <- bind_cols(forecast_long, forecast_ttc)
View(forecast_awful)

# lets go crazier
forecast_awfuler <- bind_cols(forecast_mega, forecast_long)

