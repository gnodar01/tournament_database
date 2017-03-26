# README

A backend implementation of a [Swiss-system tournament](https://en.wikipedia.org/wiki/Swiss-system_tournament), utilizing [Psycopg2](http://initd.org/psycopg/).

The `Vagrantfile` and corresponding `pg_config` contain all of the required components for running the tournament database. `tournament.sql` is used to initialize the database. `tournament.py` contains all methods needed to interact with the tournament database. `tournament_test.py` contains 8 tests to ensure everything is running smoothly.

## Running the tournament database
- For an identical development environment, install [Vagrant](https://www.vagrantup.com/)
- Vagrant can run on top of many VMs. For a free option install [VirtualBox](https://www.virtualbox.org/wiki/VirtualBox).
- `cd` into the project directory
- Initialize Vagrant with `vagrant up`
- SSH into Vagrant with `vagrant ssh`
- From within the VM `cd` into the shared directory: `cd /vagrant`
- Initialize the database: `psql -f tournament.sql`
- Run the tests: `python tournament_test.py`. All 8 tests should pass.
  - WARNING: Running these tests will delete any records already populated within the database
- If you would like to pre-populate the tournament database with example values: uncomment the insertions contained in the tournament.sql file, before running