#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")

# Script to insert data from games.csv into games table in worldcuptest database
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $WINNER != winner ]]
then
# get team_id
TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
# if not found
if [[ -z $TEAM_ID ]] #checks if empty
then
# insert winner
echo $($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
fi
# get team_id
TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
# if not found
if [[ -z $TEAM_ID ]] #checks if empty
then
# insert loser
echo $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
fi
fi

if [[ $YEAR != year ]]
then
# lookup winner id
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
# lookup opponent id
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
# insert all data into games table
echo $($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES('$YEAR', '$ROUND', '$WINNER_GOALS', '$OPPONENT_GOALS', '$WINNER_ID', '$OPPONENT_ID')")
fi
done