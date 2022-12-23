/*Challenge 1 : Reward our users who have been around the longest.  
The 5 oldest users.*/
SELECT * FROM users
ORDER BY created_at 
LIMIT 5;
#--------------------------------------------------------------------------------
/*
Challenge 2 : We need to figure out when to schedule an ad campgain
So we will find at What day of the week do most users register on*/

SELECT date_format(created_at,'%W') AS 'day of the week', COUNT(*) AS 'total registration'
FROM users
GROUP BY 1 #In the query GROUP BY 1 refers to the 1st column in select statement which is day of the week
ORDER BY 2 DESC; # In the query Order BY 2 refers to the 2nd column in select statement which is 'total registration'.
/*Alternative Solution*/
SELECT DAYNAME(created_at) AS day, COUNT(*) AS total
FROM users
GROUP BY day
ORDER BY total DESC;
#--------------------------------------------------------------------------------
/*Challenge 3 :  To target all inactive users with an email campaign.
So we will Find the users who have never posted a photo*/

SELECT username
FROM users
LEFT JOIN photos ON users.id = photos.user_id
WHERE photos.id IS NULL;

#--------------------------------------------------------------------------------
/*We're running a new contest to see who can get the most likes on a single photo.
WHO WON??!!*/
SELECT users.username,photos.id,photos.image_url,COUNT(*) AS Total_Likes
FROM likes
JOIN photos ON photos.id = likes.photo_id
JOIN users ON users.id = likes.user_id
GROUP BY photos.id
ORDER BY Total_Likes DESC
LIMIT 1;
/*Alternative Solution*/
SELECT username,photos.id, photos.image_url, COUNT(*) AS total
FROM photos
INNER JOIN likes ON likes.photo_id = photos.id
INNER JOIN users ON photos.user_id = users.id
GROUP BY photos.id
ORDER BY total DESC
LIMIT 5;
#--------------------------------------------------------------------------------
/*Challenge 4 : Our Investors want to know... How many times does the average user post?*/
/*So we will find total number of photos/total number of users*/
SELECT ROUND((SELECT COUNT(*)FROM photos)/(SELECT COUNT(*) FROM users),2) AS AVG_PHOTOS;
#--------------------------------------------------------------------------------
/*Challenge 5 : user ranking by postings higher to lower*/
SELECT users.username , COUNT(photos.image_url) AS POSTS_RANKING
FROM users
JOIN photos ON users.id = photos.user_id
GROUP BY users.id
ORDER BY 2 DESC;
#--------------------------------------------------------------------------------
/*Challenge 6 : Total Posts by users (longer versionof SELECT COUNT(*)FROM photos) */
SELECT SUM(user_posts.total_posts_per_user)
FROM 
(SELECT users.username , COUNT(photos.image_url) AS total_posts_per_user
		FROM users
		JOIN photos ON users.id = photos.user_id
		GROUP BY users.id) AS user_posts;
/*Individual Post by users on  ig*/

SELECT users.* , COUNT( photos.image_url ) 
FROM users
LEFT JOIN photos ON users.id = photos.user_id
GROUP BY users.id;
#--------------------------------------------------------------------------------
/*Challenge 7 : Total count of numbers of users who have posted at least one time */

SELECT COUNT(DISTINCT(users.id)) AS total_number_of_users_with_posts
FROM users
JOIN photos ON users.id = photos.user_id;

#--------------------------------------------------------------------------------

/*Challenge 8 : A brand wants to know which hashtags to use in a post
So we will find the top 5 most commonly used hashtags?*/

SELECT tag_name, COUNT(tag_name) AS total
FROM tags
JOIN photo_tags ON tags.id = photo_tags.tag_id
GROUP BY tags.id
ORDER BY total DESC
LIMIT 5;
#--------------------------------------------------------------------------------
#Challenge 9: Find users who have never commented on a photo.
SELECT username,comment_text
FROM users
LEFT JOIN comments ON users.id = comments.user_id
GROUP BY users.id
HAVING comment_text IS NULL;
/*Alternative Solution */
SELECT COUNT(*) FROM
(SELECT username,comment_text
	FROM users
	LEFT JOIN comments ON users.id = comments.user_id
	GROUP BY users.id
	HAVING comment_text IS NULL) AS total_number_of_users_without_comments;

#--------------------------------------------------------------------------------

/*Challenge 10 : Find the percentage of our users who have either never commented on a photo or have commented on photos before*/
SELECT tableA.total_A AS 'Number Of Users who never commented',
		(tableA.total_A/(SELECT COUNT(*) FROM users))*100 AS '%',
		tableB.total_B AS 'Number of Users who commented on photos',
		(tableB.total_B/(SELECT COUNT(*) FROM users))*100 AS '%'
FROM
	(
		SELECT COUNT(*) AS total_A FROM
			(SELECT username,comment_text
				FROM users
				LEFT JOIN comments ON users.id = comments.user_id
				GROUP BY users.id
				HAVING comment_text IS NULL) AS total_number_of_users_without_comments
	) AS tableA
	JOIN
	(
		SELECT COUNT(*) AS total_B FROM
			(SELECT username,comment_text
				FROM users
				LEFT JOIN comments ON users.id = comments.user_id
				GROUP BY users.id
				HAVING comment_text IS NOT NULL) AS total_number_users_with_comments
	)AS tableB