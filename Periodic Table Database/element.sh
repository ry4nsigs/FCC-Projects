# This Script returns information about an input element
# Input can be in the form of name, atomic number, or element symbol

# Creating database interaction variable
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Checking whether user input exists
if [[ $1 ]]
then
ELEMENT=$1
  # Check whether input is a number
  if [[ "$ELEMENT" =~ ^-?[0-9]+$ ]]
  # Search atomic number column
  then
  CHECK=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$ELEMENT")
  # Check string has more than two characters
  else
    if [[ ${#ELEMENT} -gt 2 ]]
    # Search name column
    then
    CHECK=$($PSQL "SELECT atomic_number FROM elements WHERE name='$ELEMENT'")
    #Search symbol column
    else
    CHECK=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$ELEMENT'")
    fi
  fi
  # Checking whether user input exists in database
  if [[ ! -z $CHECK ]]
  then
  # Get element information
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number='$CHECK'")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number='$CHECK'")
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number='$CHECK'")
  TYPE=$($PSQL "SELECT type FROM types right JOIN properties USING(type_id) WHERE type_id=$TYPE_ID LIMIT 1")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number='$CHECK'")
  MELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number='$CHECK'")
  BOIL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number='$CHECK'")
  # Print element information
  echo "The element with atomic number $CHECK is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  else
  # Print error message if not in database
  echo "I could not find that element in the database."
  fi
#Returning error message if shell was run without input
else
echo "Please provide an element as an argument."
fi
