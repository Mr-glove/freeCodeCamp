#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

#Si no hay argumento
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
#SI hay argumento
else
  ARGUMENT=$1
  #Si no es un nmero
  if [[ ! $ARGUMENT =~ [0-9]+$ ]]
  then
    SYMBOL_READ=$($PSQL "SELECT symbol FROM properties INNER JOIN elements USING (atomic_number) WHERE symbol='$ARGUMENT';")
    NAME_READ=$($PSQL "SELECT name FROM properties INNER JOIN elements USING (atomic_number) WHERE name='$ARGUMENT';")
  
    #Si no encuentra el simbolo o nombre en la base de datos
    if [[ -z $SYMBOL_READ && -z $NAME_READ ]]
    then
      echo "I could not find that element in the database."
    #Si encuentra el simbolo o nombre en la base de datos
    else
      #Buscar informacion del elemento segun el nombre
      if [[ -z $SYMBOL_READ ]]
      then
        ELEMENT_INFO=$($PSQL "SELECT * FROM properties INNER JOIN elements USING (atomic_number) INNER JOIN types USING (type_id) WHERE name='$ARGUMENT';")
        echo "$ELEMENT_INFO" | while read TYPE_ID BAR ATOMIC_NUMBER BAR ATOMIC_MASS BAR MELTING BAR BOILING BAR SYMBOL BAR NAME BAR TYPE
        do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        done
      fi
      #Buscar informacion del elemento segun el simbolo
      if [[ -z $NAME_READ ]]
      then
        ELEMENT_INFO=$($PSQL "SELECT * FROM properties INNER JOIN elements USING (atomic_number) INNER JOIN types USING (type_id) WHERE symbol='$ARGUMENT';")
        echo "$ELEMENT_INFO" | while read TYPE_ID BAR ATOMIC_NUMBER BAR ATOMIC_MASS BAR MELTING BAR BOILING BAR SYMBOL BAR NAME BAR TYPE
        do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        done
      fi
    fi
  #Si es un numero
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM properties INNER JOIN elements USING (atomic_number) WHERE atomic_number=$ARGUMENT;")
    #Si no ecuentra el numero atomico en la base de datos
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."
    #Si encuentra el numero atomico en la base de datos
    else
      ELEMENT_INFO=$($PSQL "SELECT * FROM properties INNER JOIN elements USING (atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number=$ARGUMENT;")
        echo "$ELEMENT_INFO" | while read TYPE_ID BAR ATOMIC_NUMBER BAR ATOMIC_MASS BAR MELTING BAR BOILING BAR SYMBOL BAR NAME BAR TYPE
        do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        done
    fi
  fi
fi
