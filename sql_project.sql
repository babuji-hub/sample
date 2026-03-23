 use zepto_sql_project
 ...netflix project...
 
 create table netflix_titles(
 show_id varchar(100),
 type varchar(100),
 title  varchar(100),
 director  varchar(100),
 cast  varchar(100),
 country  varchar(100),
 date_added date,
 release_year int,
 rating  varchar(100),
 duration  varchar(100),
 listed_in  varchar(100),
 description  varchar(100)
 );
  
   
  select * from netflix_titles;
  select count(*) from netflix_titles;
  ##distinct type..
  select distinct (type) from netflix_titles;
  
  
  .... 15 Business problems & solutions...
  
  1.Count the number of movies vs tv shows

solution...
    select type,count(*) as both_total from netflix_titles group by type;
  #select type,count(type) from netflix_titles where type='movie'group by type;
  
  
  
  2.find the most common rating for movies and tv shows
  solution...
  #select type,rating ,count(*)  as count from netflix_titles group by  type,rating order by type,rating  desc ;
   select type,
   rating 
   from
   (select 
    type,
    rating,
    count(*), as total_value
    rank() over(partition by type order by count(*) desc)
    as rank_method from  
    netflix_titles
    group by  type,rating)
    as subfunction
    where rank_method=1;
     
   
  3.list all movies released in a specific year(eg..2020)
  solution....
  #select release_year,title from netflix_titles where release_year like '2020';
  SELECT release_year, title 
FROM netflix_titles 
WHERE release_year = 2020;
  
  4.find the top 5 countries with the most content on netflix
  solution....
  SELECT country, COUNT(*) AS total_content
FROM netflix_titles
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_content DESC
LIMIT 5;

  
  
  5.identify the longest movies or tv show duration
  solution....
   SELECT MAX(CAST(REPLACE(TRIM(duration), ' min', '') AS SIGNED)) AS longest_movie
FROM netflix_titles
WHERE type = 'Movie'
  AND duration LIKE '%min%';

  
  6.find content added in the last 5 years
  solution...
  SELECT *
FROM netflix_titles
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= CURDATE() - INTERVAL 5 YEAR;

  # select director from netflix_titles  where director='rajiv chilaka';
  
  7.find all the movies/tv shows by director "rajiv chilaka"
  solution...
  SELECT title, type, director
FROM netflix_titles
WHERE director = 'Rajiv Chilaka';

   9.count the number of content items in each genre
   solution...
   SELECT listed_in AS genre,
       COUNT(*) AS total_count
FROM netflix_titles
GROUP BY listed_in
ORDER BY total_count DESC;
   
  10.find the avg release year for content produced in a specific country
  solution...
  select country ,avg(release_year) from netflix_titles where  country ='south africa' group by country;
    SELECT country,
       AVG(release_year) AS avg_release_year
FROM netflix_titles
WHERE country = 'India'   
GROUP BY country;                                                                           # select * from netflix_titles;
  11.list all movies that are documenataries
  solution...
  select type from netflix_titles where listed_in ='documenataries'group by type ;
  SELECT title, type, listed_in, release_year
FROM netflix_titles
WHERE type = 'Movie'
  AND listed_in LIKE '%Documentary%';
  12.find all content without a director
  solution...
  SELECT title, type, listed_in, release_year
FROM netflix_titles
WHERE director IS NULL  OR director = '';
																			    # select * from netflix_titles;
  13.find how many movies actor "salman khan" appeared in last 10 year!
  solution....
  SELECT COUNT(*) AS movie_count
FROM netflix_titles
WHERE type = 'Movie'
  AND cast LIKE '%Salman Khan%'
  AND release_year >= YEAR(CURDATE()) - 10;
  
  
  14.find the top 10 actors who have appeared in the highest num of movies produced in
  solution...
 SELECT actor_name, COUNT(*) AS movie_count
FROM (
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', numbers.n), ',', -1)) AS actor_name
    FROM netflix_titles
    JOIN (
        SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
        UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
        UNION ALL SELECT 9 UNION ALL SELECT 10
    ) numbers
    WHERE type = 'Movie' AND country LIKE '%India%'
) AS actors_split
WHERE actor_name <> ''
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 10;  
  15.categories the content based on the presence of the keywords "kill" and "voilence" in the
	description field.label content containing these keywords as "bad" and all other content as "good".
    count how many items fall into each category....
    solution..
    SELECT 
    CASE 
        WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'bad'
        ELSE 'good'
    END AS content_category,
    COUNT(*) AS total_count
FROM netflix_titles
GROUP BY content_category;
    
    
    
    