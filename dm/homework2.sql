# QUERY 1 #
# SLOW #     
## Info on a specific Actor works with a budget of 30$
USE dm_hw22;
SELECT F.DVD_Title, F.Studio, F.Sound, F.Version, F.Genre, F.Year, F.Price, F.UPC, F.Status
FROM (SELECT df.DVD_id
		FROM actor_to_film AS df JOIN actors AS d ON df.Actor_id = d.Actor_id
		WHERE d.Name LIKE 'Jackson Samuel%') as D JOIN film F ON D.DVD_id = F.ID
WHERE F.Price < 30;

# FAST #
## Info on a specific Actor works with a budget of 30$
USE dm_hw1;
SELECT F.DVD_Title, F.Studio, F.Sound, F.Version, F.Genre, F.Year, F.Price, F.UPC, F.Status
FROM (SELECT df.DVD_id
		FROM actor_to_film AS df JOIN actors AS d ON df.Actor_id = d.Actor_id
		WHERE d.Name LIKE 'Jackson Samuel%') as D JOIN film F ON D.DVD_id = F.ID
WHERE F.Price < 30;

# QUERY 2 #
# SLOW #
## All DVDs released during summer
USE dm_hw22;
SELECT DVD_Title, DVD_Release, Genre
FROM film
WHERE DVD_Release BETWEEN '6/1/' AND '9/31/'
ORDER BY DVD_Release;

# FAST #
## All DVDs released during summer
USE dm_hw1;
SELECT DVD_Title, DVD_Release, Genre
FROM film
WHERE DVD_Release BETWEEN '6/1/' AND '9/31/'
ORDER BY DVD_Release;

# QUERY 3 #
# SLOW #
## Number, greater than 10, of different Directors for each actor
USE dm_hw22;
SELECT DA.Actor_id, A.Name, DA.Count
FROM (SELECT af.Actor_id, COUNT(*) as Count
	  FROM director_to_film AS df JOIN actor_to_film AS af ON df.DVD_id = af.DVD_id
      GROUP BY af.Actor_id) as DA, actors as A
WHERE DA.Actor_id = A.Actor_id
HAVING DA.Count > 10
ORDER BY DA.Count DESC;

# FAST #
## Number, greater than 10, of different Directors for each actor
USE dm_hw1;
SELECT DA.Actor_id, A.Name, DA.Count
FROM (SELECT af.Actor_id, COUNT(*) as Count
	  FROM director_to_film AS df JOIN actor_to_film AS af ON df.DVD_id = af.DVD_id
      GROUP BY af.Actor_id) as DA, actors as A
WHERE DA.Actor_id = A.Actor_id
HAVING DA.Count > 10
ORDER BY DA.Count DESC;

# QUERY 4 #
# SLOW #
## All the DVDs that have an actor named Lee or similar
USE dm_hw22;
SELECT F.DVD_Title, F.Price, F.Genre, F.Version as Format
FROM film as F 
WHERE F.ID IN (SELECT D.DVD_id
			     FROM actor_to_film as D
                 WHERE D.Actor_id IN (SELECT A.Actor_id
									  FROM actors as A
                                      WHERE A.Name LIKE 'Lee%'))
LIMIT 100;

# FAST #
## All the DVDs that have an actor named Lee or similar
USE dm_hw1;
SELECT F.DVD_Title, F.Price, F.Genre, F.Version as Format
FROM film as F 
WHERE F.ID IN (SELECT D.DVD_id
			     FROM actor_to_film as D
                 WHERE D.Actor_id IN (SELECT A.Actor_id
									  FROM actors as A
                                      WHERE A.Name LIKE 'Lee%'));
                                      
# QUERY 5 #
# W/O VIEW #
## Out of productions DVD on 50% sale
USE dm_hw1;
SELECT DVD_Title, Price, Status, ROUND(0.5*Price, 2) AS Sales
FROM film
WHERE Status = 'Discontinued'; 

# WITH VIEW #
## Out of productions DVD on 50% sale
USE dm_hw1;
SELECT *, ROUND(0.5*Price, 2) AS Sales
FROM view_disc;

# QUERY 6 #
# W/O VIEW & REFORMULATION
## All the DVDs that have an actor named Lee or similar 
SELECT F.DVD_Title, F.Price, F.Genre, F.Version as Format
FROM film as F 
WHERE F.ID IN (SELECT D.DVD_id
			     FROM actor_to_film as D
                 WHERE D.Actor_id IN (SELECT A.Actor_id
									  FROM actors as A
                                      WHERE A.Name LIKE 'Lee%'));
                                      
# WITH VIEW & REFORMULATION
## All the DVDs that have an actor named Lee or similar
SELECT F.DVD_Title, F.Price, F.Genre, F.Version as Format
FROM film as F, Lee
WHERE F.ID IN (Lee.DVD_id);