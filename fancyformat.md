Uber easy exercise
================
MM
2025-02-05

## **Introduction**

This report analyzes ride-sharing data using `dplyr` and `tidyverse`.
The analysis includes data cleaning, identifying the date with the
highest completed trips, finding the busiest 24-hour period, and
determining peak request hours.

## **Loading Libraries and Dataset**

``` r
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(tidyverse)
```

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ forcats   1.0.0     ✔ readr     2.1.5
    ## ✔ ggplot2   3.5.1     ✔ stringr   1.5.1
    ## ✔ lubridate 1.9.3     ✔ tibble    3.2.1
    ## ✔ purrr     1.0.2     ✔ tidyr     1.3.1

    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

``` r
x <- read.csv('Data/dataset_1.csv')
glimpse(x)
```

    ## Rows: 336
    ## Columns: 7
    ## $ Date            <chr> "10-Sep-12", "", "", "", "", "", "", "", "", "", "", "…
    ## $ Time..Local.    <int> 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 2…
    ## $ Eyeballs        <int> 5, 6, 8, 9, 11, 12, 9, 12, 11, 11, 12, 11, 13, 11, 11,…
    ## $ Zeroes          <int> 0, 0, 3, 2, 1, 0, 1, 1, 2, 2, 2, 1, 2, 1, 0, 3, 5, 3, …
    ## $ Completed.Trips <int> 2, 2, 0, 0, 4, 2, 0, 0, 1, 3, 3, 3, 2, 0, 1, 0, 3, 1, …
    ## $ Requests        <int> 2, 2, 0, 1, 4, 2, 0, 0, 2, 4, 4, 4, 3, 0, 1, 2, 3, 1, …
    ## $ Unique.Drivers  <int> 9, 14, 14, 14, 11, 11, 9, 9, 7, 6, 4, 7, 7, 5, 3, 4, 4…

``` r
head(x, 30)
```

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

## **Data Cleaning**

### **Fixing Date Column Issues**

``` r
for (i in 2:nrow(x)) {  
  if (x$Date[i] == '') {  
    x$Date[i] <- x$Date[i - 1]  
  }
}
```

### **Alternative Approach (Using `zoo`)**

``` r
x$Date[x$Date == ""] <- NA  
library(zoo)
```

    ## Warning: package 'zoo' was built under R version 4.4.2

    ## 
    ## Attaching package: 'zoo'

    ## The following objects are masked from 'package:base':
    ## 
    ##     as.Date, as.Date.numeric

``` r
x$Date <- na.locf(x$Date, na.rm = FALSE)
```

## **Question 1: Date with the Most Completed Trips**

``` r
max(x$Date)
```

    ## [1] "24-Sep-12"

``` r
min(x$Date)
```

    ## [1] "10-Sep-12"

``` r
daily_rides <- x %>%
  group_by(Date) %>%
  summarise(
    completed_trips = sum(Completed.Trips, na.rm = TRUE),
    requests = sum(Requests, na.rm = TRUE),
    active_hours = n()
  )

filter(daily_rides, completed_trips == max(completed_trips)) %>%
  select(Date)
```

    ## # A tibble: 1 × 1
    ##   Date     
    ##   <chr>    
    ## 1 22-Sep-12

### **One-Step Approach**

``` r
x %>%
  group_by(Date) %>%
  summarise(
    completed_trips = sum(Completed.Trips, na.rm = TRUE)
  ) %>%
  filter(completed_trips == max(completed_trips)) %>%
  select(Date)
```

    ## # A tibble: 1 × 1
    ##   Date     
    ##   <chr>    
    ## 1 22-Sep-12

## **Question 2: Highest Number of Completed Trips in a 24-Hour Period**

### **Manual Loop Approach**

``` r
for (i in 1:(nrow(x)-24)) {
  x$period[i] = 0
  for (k in 1:24){
    x$period[i] = x$period[i] + x$Completed.Trips[k + i - 1]
  }
}
filter(x, period == max(period))
```

    ##        Date Time..Local. Eyeballs Zeroes Completed.Trips Requests
    ## 1 21-Sep-12           17       68     25              26       26
    ##   Unique.Drivers period
    ## 1             20    278

### **Optimized Approach (Using Summation)**

``` r
for (i in 1:(nrow(x)-24)) {
  x$period[i] <- sum(x$Completed.Trips[i:(i+23)])
}

highest_period_start <- x %>%
  filter(period == max(period, na.rm = TRUE)) %>%
  select(Date, Time..Local.)

highest_period_start
```

    ##        Date Time..Local.
    ## 1 21-Sep-12           17

### **Best Approach (Using `rollapply`)**

``` r
x$period <- rollapply(x$Completed.Trips, width = 24, FUN = sum, align = "left", fill = NA)

highest_period_start <- x %>%
  filter(period == max(period, na.rm = TRUE)) %>%
  select(Date, Time..Local.)

highest_period_start
```

    ##        Date Time..Local.
    ## 1 21-Sep-12           17

## **Question 3: Busiest Hour of the Day**

### **Requests Distribution per Hour**

``` r
x %>%
  group_by(Time..Local.) %>%
  summarise(
    requests_total = sum(Requests, na.rm = TRUE)
  ) %>%
  arrange(desc(requests_total))
```

    ## # A tibble: 24 × 2
    ##    Time..Local. requests_total
    ##           <int>          <int>
    ##  1           23            184
    ##  2           22            174
    ##  3           19            156
    ##  4            0            142
    ##  5           18            119
    ##  6           21            112
    ##  7           20            107
    ##  8            2            100
    ##  9           17             98
    ## 10            1             96
    ## # ℹ 14 more rows

### **Finding the Peak Hour**

``` r
x %>%
  group_by(Time..Local.) %>%
  summarise(
    requests_total = sum(Requests, na.rm = TRUE)
  ) %>%
  filter(requests_total == max(requests_total))
```

    ## # A tibble: 1 × 2
    ##   Time..Local. requests_total
    ##          <int>          <int>
    ## 1           23            184
