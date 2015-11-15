-- TABLE definitions for the tournament project.

DROP DATABASE IF EXISTS tournament;

CREATE DATABASE tournament;

\c tournament;

-- TABLE of players:
--  includes id for each player (auto generated) and the player's name
CREATE TABLE players
	(player_id SERIAL PRIMARY KEY,
	 player_name TEXT);

-- TABLE of matches played:
--  includes the id of the match, id of the winner of the match (from players table),
--  id of the loser of the match, and the number of the current round
CREATE TABLE matches
	(match_id SERIAL PRIMARY KEY,
	 winner_id INTEGER REFERENCES players(player_id),
	 loser_id INTEGER REFERENCES players(player_id),
	 round INTEGER);

-- Example VALUES to populate the database with 8 players and 16 matches ++++++++++++++++

INSERT INTO players (player_name) VALUES ('John Hancock');
INSERT INTO players (player_name) VALUES ('Betty Lu');
INSERT INTO players (player_name) VALUES ('Don Kong');
INSERT INTO players (player_name) VALUES ('Bobba Fett');
INSERT INTO players (player_name) VALUES ('Yan Dan');
INSERT INTO players (player_name) VALUES ('Kekei Genkai');
INSERT INTO players (player_name) VALUES ('Tororo Ichiban');
INSERT INTO players (player_name) VALUES ('Squee McGee');

INSERT INTO matches (winner_id, loser_id, round) VALUES (1,2,1);
INSERT INTO matches (winner_id, loser_id, round) VALUES (3,4,1);
INSERT INTO matches (winner_id, loser_id, round) VALUES (5,6,1);
INSERT INTO matches (winner_id, loser_id, round) VALUES (7,8,1);
INSERT INTO matches (winner_id, loser_id, round) VALUES (1,3,2);
INSERT INTO matches (winner_id, loser_id, round) VALUES (5,7,2);
INSERT INTO matches (winner_id, loser_id, round) VALUES (2,4,2);
INSERT INTO matches (winner_id, loser_id, round) VALUES (6,8,2);
INSERT INTO matches (winner_id, loser_id, round) VALUES (1,5,3);
INSERT INTO matches (winner_id, loser_id, round) VALUES (2,3,3);
INSERT INTO matches (winner_id, loser_id, round) VALUES (6,7,3);
INSERT INTO matches (winner_id, loser_id, round) VALUES (4,8,3);
INSERT INTO matches (winner_id, loser_id, round) VALUES (1,2,4);
INSERT INTO matches (winner_id, loser_id, round) VALUES (5,6,4);
INSERT INTO matches (winner_id, loser_id, round) VALUES (3,4,4);
INSERT INTO matches (winner_id, loser_id, round) VALUES (7,8,4);

-- End of example VALUES ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- VIEW of the wins/losses record and the number of rounds for each player:
--  displays id for each player, each player's name,
--  number of wins for each player, number of losses for each player,
--  and the number of rounds each player has participated in

CREATE VIEW win_loss AS
	SELECT wins.player, wins.player_name, wins.num_wins, losses.num_losses,
	(wins.num_wins + losses.num_losses) AS num_rounds
		From
			(SELECT players.player_id AS player, players.player_name,
				COUNT(matches.winner_id) as num_wins
					FROM players LEFT JOIN matches
						ON (matches.winner_id = players.player_id)
							GROUP BY players.player_id) as wins 
		INNER JOIN
			(SELECT players.player_id AS player, players.player_name,
				COUNT(matches.loser_id) as num_losses
					FROM players LEFT JOIN matches
						ON (matches.loser_id = players.player_id)
							GROUP BY players.player_id) as losses
		ON (wins.player = losses.player);

-- Show all relevant TABLES and VIEWS
SELECT * FROM players;
SELECT * FROM matches;
SELECT * FROM win_loss;
