library(dplyr)
library(tidyverse)

x<-read.csv('Data/dataset_1.csv')
glimpse(x)
head(x,30)
#first, the weird thing noticed that we have dates as if we used the pivot table
#to create the dataset. So, let's fix it
for (i in 2:nrow(x)) {  
  if (x$Date[i]=='') {  
    x$Date[i] <- x$Date[i - 1]  
  }
}
#alternative option. they say its smarter.
##Step 1. Create a vector of T&F whether the cell is empty or not
x$Date==""
##Step 2. Take all the observation where the value is T and convert them in NA
x$Date[x$Date == ""] <- NA  
##Step 3. Downloading a necessary library
library(zoo)
##Step 4. Fancy function to fill all the NA with the previous values
##a.k.a. forward filling
x$Date <- na.locf(x$Date, na.rm = FALSE)  

#now we are good to do the exercise

##Question 1
#Which date had the most completed trips during the two week period?

#let's first check if the overall time period is 2-weeks
max(x$Date)
min(x$Date)
#indeed, the period is 2 weeks. We won't go trying reformat and extract the exact days for now
#since we will potentially need working with grouped data let's create the dataset
daily_rides<-x%>%
  group_by(Date)%>%
  summarise(
    completed_trips=sum(Completed.Trips,na.rm=TRUE),
    requests=sum(Requests,na.rm=TRUE),
    active_hours=n()
  )
#now let's get the date we need
filter(daily_rides,completed_trips==max(completed_trips))%>%
  select(Date)
#but what if instead of two steps i wanted to do it in 1 step
x%>%
  group_by(Date)%>%
  summarise(
    completed_trips=sum(Completed.Trips,na.rm=TRUE),
  )%>%
  filter(completed_trips==max(completed_trips))%>%
  select(Date)
#NICE, we know it happened on 22-sep-12

##Question 2
#What was the highest number of completed trips within a 24 hour period?

#i could answer this question the easy way by considering 24 period a day, but its not

#my artisanal approach
for (i in 1:(nrow(x)-24)) {
  x$period[i]=0
  for (k in 1:24){
    x$period[i]=x$period[i]+x$Completed.Trips[k+i-1]
  }
}
filter(x,period==max(period))

#smarter approach (chatgpt)
for (i in 1:(nrow(x)-24)) {
  x$period[i] <- sum(x$Completed.Trips[i:(i+23)])  # Sum 24-hour window
}

highest_period_start <- x %>%
  filter(period == max(period, na.rm = TRUE)) %>%
  select(Date,Time..Local.)  # Get the date where the highest period starts

#even smarter approach

x$period <- rollapply(x$Completed.Trips, width = 24, FUN = sum, align = "left", fill = NA)

highest_period_start <- x %>%
  filter(period == max(period, na.rm = TRUE)) %>%
  select(Date,Time..Local.)

highest_period_start

##Exercise 3
##Which hour of the day had the most requests during the two week period?
#distribution of requests per hour
x%>%
  group_by(Time..Local.)%>%
  summarise(
    requests_total=sum(Requests,na.rm=TRUE)
  )%>%
  arrange(desc(requests_total))
#the busiest hour
x%>%
  group_by(Time..Local.)%>%
  summarise(
    requests_total=sum(Requests,na.rm=TRUE)
  )%>%
  filter(requests_total==max(requests_total))

