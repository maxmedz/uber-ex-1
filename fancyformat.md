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
