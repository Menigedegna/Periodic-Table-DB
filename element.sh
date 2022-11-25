#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

DISPLAY_PROPERTIES(){
  #get data from elements
  ATOMIC_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
  ATOMIC_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
  #get data from properties
  ATOMIC_TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$1")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$1")
  ATOMIC_MELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$1")
  ATOMIC_BOIL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$1")
  #get data from types
  ATOMIC_TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$ATOMIC_TYPE_ID")

  #remove sapces from variables
  ATOMIC_NAME=$(echo $ATOMIC_NAME | sed -r 's/^ *| *$//g')
  ATOMIC_SYMBOL=$(echo $ATOMIC_SYMBOL | sed -r 's/^ *| *$//g')
  ATOMIC_TYPE=$(echo $ATOMIC_TYPE | sed -r 's/^ *| *$//g')
  ATOMIC_MASS=$(echo $ATOMIC_MASS | sed -r 's/^ *| *$//g')
  ATOMIC_MELT=$(echo $ATOMIC_MELT | sed -r 's/^ *| *$//g')
  ATOMIC_BOIL=$(echo $ATOMIC_BOIL | sed -r 's/^ *| *$//g')

  #display result
  echo "The element with atomic number $1 is $ATOMIC_NAME ($ATOMIC_SYMBOL). It's a $ATOMIC_TYPE, with a mass of $ATOMIC_MASS amu. $ATOMIC_NAME has a melting point of $ATOMIC_MELT celsius and a boiling point of $ATOMIC_BOIL celsius."
}

#if no argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else 
  #check if arg is integer
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    #get element atomic name
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
    #if not found 
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."
    else
      DISPLAY_PROPERTIES $ATOMIC_NUMBER
    fi
  else 
    #check if arg is symbol
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
    if [[ -z $ATOMIC_NUMBER ]]
    then 
      #if not check if arg is name
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
      if [[ -z $ATOMIC_NUMBER ]]
      then 
        echo "I could not find that element in the database."
      else 
        DISPLAY_PROPERTIES $ATOMIC_NUMBER
      fi
    else
      DISPLAY_PROPERTIES $ATOMIC_NUMBER
    fi
  fi
fi


