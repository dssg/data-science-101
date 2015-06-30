`data_definition_language` is code that demonstrates ways to create and alter tables 
in ways that hopefully clarify how Postgres works. `default_profile` is an example 
file to set your Postgres environmental variables. It cleans your code -- you don't
need to specify the hostname, username, database, and password every time you invoke
psql -- and increases security. Add that file to your .gitignore so your sensitive 
login information stays out of your repo.
