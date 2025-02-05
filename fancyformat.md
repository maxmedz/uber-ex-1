Uber exercise
================
MM
2025-02-05

## Uber exericise

Below is the exercise from StrataScratch easy section. Now I am just
having fun working the MarkDown fancy file

## Downloading packages and reading the dataset:

``` r
library(tidyverse)
library(dplyr)
library(zoo)
x<-read.csv('Data/dataset_1.csv')
```

## Throwing a look

As we can see, weirdly we have dates in a format as if we used the pivot
table to create a dataset which will complicate our life later.

    ## Rows: 336
    ## Columns: 7
    ## $ Date            <chr> "10-Sep-12", "", "", "", "", "", "", "", "", "", "", "…
    ## $ Time..Local.    <int> 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 2…
    ## $ Eyeballs        <int> 5, 6, 8, 9, 11, 12, 9, 12, 11, 11, 12, 11, 13, 11, 11,…
    ## $ Zeroes          <int> 0, 0, 3, 2, 1, 0, 1, 1, 2, 2, 2, 1, 2, 1, 0, 3, 5, 3, …
    ## $ Completed.Trips <int> 2, 2, 0, 0, 4, 2, 0, 0, 1, 3, 3, 3, 2, 0, 1, 0, 3, 1, …
    ## $ Requests        <int> 2, 2, 0, 1, 4, 2, 0, 0, 2, 4, 4, 4, 3, 0, 1, 2, 3, 1, …
    ## $ Unique.Drivers  <int> 9, 14, 14, 14, 11, 11, 9, 9, 7, 6, 4, 7, 7, 5, 3, 4, 4…

    ##         Date Time..Local. Eyeballs Zeroes Completed.Trips Requests
    ## 1  10-Sep-12            7        5      0               2        2
    ## 2                       8        6      0               2        2
    ## 3                       9        8      3               0        0
    ## 4                      10        9      2               0        1
    ## 5                      11       11      1               4        4
    ## 6                      12       12      0               2        2
    ## 7                      13        9      1               0        0
    ## 8                      14       12      1               0        0
    ## 9                      15       11      2               1        2
    ## 10                     16       11      2               3        4
    ## 11                     17       12      2               3        4
    ## 12                     18       11      1               3        4
    ## 13                     19       13      2               2        3
    ## 14                     20       11      1               0        0
    ## 15                     21       11      0               1        1
    ## 16                     22       16      3               0        2
    ## 17                     23       21      5               3        3
    ## 18 11-Sep-12            0        9      3               1        1
    ## 19                      1        3      2               0        1
    ## 20                      2        1      1               0        0
    ## 21                      3        1      1               0        0
    ## 22                      4        1      1               0        0
    ## 23                      5        1      1               0        0
    ## 24                      6        7      3               2        3
    ## 25                      7       10      0               2        2
    ## 26                      8       11      2               0        0
    ## 27                      9       15      2               0        0
    ## 28                     10       12      1               1        1
    ## 29                     11       16      1               0        0
    ## 30                     12        5      1               0        0
    ##    Unique.Drivers
    ## 1               9
    ## 2              14
    ## 3              14
    ## 4              14
    ## 5              11
    ## 6              11
    ## 7               9
    ## 8               9
    ## 9               7
    ## 10              6
    ## 11              4
    ## 12              7
    ## 13              7
    ## 14              5
    ## 15              3
    ## 16              4
    ## 17              4
    ## 18              3
    ## 19              3
    ## 20              1
    ## 21              1
    ## 22              1
    ## 23              0
    ## 24              3
    ## 25              5
    ## 26              6
    ## 27              6
    ## 28              8
    ## 29              9
    ## 30              8

## Data cleaning

Indeed, we will have to do some data cleaning to adjust the format such
a way it is easier to work with the dates. We will need each observation
have its own date.

First, I will do it my own artisanal way using loops I learnt at school

``` r
for (i in 2:nrow(x)) {  
  if (x$Date[i]=='') {  
    x$Date[i] <- x$Date[i - 1]  
  }
}
```

And as we can see, such an approach works very well

    ##         Date Time..Local. Eyeballs Zeroes Completed.Trips Requests
    ## 1  10-Sep-12            7        5      0               2        2
    ## 2  10-Sep-12            8        6      0               2        2
    ## 3  10-Sep-12            9        8      3               0        0
    ## 4  10-Sep-12           10        9      2               0        1
    ## 5  10-Sep-12           11       11      1               4        4
    ## 6  10-Sep-12           12       12      0               2        2
    ## 7  10-Sep-12           13        9      1               0        0
    ## 8  10-Sep-12           14       12      1               0        0
    ## 9  10-Sep-12           15       11      2               1        2
    ## 10 10-Sep-12           16       11      2               3        4
    ## 11 10-Sep-12           17       12      2               3        4
    ## 12 10-Sep-12           18       11      1               3        4
    ## 13 10-Sep-12           19       13      2               2        3
    ## 14 10-Sep-12           20       11      1               0        0
    ## 15 10-Sep-12           21       11      0               1        1
    ## 16 10-Sep-12           22       16      3               0        2
    ## 17 10-Sep-12           23       21      5               3        3
    ## 18 11-Sep-12            0        9      3               1        1
    ## 19 11-Sep-12            1        3      2               0        1
    ## 20 11-Sep-12            2        1      1               0        0
    ## 21 11-Sep-12            3        1      1               0        0
    ## 22 11-Sep-12            4        1      1               0        0
    ## 23 11-Sep-12            5        1      1               0        0
    ## 24 11-Sep-12            6        7      3               2        3
    ## 25 11-Sep-12            7       10      0               2        2
    ## 26 11-Sep-12            8       11      2               0        0
    ## 27 11-Sep-12            9       15      2               0        0
    ## 28 11-Sep-12           10       12      1               1        1
    ## 29 11-Sep-12           11       16      1               0        0
    ## 30 11-Sep-12           12        5      1               0        0
    ##    Unique.Drivers
    ## 1               9
    ## 2              14
    ## 3              14
    ## 4              14
    ## 5              11
    ## 6              11
    ## 7               9
    ## 8               9
    ## 9               7
    ## 10              6
    ## 11              4
    ## 12              7
    ## 13              7
    ## 14              5
    ## 15              3
    ## 16              4
    ## 17              4
    ## 18              3
    ## 19              3
    ## 20              1
    ## 21              1
    ## 22              1
    ## 23              0
    ## 24              3
    ## 25              5
    ## 26              6
    ## 27              6
    ## 28              8
    ## 29              9
    ## 30              8

Still, chatgpt offered me 2 other options :

**Step 1. Create a vector of T&F whether the cell is empty or not**

``` r
x$Date==""
```

    ##   [1] FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ##  [13]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ##  [25]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ##  [37]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ##  [49]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ##  [61]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ##  [73]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ##  [85]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ##  [97]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [109]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [121]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [133]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [145]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [157]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [169]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [181]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [193]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [205]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [217]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [229]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [241]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [253]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [265]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [277]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [289]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [301]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [313]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    ## [325]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE

**Step 2. Take all the observations where the value is T and convert
them in NA**

``` r
x$Date[x$Date == ""] <- NA
```

**Step 3. Fancy function to fill all the NA with the previous values
a.k.a. forward filling**

``` r
x$Date <- na.locf(x$Date, na.rm = FALSE)
```

As a result, the same output

    ##         Date Time..Local. Eyeballs Zeroes Completed.Trips Requests
    ## 1  10-Sep-12            7        5      0               2        2
    ## 2  10-Sep-12            8        6      0               2        2
    ## 3  10-Sep-12            9        8      3               0        0
    ## 4  10-Sep-12           10        9      2               0        1
    ## 5  10-Sep-12           11       11      1               4        4
    ## 6  10-Sep-12           12       12      0               2        2
    ## 7  10-Sep-12           13        9      1               0        0
    ## 8  10-Sep-12           14       12      1               0        0
    ## 9  10-Sep-12           15       11      2               1        2
    ## 10 10-Sep-12           16       11      2               3        4
    ## 11 10-Sep-12           17       12      2               3        4
    ## 12 10-Sep-12           18       11      1               3        4
    ## 13 10-Sep-12           19       13      2               2        3
    ## 14 10-Sep-12           20       11      1               0        0
    ## 15 10-Sep-12           21       11      0               1        1
    ## 16 10-Sep-12           22       16      3               0        2
    ## 17 10-Sep-12           23       21      5               3        3
    ## 18 11-Sep-12            0        9      3               1        1
    ## 19 11-Sep-12            1        3      2               0        1
    ## 20 11-Sep-12            2        1      1               0        0
    ## 21 11-Sep-12            3        1      1               0        0
    ## 22 11-Sep-12            4        1      1               0        0
    ## 23 11-Sep-12            5        1      1               0        0
    ## 24 11-Sep-12            6        7      3               2        3
    ## 25 11-Sep-12            7       10      0               2        2
    ## 26 11-Sep-12            8       11      2               0        0
    ## 27 11-Sep-12            9       15      2               0        0
    ## 28 11-Sep-12           10       12      1               1        1
    ## 29 11-Sep-12           11       16      1               0        0
    ## 30 11-Sep-12           12        5      1               0        0
    ##    Unique.Drivers
    ## 1               9
    ## 2              14
    ## 3              14
    ## 4              14
    ## 5              11
    ## 6              11
    ## 7               9
    ## 8               9
    ## 9               7
    ## 10              6
    ## 11              4
    ## 12              7
    ## 13              7
    ## 14              5
    ## 15              3
    ## 16              4
    ## 17              4
    ## 18              3
    ## 19              3
    ## 20              1
    ## 21              1
    ## 22              1
    ## 23              0
    ## 24              3
    ## 25              5
    ## 26              6
    ## 27              6
    ## 28              8
    ## 29              9
    ## 30              8

# And Now we are good to do the exercise

## Exercise 1 : Which date had the most completed trips during the two week period?

Let’s first check if the overall time period is 2-weeks:

``` r
min(x$Date)
```

    ## [1] "10-Sep-12"

``` r
max(x$Date)
```

    ## [1] "24-Sep-12"

Indeed, the period is 14 days as expected. **Since we will potentially
need working with grouped data let’s create the dataset**

``` r
daily_rides<-x%>%
  group_by(Date)%>%
  summarise(
    completed_trips=sum(Completed.Trips,na.rm=TRUE),
    requests=sum(Requests,na.rm=TRUE),
    active_hours=n()
  )
# and select the date we need
filter(daily_rides,completed_trips==max(completed_trips))%>%
  select(Date,completed_trips)
```

    ## # A tibble: 1 × 2
    ##   Date      completed_trips
    ##   <chr>               <int>
    ## 1 22-Sep-12             248

Nice, now we know that there is been the most trips on 22nd September.
\### However, there is the smarter way to do that. And it is offered by
**me** and suggest just executing one requests without creating any
additional datasets

``` r
x%>%
  group_by(Date)%>%
  summarise(
    completed_trips=sum(Completed.Trips,na.rm=TRUE),
  )%>%
  filter(completed_trips==max(completed_trips))%>%
  select(Date,completed_trips)
```

    ## # A tibble: 1 × 2
    ##   Date      completed_trips
    ##   <chr>               <int>
    ## 1 22-Sep-12             248
