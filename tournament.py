#!/usr/bin/env python
#
# tournament.py -- implementation of a Swiss-system tournament

import psycopg2


def connect():
    """Connect to the PostgreSQL database.  Returns a database connection."""
    try:
        conn = psycopg2.connect("dbname=tournament")
        c = conn.cursor()
        return conn, c
    except:
        print("<error - failed to connect>")


def deleteMatches():
    """Remove all the match records from the database."""
    conn, c = connect()
    SQL = "DELETE FROM matches *;"
    c.execute(SQL)
    conn.commit()
    conn.close()


def deletePlayers():
    """Remove all the player records from the database."""
    conn, c = connect()
    SQL = "DELETE FROM players *;"
    c.execute(SQL)
    conn.commit()
    conn.close()


def countPlayers():
    """Returns the number of players currently registered."""
    conn, c = connect()
    SQL = "SELECT COUNT(*) AS num_players FROM players;"
    c.execute(SQL)
    row = c.fetchone()
    return row[0]


def registerPlayer(name):
    """Adds a player to the tournament database.
    The database assigns a unique serial id number for the player.  (This
    should be handled by your SQL database schema, not in your Python code.)
    Args:
      name: the player's full name (need not be unique).
    """
    conn, c = connect()
    SQL = "INSERT INTO players (player_name) VALUES (%s);"
    data = (name, )
    c.execute(SQL, data)
    conn.commit()
    conn.close()


def playerStandings():
    """Returns a list of the players and their win records, sorted by wins.

    The first entry in the list should be the player in first place,
    or a player tied for first place if there is currently a tie.

    Returns:
      A list of tuples, each of which contains (id, name, wins, matches):
        id: the player's unique id (assigned by the database)
        name: the player's full name (as registered)
        wins: the number of matches the player has won
        matches: the number of matches the player has played
    """
    conn, c = connect()
    SQL = "SELECT player_id, player_name, num_wins, num_rounds FROM win_loss;"
    c.execute(SQL)
    rows = c.fetchall()
    conn.close()
    return rows


def reportMatch(winner, loser):
    """Records the outcome of a single match between two players.

    Args:
      winner:  the id number of the player who won
      loser:  the id number of the player who lost
    """
    conn, c = connect()
    if checkDuplicates(winner, loser) == True:
        raise Exception('These two players have already been matched')
    SQL = "INSERT INTO matches (winner_id, loser_id) VALUES (%s, %s);"
    data = (winner, loser)
    c.execute(SQL, data)
    conn.commit()
    conn.close()


def swissPairings():
    """Returns a list of pairs of players for the next round of a match.

    Assuming that there are an even number of players registered, each player
    appears exactly once in the pairings.  Each player is paired with the nearest
    player with an equal or nearly-equal win record, so long as those two players
    have not previously been matched together.

    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        id1: the first player's unique id
        name1: the first player's name
        id2: the second player's unique id
        name2: the second player's name
    """
    conn, c = connect()
    SQL = "SELECT player_id, player_name FROM win_loss;"
    c.execute(SQL)
    # returns list of tuples
    rows = c.fetchall()
    pairings = []
    i = 0
    j = 1
    while len(rows) > 0:
        # if j out of index range, no previously unmatched pairing found for player 1
        if j >= len(rows):
            raise Exception('Cannot assign pairings. ' +
                            '2 or more players have already been matched together')
        player1 = rows[i][0]
        player2 = rows[j][0]
        # if player 1 and player 2 have been matched previously, go to next potential
        if checkDuplicates(player1, player2):
            j += 1
        else:
            pairings.append( rows.pop(i) + rows.pop(j - 1) )
            j = 1
    print pairings
    print rows
    conn.close()
    return rows

def checkDuplicates(player1, player2):
    """Checks if two players have been previously matched.

    Returns:
      True if players have been previously matched.
      False if players have not been previously matched.
    """
    conn, c = connect()
    SQL = """SELECT SUM(num)
                FROM
                    (SELECT match_id, winner_id, loser_id, COUNT(*) AS num
                        FROM matches
                            WHERE (winner_id = %s AND loser_id = %s)
                               OR (winner_id = %s AND loser_id = %s)
                    GROUP BY match_id)
                AS duplicates;"""
    data = (player1, player2, player2, player1)
    c.execute(SQL, data)
    row = c.fetchone()
    if row[0] != None:
        return True
    return False


