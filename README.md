# README

The 'tournament.py' file utilizes [Psycopg2](http://initd.org/psycopg/): "the most popular PostgreSQL database adapter for the Python programming language".

## Running the tournament database
- Clone repo
- Run the 'tournament.sql' file from the terminal of a database server, with PostgreSQL installed, from your OS of choice
  - All files in this repo were developed and tested on Ubuntu 14.04.3 LTS, running on [VirtualBox (v5.0.10)](https://www.virtualbox.org/wiki/VirtualBox) VM, created and configured through [Vagrant](https://www.vagrantup.com/)
  - The Vagrant configuration files used can be found [here](https://github.com/udacity/fullstack-nanodegree-vm)
- If you would like to pre-populate the tournament databse with example values: uncomment the insertions contained in the tournament.sql file, before running
- 'tournament_test.py' contains a series of 8 tests which run through the functions contained within 'tournament.py'
  - WARNING: Running these tests will delete any records already populated within the database