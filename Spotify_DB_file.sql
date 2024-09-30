-- Advance SQL Project -- Spotify Dataset

-- create table

create table spotify (
artist varchar(255),
track varchar(255),
album varchar(255),
album_type varchar(50),
danceability float,
energy float,
loudness float,
speechiness float,
acousticness float,
instrumentalness float,
liveness float,
valence float,
tempo float,
duration_min float,
title varchar(255),
channel varchar(255),
views float,
likes bigint,
comment bigint,
licensed boolean,
office_video boolean,
stream bigint,
energy_liveness float,
most_played_on varchar(50)
);

select * from spotify;

-- EDA --

select count(*) from spotify;

select count(distinct artist) from spotify;

select count(distinct album) from spotify;

select distinct album_type from spotify;

select distinct channel from spotify;

select duration_min from spotify;
select max(duration_min) from spotify;
select min(duration_min) from spotify;

select * from spotify
where duration_min =0;

delete from spotify
where duration_min =0;

select distinct most_played_on from spotify;

-- ----------------------------------------------------------
-- Data analysis easy level 
-- ----------------------------------------------------------

-- 1. Retrieve the names of all tracks that have more than 1 billion streams.

select * from spotify
where stream > 1000000000;

-- 2. List all albums along with their respective artists.

select 
    distinct album, artist
from spotify
order by 1;

select 
    distinct album
from spotify
order by 1;

-- 3. Get the total number of comments for tracks where licensed = TRUE.

select * from spotify
where licensed = 'true';

--for check the all distinct type of licensed
select 
SUM (comment) as total_comments
from spotify
where licensed = 'true';

-- 4. Find all tracks that belong to the album type single.

select * from spotify
where album_type = 'single';

-- 5. Count the total number of tracks by each artist.

select  
   artist,
   count(*) as total_no_songs
from spotify
group by artist
order by 2 desc;

-- 6. Calculate the correlation between views and likes for each artist.

select 
    artist,
    corr(views, likes) as correlation_views_likes
from 
    spotify
group by artist;


-- ----------------------------------------------------------
-- Data analysis Medium level 
-- ----------------------------------------------------------

-- 1. Calculate the average danceability of tracks in each album.

select 
    album,
	avg(danceability) as average_danceability
from spotify
group by 1
order by 2 desc;

-- 2. Find the top 5 tracks with the highest energy values.

select 
   track,
   max(energy)
from spotify
group by 1
order by 2 desc
limit 5;

-- 3. List all tracks along with their views and likes where official_video = TRUE.

select 
   track,
   sum(views) as total_views,
   sum(likes) as total_likes
from spotify
where office_video = 'true'
group by 1
order by 2 desc;

-- 4. For each album, calculate the total views of all associated tracks.

select * from spotify

select 
   album,
   track,
   sum(views)
from spotify 
group by 1,2
order by 3 desc;

-- 5. Retrieve the track names that have been streamed on Spotify more than YouTube.

select * from spotify

select * from  
(select
   track,
   --most_played_on,
   coalesce(sum(case when most_played_on = 'Youtube' then stream end),0) as streamed_on_youtube,
   coalesce(sum(case when most_played_on = 'Spotify' then stream end),0) as streamed_on_spotify
from spotify
group by 1
) as t1
where 
   streamed_on_spotify > streamed_on_youtube
   and
   streamed_on_youtube <> 0;


 -- 6. Which album types (album_type) generate the most streams?

 select 
    album_type,
    sum(stream) as total_streams
from 
    spotify
group by 
    album_type
order by 
    total_streams desc;

-- 7. Find the top 10 most popular tracks (by views) that have low valence, and what is their average energy.

select 
    track,
    views,
    valence,
    avg(energy) as avg_energy
from 
    spotify
where 
    valence < 0.3 -- considering low valence as a value below 0.3
group by 
    track, views, valence
order by 
    views desc
limit 10;

-- ----------------------------------------------------------
-- Data analysis advance level 
-- ----------------------------------------------------------

-- 1. Find the top 3 most-viewed tracks for each artist using window functions.

-- each artist and total view for each track
-- track with highest view for each artist (we need top)
-- dense rank 
-- cte and finder rank <= 3

with ranking_artist
as
(select 
    artist,
    track,
    sum(views) as total_view,
	dense_rank() over(partition by artist order by sum(views)desc) as rank
from spotify
group by 1,2
order by 1,3 desc
)
select * from ranking_artist
where rank <= 3;


-- 2. Write a query to find tracks where the liveness score is above the average.

select track, artist, liveness from spotify
where liveness > (select 
   avg(liveness)
from spotify);

-- 3. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

with cte
as
(select 
    album,
	max(energy) as highest_energy,
	Min(energy) as lowest_energy
from spotify
group by 1
)
select 
	album,
	highest_energy-lowest_energy as energy_difference
from cte
order by 2 desc;


-- 4. Find tracks where the energy-to-liveness ratio is greater than 1.2.

select 
   track,
   artist,
   energy,
   liveness,
   (energy / liveness) as energy_to_liveness_ratio
from spotify
where (energy / liveness) > 1.2;


-- 5. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
   
select 
   track,
   artist,
   views,
   likes,
   sum(likes) over (order by views desc) as cumulative_likes
from spotify
order by views desc;


-- 6. Calculate the percentage of total streams that each artist contributes relative to the overall streams on the platform.

with total_streams as (
    select sum(stream) as total_streams
    from spotify
)
select 
    artist,
    sum(stream) as artist_streams,
    round((sum(stream) * 100.0) / (select total_streams from total_streams), 2) as stream_percentage
from 
    spotify
group by artist
order by artist_streams desc;


-- 7. Identify the top 3 longest albums (by total track duration) for each artist.

with album_duration as (
    select 
        artist,
        album,
        sum(duration_min) as total_duration,
        rank() over (partition by artist order by sum(duration_min) desc) as rank
    from spotify
    group by artist, album
)
select 
    artist,
    album,
    total_duration
from 
    album_duration
where 
    rank <= 3
order by artist, rank;


-- 8. Find the most commented track for each album where speechiness is greater than 0.66.

with speechy_tracks as (
    select 
        album,
        track,
        comment,
        speechiness,
        rank() over (partition by album order by comment desc) as rank
    from spotify
    where speechiness > 0.66
)
select 
    album,
    track,
    comment
from 
    speechy_tracks
where rank = 1
order by album;

-- 9. Identify tracks where the tempo is in the top 10% of all tracks.

with tempo_rank as (
    select 
        track,
        tempo,
        ntile(10) over (order by tempo desc) as tempo_percentile
    from spotify
)
select 
    track,
    tempo
from 
    tempo_rank
where tempo_percentile = 1
order by tempo desc;