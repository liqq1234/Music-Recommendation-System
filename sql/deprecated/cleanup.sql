USE music_recommendation;
DELETE FROM playlist_music;
DELETE FROM playlist;
DELETE FROM play_history;
DELETE FROM collection;
DELETE FROM rating;
DELETE FROM music;
DELETE FROM user WHERE role != 2;
