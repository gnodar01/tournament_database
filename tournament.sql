-- TABLE definitions for the tournament project.

drop database if exists tournament;

create database tournament;

\c tournament;

-- TABLE of players:
--  includes id for each player (auto generated) and the player's name
create table players
	(id serial primary key,
	 player_name text);

-- TABLE of matches played:
--  includes ids for each player in each match (from players table),
--  the number of the current round, and the id of the winning player
create table matches
	(player_1 integer references players(id),
	 player_2 integer references players(id),
	 round integer,
	 winner integer references players(id));

-- Example values to populate the database with 8 players and 16 matches ++++++++++++++++

insert into players (player_name) values ('John Hancock');
insert into players (player_name) values ('Betty Lu');
insert into players (player_name) values ('Don Kong');
insert into players (player_name) values ('Bobba Fett');
insert into players (player_name) values ('Yan Dan');
insert into players (player_name) values ('Kekei Genkai');
insert into players (player_name) values ('Tororo Ichiban');
insert into players (player_name) values ('Squee McGee');

insert into matches values (1,2,1,1);
insert into matches values (3,4,1,3);
insert into matches values (5,6,1,5);
insert into matches values (7,8,1,7);
insert into matches values (1,3,2,1);
insert into matches values (5,7,2,5);
insert into matches values (2,4,2,2);
insert into matches values (6,8,2,6);
insert into matches values (1,5,3,1);
insert into matches values (2,3,3,2);
insert into matches values (6,7,3,6);
insert into matches values (4,8,3,4);
insert into matches values (1,2,4,1);
insert into matches values (5,6,4,5);
insert into matches values (3,4,4,3);
insert into matches values (7,8,4,7);

-- End of example values ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- VIEW of wins showing wins per player:
--  displays id for each player, each player's name,
--  and number of wins for each player. This VIEW is used to create the win_loss VIEW
--  (below) and to calculate the overall winner(s) VIEW (below)
create view wins
	as select players.id as player, players.player_name, count(matches.winner) as wins
		from players left join matches
			on (matches.winner = players.id)
				group by players.id
				order by wins desc;

-- VIEW of wins and losses per player (created from wins VIEW):
--  displayes the same colums as wins,
--  with additional column for losses
create view wins_losses
	as select wins.player, wins.player_name, wins.wins,
	(max_round.max - wins.wins) as losses
		from wins, (select max(round) from matches) as max_round
			order by wins.wins desc;

-- VIEW of the overall winner(s) (created from wins VIEW):
--  displays the tournament partipant with the highest
--  number of wins. Shows multiple participants if they
--  have an equal number of wins.
create view winner
	as select wins.player_name
		from wins, (select max(wins) from wins) as winner
			where winner.max = wins.wins;

-- Show all relevant TABLES and VIEWS
select * from players;
select * from matches;
select * from wins_losses;
select * from winner;