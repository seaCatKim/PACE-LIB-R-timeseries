---
title: ACF art by Dr Allison Horst
author: ''
date: '2022-02-03'
slug: acf-art
categories: []
tags: []
---

This series of artwork explains the autocorrelation function (ACF). Dr Allison Horst's RStats artwork is freely available on [her GitHub repo](https://github.com/allisonhorst/stats-illustrations/).

![A line of related fuzzy monsters that ranges from more distant relatives (toward the left) to the current generation on the right. Several more recent generations are labeled, from “ME” on the far right, then “MY PARENT”, “MY GRANDPARENT”, “MY GREAT-GRANDPARENT” and “MY GREAT-GREAT GRANDPARENT” moving toward the left. The current generation monster on the left is saying “Hello! Meet some of my ancestors.” Stylized text at the top reads “intro to the autocorrelation function (ACF).”](acf_1.jpg)

![A friendly looking ancestral line of five monsters of simple shapes and varying color, from “My great-great grandparent” on the left to “Me!” on the right. Text says “In our family monsters tend to be a little similar to their parent and great-grandparent, very different from their grandparent, very similar to their great-great grandparent." The two monsters on the ends (great-great grandparent and current generation” are very similar in color and shape, and there is an arrow between them with text “lag = 4 generations. We are very similar!” The monsters separated by two generations (“grandparent” and current generation) are very different in color and shape, with text reading “lag = 2 generations. We are very different!”](acf_2.jpg)

![A long series of friendly looking monsters representing generations in their family, of varying shape and color. Those separated by 4 generations are very similar in shape and color. Those separated by two generations are very dissimilar in shape and color. Text reads: “The autocorrelation function (ACF) is a plot of autocorrelation between a variable and itself separated by specified lags (in our case, generations). Let’s build one!” There is an empty plot area below.](acf_3.jpg)

![A long series of friendly looking monsters representing generations of their family. An arc with “1” is between each subsequent monster, indicating they are separated by one generation. The text reads “At lag = 1, we find the correlation between monsters and their parent. They are somewhat positively correlated.” The ACF plot area now has a single slightly positive bar (indicating the slight positive correlation) at a value of 1 lag on the x-axis. Additional text reads “Note: since the ACF at Lag = 0 is always 1, it is often excluded.”](acf_4.jpg)

![A long series of friendly looking monsters representing generations of their family. An arc with “2” is drawn between each monster and the one at a distance of 2 generations from it (lag = 2). Text reads “At lag = 2, we find the correlation between monsters and their grandparent. Since they tend to be very different, we find a negative correlation at lag = 2.” The ACF plot now has an additional negative bar at Lag = 2, indicating the negative correlation between each monster and their grandparent.](acf_5.jpg)

![A long series of friendly looking monsters representing generations of their family. An arc with “3” is drawn between each monster and the one at a distance of 3 generations from it (lag = 3). Text reads “At lag = 3, we find the correlation between monsters and their great-grandparent. They are slightly positively correlated.” The ACF plot now has an additional slightly positive bar at Lag = 3, indicating the slight positive correlation between each monster and their great-grandparent.](acf_6.jpg)

![A long series of friendly looking monsters representing generations of their family. An arc with “4” is drawn between each monster and the one at a distance of 4 generations from it (lag = 4). Text reads “At lag = 4, we find the correlation between monsters and their great-great-grandparent. They tend to be verys similar (there is a positive correlation.)” The ACF plot now has an additional positive bar at Lag = 4, indicating the positive correlation between each monster and their great-great-grandparent.](acf_7.jpg)

![A long time series of friendly looking monsters representing generations of their family. Monsters separated by 4 generations are very similar, and those separated by 2 generations are very different. An autocorrelation function plot is show below the monsters, revealing positive correlations at lag = 4 and 8, negative correlations at lag = 2 and 5, and smaller positive correlations for other lags. The text reads “and we continue finding the correlations as we increase the lag (generations) between the monsters…""](acf_8.jpg)

![Three very similar blue round monsters standing next to each other, looking very happy and with little hearts between them, representing monsters separated by 4 generations (so they are very similar). There is an example ACF function below them showing positive correlations at lag = 4 and 8. Text reads “In summary: the autocorrelation function (ACF) tells us the correlation between observations and those that came before them, separated by different lags (here, monster generations)!](acf_9.jpg)
