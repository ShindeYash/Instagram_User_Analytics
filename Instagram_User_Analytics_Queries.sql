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


# User Engagement: to find do users are still active and posting on Instagram. 
# Finding how many times does average user posts on Instagram. Also, provide the total number of photos on Instagram/total number of users.

# To Calculate Average post per user
SELECT
    (SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users) 
    AS average_photoes;

# To calculate total posts of each user.

SELECT 
    ROW_NUMBER() OVER (ORDER BY user_post_count DESC) AS index_column,
    user_id,
    user_post_count
FROM (
    SELECT user_id, COUNT(*) AS user_post_count
    FROM photos
    GROUP BY user_id
) AS user_post_counts
ORDER BY index_column;

# Bots & Fake Accounts: 
# The investors want to know if the platform is crowded with fake and dummy accounts. 
# By providing data on the users who have liked every single photo on the site. (Because normal users don’t like every photo)

select * from users;
select * from likes;

SELECT COUNT(*) FROM likes group by user_id;

SELECT
  id, username,
  (SELECT COUNT(*) FROM likes WHERE user_id = users.id) AS total_likes_per_user
FROM users
HAVING
  total_likes_per_user = (SELECT COUNT(*) FROM photos);

