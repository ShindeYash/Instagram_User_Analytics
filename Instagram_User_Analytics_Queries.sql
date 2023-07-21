# Selected the provided database (ig_clone)
use ig_clone;

# (1) Rewarding most loyal users
# That means, Finding 5 oldest users of the Instagram from the database.

SELECT 
    username, created_at
FROM
    users
WHERE
    username IS NOT NULL
ORDER BY created_at ASC
LIMIT 5;

# (2) Remind Inactive Users to Start Posting. 
# Reminding Users who has not posted any photo on Instagram. That means, finding users who have never posted a single photo on Instagram.

select * from photos;
select * from photo_tags;
select * from users;
select * from likes;

SELECT username, id AS user_id
FROM users
WHERE id NOT IN (
    SELECT DISTINCT user_id
    FROM photos
)
ORDER BY id;

# (3) Declaring Contest Winner 
#  Identifying the winner of the contest by finding that user who has got most likes on a single photo.

select count(*) from likes;

select photo_id from likes
group by photo_id;

SELECT users.id AS user_id, users.username, photos.id AS photo_id,
	count(*) AS total
FROM photos
INNER JOIN likes ON likes.photo_id = photos.id
INNER JOIN users ON photos.user_id = users.id
GROUP BY photos.id
ORDER BY total DESC
LIMIT 1;


# Hashtag Researching 
# A partner brand wants to know, which hashtags to use in the post to reach the most people on the platform. Thus, finding the top 5 most commonly used hashtags on the platform.


select * from tags;
select * from photo_tags;

SELECT photo_tags.tag_id AS tag_id,
    tags.tag_name AS tag_name, COUNT(*) AS total
FROM photo_tags INNER JOIN
    tags ON photo_tags.tag_id = tags.id
GROUP BY tag_name
ORDER BY total DESC
LIMIT 5;

# Launch AD Campaign.
# Finding the day of the week when most users register. To provide insights on when to schedule an ad campaign.

select * from users;

SELECT dayname(created_at) AS day_of_week,
       COUNT(*) AS total
FROM users
GROUP BY day_of_week
ORDER BY total DESC;




