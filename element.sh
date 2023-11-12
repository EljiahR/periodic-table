#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  SELECTED_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
  if [[ -z $SELECTED_ATOMIC_NUMBER ]]
  then
    SELECTED_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
  fi
  if [[ -z $SELECTED_ATOMIC_NUMBER ]]
  then
    SELECTED_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
  fi
  if [[ -z $SELECTED_ATOMIC_NUMBER ]]
  then
    echo 'I could not find that element in the database.'
  else 
    ELEMENT_INFO=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) WHERE atomic_number = $SELECTED_ATOMIC_NUMBER")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $SELECTED_ATOMIC_NUMBER")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $SELECTED_ATOMIC_NUMBER")
    TYPE=$($PSQL "SELECT type FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $SELECTED_ATOMIC_NUMBER")
    MASS=$($PSQL "SELECT atomic_mass FROM elements FULL JOIN properties USING(atomic_number) WHERE atomic_number = $SELECTED_ATOMIC_NUMBER")
    MELT_POINT=$($PSQL "SELECT melting_point_celsius FROM elements FULL JOIN properties USING(atomic_number) WHERE atomic_number = $SELECTED_ATOMIC_NUMBER")
    BOIL_POINT=$($PSQL "SELECT boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) WHERE atomic_number = $SELECTED_ATOMIC_NUMBER")
    echo "The element with atomic number $SELECTED_ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
  fi
fi
