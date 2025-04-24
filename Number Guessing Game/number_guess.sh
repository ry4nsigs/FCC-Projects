#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=users -t --no-align -c"

# Get username
echo "Enter your username:"
read NAME

# Check if user exists
USER_CHECK=$($PSQL "SELECT user_name FROM user_data WHERE user_name='$NAME'")

if [[ -z $USER_CHECK ]]; then
  # New user
  $PSQL "INSERT INTO user_data(user_name) VALUES('$NAME')"
  NGUESS=1000
  echo "Welcome, $NAME! It looks like this is your first time here."
else
  # Existing user
  NPLAYED=$($PSQL "SELECT wins FROM user_data WHERE user_name='$NAME'")
  NGUESS=$($PSQL "SELECT b_guess FROM user_data WHERE user_name='$NAME'")
  # Set NGUESS to 1000 if NULL
  if [[ -z $NGUESS ]]; then
    NGUESS=1000
  fi
  echo "Welcome back, $NAME! You have played $NPLAYED games, and your best game took $NGUESS guesses."
fi

# Game logic
TARGET=$((1 + RANDOM % 1000))
TRIES=0
GUESS=0

echo "Guess the secret number between 1 and 1000:"

while [[ $GUESS -ne $TARGET ]]; do
  read GUESS

  # Check if valid integer
  if ! [[ "$GUESS" =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    continue
  fi

  TRIES=$((TRIES+1))

  if [[ $GUESS -gt $TARGET ]]; then
    echo "It's lower than that, guess again:"
  elif [[ $GUESS -lt $TARGET ]]; then
    echo "It's higher than that, guess again:"
  fi
done

# Update best guess if better
if [[ $TRIES -lt $NGUESS ]]; then
  $PSQL "UPDATE user_data SET b_guess=$TRIES WHERE user_name='$NAME'" > /dev/null
fi

# Increment wins
$PSQL "UPDATE user_data SET wins = COALESCE(wins, 0) + 1 WHERE user_name='$NAME'" > /dev/null

# Final success message
echo "You guessed it in $TRIES tries. The secret number was $TARGET. Nice job!"