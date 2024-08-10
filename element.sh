#!/bin/bash

# Database query command
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if no argument is provided
if [ -z "$1" ]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# Determine if input is a number (atomic number) or string (symbol or name)
if [[ $1 =~ ^[0-9]+$ ]]; then
  QUERY_CONDITION="elements.atomic_number = $1"
else
  QUERY_CONDITION="elements.symbol = '$1' OR elements.name = '$1'"
fi

# Query the database
ELEMENT=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number = properties.atomic_number JOIN types ON properties.type_id = types.type_id WHERE $QUERY_CONDITION;")

# If the element isn't found
if [ -z "$ELEMENT" ]; then
  echo "I could not find that element in the database."
  exit 0
fi

# Parse the result
echo $ELEMENT | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
done
