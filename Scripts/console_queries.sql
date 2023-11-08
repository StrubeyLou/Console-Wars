
--Q)1
-- Kicking all of this off with a very simple query so I can keep looking at the whole dataset for inspiration on queries.

SELECT *
FROM foo

--Q)2
-- The next step is seeing how broad the range of games are that come up. 
-- I checked all the games that came up published by Nintendo and checked if it had all the releases because they are easy to corroborate. 

SELECT Name, Platform, Year_of_Release
FROM foo 
WHERE Publisher == "Nintendo"
ORDER BY Year_of_Release 

--Q)3
-- Thankfully the list checks out.
-- When browsing through I did see an obscure game I loved called Earthbound.
-- The infamous story is it poorly sold on release particularly in the west but became a cult classic
-- Let's do a data check to see how it's sales were and how it compared to the competition.

SELECT 
  Name,
  NA_Sales,
  EU_Sales,
  JP_Sales,
  Global_Sales,
  Genre,
  (
    SELECT AVG(JP_Sales)
    FROM foo
    WHERE Platform = 'SNES' AND Genre = 'Role-Playing'
  ) AS AVG_JP_Sales,
  (
    SELECT AVG(Global_Sales)
    FROM foo
    WHERE Platform = 'SNES' AND Genre = 'Role-Playing'
  ) AS AVG_Global_Sales
FROM foo
WHERE Name = 'EarthBound';

-- Looking at the data it's real for western sales at 0 in NA and EU. However in Japan sales were high at over 800k.
-- This is particularly good as the query I made compared it to the average game sales in Japan and Global.
-- But not just for any specifically categorising it based on the average sales for an RPG on the SNES console.
-- It sold pretty high compared to the competition but as Nintendo would put effort into a new IP they'd want them far higher.

--Q4) The issue with this data is that many of the columns around review scores, either critical or publich have a lot of blank spaces.
-- Let's look at how many are missing.


SELECT COUNT(*)
FROM foo 
WHERE Critic_Score IS NULL OR Critic_Score = ''; 

--Q5) I have a theory that because online game reviews became significant in the industry in the 2000s that a lot of the missing scores will be older releases.
-- So let's look at how many reviews are missing each year.

SELECT 
  Year_of_Release,
  COUNT(*) AS Missing_Scores
FROM foo 
WHERE Critic_Score IS NULL OR Critic_Score = ''
GROUP BY Year_of_Release;

--Q6) That's just a list of numbers with no contxt so let's get some proper figures in place.
-- I have added two extra columns, the first one comparing the SUM of all games released in that year.
-- The second is a Missing Rate as a percentage. I did have to use the ROUND function to get rid of the decimal points.

SELECT 
  Year_of_Release,
  COUNT(*) AS Total_Releases,
  SUM(CASE WHEN Critic_Score IS NULL OR Critic_Score = '' THEN 1 ELSE 0 END) AS Missing_Scores,
  ROUND((SUM(CASE WHEN Critic_Score IS NULL OR Critic_Score = '' THEN 1 ELSE 0 END) * 100.0) / COUNT(*)) AS Missing_Rate
FROM foo
GROUP BY Year_of_Release
ORDER BY Year_of_Release;

-- The theory has some merit as we can see when we get to the 2000's there is a massive plummet in the rate of missing reviews.
-- However one that scratches my head is the rise after 2005 from 30% doubling to 60% in 2010.

--Q7) Let's try exploring the data some more, as videogames got more popular in the 2000s there was a rise in cheap cash-ins or movie tie-ins.
-- The latter of these particularly sold well but were often poorly reviewed. These were held by a small number of large publishers.
-- If we check the rate of missing reviews by publisher we may be able to explore this further.
-- Since the missing rate was incredibly high before 2000 then dipped in the early 2000s I have narrowed down the date range.
-- I also added a new column going back to this chunk to see the average critic score based on studio for further analysis.


SELECT Publisher,
count(*) AS Total_Releases,
SUM(CASE WHEN Critic_Score IS NULL OR Critic_Score = '' THEN 1 ELSE 0 END) AS Missing_Scores,
  ROUND((SUM(CASE WHEN Critic_Score IS NULL OR Critic_Score = '' THEN 1 ELSE 0 END) * 100.0) / COUNT(*)) AS Missing_Rate,
  ROUND(AVG(CASE WHEN Critic_Score IS NOT NULL AND Critic_Score != '' THEN Critic_Score END)) AS Avg_Critic_Score
FROM foo 
WHERE Year_of_Release BETWEEN 2006 AND 2016
GROUP BY Publisher 
-- I added the HAVING condition as this goes up to over 400 publishers who have released very few games.
HAVING COUNT(*) >= 20
ORDER BY Missing_Rate DESC

-- Whilst the data blows my theory out of the water it is still very interesting to see.
-- There are a lot of studios with a medium number of releases with a high number of missing scores but is it enough to skew the data?
-- Even studios that require critical reception to maintain strong sales like Bethesda, Capcom and Square Enix still have a high number of missing scores.
-- The missing numbers make me feel like it is an issue with collecting the data rather than a set pattern of the industry. 
-- Interestingly enough one of the most complicit publishers with cheap movie tie ins is EA Studio but they have one of the lowest missing rates, especially of the big studios.
-- The addition of a avg critic score column also helped me quantify through data how reliable publishers are for producing high quality games.
-- As can be seen by exploring this column we can see that there isn't much difference between publsihers who are seen as only publishing blue chip games compared to those that chrun out releases.

--Q8) These two queries are one I would like to show as a visual through PowerBI but you can see this through numbers.
-- Each transition in console generation there is a period where the old console is still releasing games. 
-- In the chunk below we'd see that the gap is very small as 2000/2001 saw the transition to the following:
-- PS1 to PS2 (2000), N64 to GC (2001), GB to GBA (2001).
-- In a PowerBI visual of this you would use drop-downs to show the trasition of releases from 1999 to 2002.

SELECT count(*) AS no_of_releases, 
Platform
FROM foo 
WHERE Year_of_Release  BETWEEN 2000 AND 2001
GROUP BY Platform
ORDER BY Platform ASC;

--Q9) Continiuing from 8 the next console shift was 2005/2006 with the following:
-- XB to X360 (2005), PS2 to PS3 (2006), GC to Wii (2006), GBA to DS (late 2004)
-- However my argument would be that the window of transition is greater because of a less sharp rise in technology
-- In a graphic version of this data I would show this movement from 2005 to potentially 2008.
-- We can already see the kernels of this argument with the DS being out in 2004 but nearly 200 releases made on the GBA.

SELECT count(*) AS no_of_releases, 
Platform
FROM foo 
WHERE Year_of_Release  BETWEEN 2005 AND 2006
GROUP BY Platform
ORDER BY Platform ASC;

--Q10) Lastly we go to the years 2012/2013 for the final console shift we can do in this data. Which we have:
-- X360 to XOne (2013), PS3 to PS4 (2013), Wii to WiiU (2012), PSP to PSV (2012) and DS to 3Ds (2011)
-- I would keep the argument of more games coming out on different consoles for a longer period again
-- If using PowerBI I would make the years range from 2011 to 2014 - maybe include 15 if it suits.
-- Again as cn be seen in the argument even though the DS had been no longer out for nearly a year at the start of this data there were still 31 releases for the console. 

SELECT count(*) AS no_of_releases, 
Platform
FROM foo 
WHERE Year_of_Release  BETWEEN 2012 AND 2013
GROUP BY Platform
ORDER BY Platform ASC;

-- Random Queries

--Q11) Change the data so the games are titled by their publisher like it's their product.

SELECT 
Publisher || "'s " || Name AS NAME,
Platform 
FROM foo 
ORDER BY Name ASC NULLS LAST;

--Q12) Find the 10 best selling games beginning with "A."


SELECT Name, Global_Sales
FROM foo 
WHERE name LIKE "A%"
ORDER BY Global_Sales DESC NULLS LAST 
LIMIT 10

-- Based on these results there is definitely some analysis that can be done on how well multiplatform games sell compared to first party games.

--Q13) One of the significant ways to show a platform is successful or good to work with is the 3rd party support. 
-- Show how many different publishes worked on each Platform with the number of games they released.

SELECT 
platform, publisher, 
count(*) AS no_per_platform
FROM foo 
GROUP BY Platform, Publisher 
HAVING count(*) >= 10
ORDER BY Platform ASC NULLS LAST, Publisher ASC NULLS LAST;

--Q14) Nintendo is a publisher that always prides itself on critically acclaimed games. Present the top 10 highest reviewed games they published on the Wii.

SELECT 
Name, Platform, Publisher, Year_of_Release, Critic_Score 
FROM foo 
WHERE Platform == "Wii" AND Publisher == "Nintendo" AND Critic_Score IS NOT NULL AND Critic_Score != ''
ORDER BY Critic_Score DESC NULLS LAST 
LIMIT 10

--Q15) How well did each console do. Please give the average sales of each platform?

SELECT 
Platform, 
count(*) AS Num_of_Releases,
ROUND(AVG(Global_Sales), 2) AS avg_sales
FROM foo 
GROUP BY Platform 
HAVING count(*) >= 20
ORDER BY AVG(Global_Sales) DESC

-- By the numbers of releases on the GB, NES, GEN and SNES we can see that there are less releases than there actually were.
-- Most likely they have just kept with the first party releases that were big hitters, hence the super high average. 

--Q16) Please show the name, year, genre and sales figures of the best selling game on the least popular genre.

SELECT 
name, Year_of_Release, Genre, Global_Sales 
FROM foo 
WHERE Platform == "X360" AND Genre == (
SELECT Genre 
FROM foo 
GROUP BY Genre 
ORDER BY COUNT(*) DESC NULLS LAST 
LIMIT 1)
ORDER BY Global_Sales 
LIMIT 1

-- Never heard of this game before and am surprised how low the sales were in the action genre.

--Q17) Continuing Q12 let's look at multi-platform releases. Find all games that have been released on multiple platforms, ordering them based on the number of releases then ties are in alphabetical order.

SELECT 
Name,
count(*) AS multi_platform_releases
FROM foo
GROUP BY Name
HAVING count(*) >= 2
ORDER BY count(*) DESC, Name ASC

-- Sadly SQL isn't good at data transformation but it would be interesting to see how much these sold in total.

--Q18) The shooter genre has gone through a huge evolution. Since the release of Halo in 2001 shooters have become increasingly popular. 
-- However has that been reflected by the proportion of games made? Find the proportion of shooters that have been released throughout the data's history to find out.

SELECT 
Year_of_Release,
SUM(CAST(Genre == "Shooter" AS INT)) / CAST(COUNT(*) AS REAL) AS prop_shooter
FROM foo 
GROUP BY Year_of_Release

--Q19) Please find the best selling games on the most popular platform and find how many times it's sales were above the average.
-- Order by highest sales first.

SELECT 
Name, 
Year_of_Release, 
Publisher, 
Global_Sales,
Global_Sales / AVG(Global_Sales) OVER() AS Sales_over_Average
FROM foo 
WHERE Platform = (
SELECT Platform 
FROM foo 
GROUP BY Platform 
ORDER BY COUNT(*) DESC NULLS LAST 
LIMIT 1
)
ORDER BY Global_Sales DESC NULLS LAST;

--Q20) Mario is probably the most popular videogame of all time. How many games include his name in the title?

SELECT 
count(*) AS Mario_Games
FROM foo 
WHERE Name LIKE "%Mario%"

--Q21) As the consoles have progressed have they used his name in more or less of their gaming titles?

SELECT 
Platform,
count(*) AS Mario_Games
FROM foo 
WHERE Name LIKE "%Mario%"
GROUP BY Platform 

--Q21) I can only think of 7 of the Mario games in N64. Find out what all 9 are by title.

SELECT 
Name
FROM foo 
WHERE Platform == "N64" AND Name LIKE "%Mario%"

--Q22) Speaking of names, let's find out what the five most popular opening titles are to all the games in this data set. 

SELECT 
  SUBSTR(Name, 1, INSTR(Name, ' ') - 1) AS FirstName,
  COUNT(*) AS Frequency
FROM foo
WHERE TRIM(FirstName) != '' -- Exclude blank names
GROUP BY FirstName
ORDER BY Frequency DESC
LIMIT 5;