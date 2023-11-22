# Console Wars
 Using a Kaggle dataset of videogame releases from 1980 to 2016 this will bring analyisis on the best selling and most critically acclaimed games. 
 
 Overview of Data

Whilst I have used this data to display the difference between consoles and publishers it should be noted this is data based on the number of games sold, there is no data on the sale of console units.
An example where this could be an issue is the likes of generation 6 where the Wii vastly outsold PS3 and XBox360 in terms of consoles but all three are very close in terms of game sales. 

This dataset does have a few issues though. 

 - Over half of the 16,000 games are missing review scores and developer names. This is likely because this full data has not been found until later then added on.
 - No mention of indie or mobile games which were making up a larger proportion of game sales from 2010 onwards. The world's best selling game of all time Minecraft is not included which does seem significant. 
 - The figures seem inaccurate from 2014 onwards. There is just too big a dip in sales over this period. 
 - Multi-platform games are only tallied by their sales on each console so massive selling games like GTA V and Call of Duty look less successful.
 - Some games like Tetris and Wii Sports were bundled in with the console's sale so do those technically count as "best sellers" because buyers didn't necissarily choose them.
 - Sales over time aren't shown. For each game we have it's year of release then it's total sum. Meaning games with long shelvelives like GTA V and Elder Scrolls Skyrim have many of their sales missing. 

 Using SQL 

Several queries have been made in SQL to parse through the data with 22 different and dense queries with a reason and analysis performed afterwards.
SQL is very good for finding out analysis in a squeaky clean dataset but since you can't transform the data it does miss out on the opportunity to categorise information.
The SQL queries and comments do speak for themselves so there doesn't need to be much added. 

 Using PowerBI

To display the trends I have made a few dense dashboards on PowerBI. 

The first page is simply an overview of the data with a few cards to highlight the number of games, consoles and publishers.
There are graphs highlighting the number of games sold on each console, the best 10 selling games of all time - according to this data.
Then I have sales of games each year as a bar graph to highlight the sales from each console through the years which as you can imagine means there is a wide variety in the legend.

The second page is highlighting the use of sliders. By clicking different's consoles we can see their total sales, (both global broken down by region), the lifespan of the console, a pie chart of their proportional genres and the best selling publishers.
If you want this to cover multiple consoles this can be done no problem if you are wanting to get a particular trend for a set of consoles made by the same company.

The third page is where I experimented with simple DAX queries like combining the review scores from critics and users to get a decent average. 
I then made 3 different measurements of the total global sales minus the first party publisher for the consoles Ninentendo, Sony and Microsoft.
I then made 3 more to turn all of these into a percentage of 3rd party game sales to make the ratio easier to understand.
These differences were highlighted in a table for each company as Nintendo has a completely different strategy to Sony and Microsoft. 
Nintendo is both a large scale producer of consoles and a publisher of first party games with dozens of world-famous IP's so the majority of their sales are their own creations.
Whereas Sony and Microsoft fight over similar territory of attracting publishers to produce games on their consoles but it means their libraries often overlap. Hence why it is seen as a priority to only buy one rather than both.

Lastly the fourth page is the creation of a ToolTip. 
This I am immensely proud of because it is just highlightling the top 5 selling games over each query but through the other graphs or slicers this elevates it.
Let's say you are on page 2 and you want to find the top selling games on the N64 in 1998, you can do that just with a slicer and a hover 
Or by going over the pie chart you don't just get to see the most popular genre on the XBox 360 but also the top 5 best selling games in those subcategories. 
The only issue I have with this tool tip is I'd like it to have more of a toogle feature, particularly on the best selling games graph because it is not needed there. 

 Reflective wishes or future expansions. 

I may come back to this dataset and transform some points using Python or R to get a few more key details. 
One in particular is the tallying up the sales of multi-platform games, franchises like FIFA and Call of Duty have been juggernaughts for decades but hardly get a place on the top sellers list because they are fractured. 
It would be good to compare them to the first party best sellers.
I would also like to go down a data science route and compare games by performing some clustering.

 Final thoughts

We used this data set a couple of times in CodeClan and were even offered it as a potential option for our final projects. 
I chose to avoid it because it does not seem like a good dataset to perform a logistic regression model to find what makes a best selling game.
However as mentioned above looking at other data science techniques may work better with other questions in mind, however there is no "right" way to create a best-selling game.
Overall I really enjoyed using this data to play about with SQL queries and PowerBI dashboards as I think it helped build my knowledge on something I am already rather passionate about. 