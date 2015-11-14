-- TABLE definitions for the tournament project.

DROP DATABASE if exists tournament;

CREATE DATABASE tournament;

\c tournament;

-- TABLE of players:
--  includes id for each player (auto generated) and the player's name
CREATE TABLE players
	(id serial PRIMARY KEY,
	 player_name text);

-- TABLE of matches played:
--  includes ids for each player in each match (from players table),
--  the number of the current round, and the id of the winning player
CREATE TABLE matches
	(player1_id integer REFERENCES players(id),
	 player2_id integer REFERENCES players(id),
	 round integer,
	 winner_id integer REFERENCES players(id));

-- Example VALUES to populate the database with 8 players and 16 matches ++++++++++++++++

INSERT INTO players (player_name) VALUES ('John Hancock');
INSERT INTO players (player_name) VALUES ('Betty Lu');
INSERT INTO players (player_name) VALUES ('Don Kong');
INSERT INTO players (player_name) VALUES ('Bobba Fett');
INSERT INTO players (player_name) VALUES ('Yan Dan');
INSERT INTO players (player_name) VALUES ('Kekei Genkai');
INSERT INTO players (player_name) VALUES ('Tororo Ichiban');
INSERT INTO players (player_name) VALUES ('Squee McGee');

INSERT INTO matches VALUES (1,2,1,1);
INSERT INTO matches VALUES (3,4,1,3);
INSERT INTO matches VALUES (5,6,1,5);
INSERT INTO matches VALUES (7,8,1,7);
INSERT INTO matches VALUES (1,3,2,1);
INSERT INTO matches VALUES (5,7,2,5);
INSERT INTO matches VALUES (2,4,2,2);
INSERT INTO matches VALUES (6,8,2,6);
INSERT INTO matches VALUES (1,5,3,1);
INSERT INTO matches VALUES (2,3,3,2);
INSERT INTO matches VALUES (6,7,3,6);
INSERT INTO matches VALUES (4,8,3,4);
INSERT INTO matches VALUES (1,2,4,1);
INSERT INTO matches VALUES (5,6,4,5);
INSERT INTO matches VALUES (3,4,4,3);
INSERT INTO matches VALUES (7,8,4,7);

-- End of example VALUES ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- VIEW of wins showing wins per player:
--  displays id for each player, each player's name,
--  and number of wins for each player. This VIEW is used to create the win_loss VIEW
--  (below) and to calculate the overall winner(s) VIEW (below)
CREATE VIEW wins
	AS SELECT players.id AS player, players.player_name, count(matches.winner_id) AS wins
		FROM players LEFT JOIN matches
			ON (matches.winner_id = players.id)
				GROUP BY players.id
				ORDER BY wins DESC;

-- VIEW of wins and losses per player (created from wins VIEW):
--  displayes the same colums as wins,
--  with additional column for losses
CREATE VIEW wins_losses
	AS SELECT wins.player_name, wins.wins,
	(max_round.max - wins.wins) AS losses
		FROM wins, (SELECT max(round) FROM matches) AS max_round
			ORDER BY wins.wins DESC;

-- VIEW of the overall winner(s) (created from wins VIEW):
--  displays the tournament partipant with the highest
--  number of wins. Shows multiple participants if they
--  have an equal number of wins.
CREATE VIEW winner
	AS SELECT wins.player_name
		FROM wins, (SELECT max(wins) FROM wins) AS winner
			WHERE winner.max = wins.wins;

-- Show all relevant TABLES and VIEWS
SELECT * FROM players;
SELECT * FROM matches;
SELECT * FROM wins_losses;
SELECT * FROM winner;