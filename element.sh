#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

MAIN() {
    #if no argument is provided
    if ! [[ $1 ]]
    then
        #output error message and quit the function
        echo -e "\nPlease provide an element as an argument."
        return
        #else if argument provided is a positive integer
    elif [[ $1 =~ ^[0-9]+$ ]]
    then
        #trim spaces around argument
        TRIMMED_NUMBER=$(echo "$1" | xargs)
        #look up the DB for an element with TRIMMED argument as its atomic number
        ELEMENT_EXISTS=$(echo "$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$TRIMMED_NUMBER")" | sed -r 's/^ *| *$//g')
        #if no result
        if [[ -z "$ELEMENT_EXISTS" ]]
        then
            #output error message and quit function
            echo -e "\nI could not find that element in the database."
            return
        else
            #fetch results
            GET_ELEMENT_DETAILS "$ELEMENT_EXISTS"
            #validate query results
            if [[ -z $SYMBOL || -z $NAME || -z $TYPE_ID || -z $TYPE || -z $ATOMIC_MASS || -z $MELTING_POINT || -z $BOILING_POINT ]]
            then
                echo -e "\nError retrieving element details. Please check the database."
                return
            else
                #output success message
                SUCCESS_MSG_FORMATTED
            fi
        fi
        #else if argument provided is a symbol
    elif [[ $1 =~ ^[a-zA-Z]{1,2}$ ]]
    then
        #trim spaces around argument
        TRIMMED_SYMBOL=$(echo "$1" | xargs)
        #look up the DB for an element with TRIMMED argument as its atomic number
        ELEMENT_EXISTS=$(echo "$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$TRIMMED_SYMBOL'")" | sed -r 's/^ *| *$//g')
        #if no result
        if [[ -z "$ELEMENT_EXISTS" ]]
        then
            #output error message and quit function
            echo -e "\nI could not find that element in the database."
            return
        else
            #fetch results
            GET_ELEMENT_DETAILS "$ELEMENT_EXISTS"
            #validate query results
            if [[ -z $SYMBOL || -z $NAME || -z $TYPE_ID || -z $TYPE || -z $ATOMIC_MASS || -z $MELTING_POINT || -z $BOILING_POINT ]]
            then
                echo -e "\nError retrieving element details. Please check the database."
                return
            else
                #output success message
                SUCCESS_MSG_FORMATTED
            fi
        fi
        #else if argument provided is a name
    elif [[ $1 =~ ^[a-zA-Z]{1,11}$ ]]
    then
        #trim spaces around argument
        TRIMMED_NAME=$(echo "$1" | xargs)
        #look up the DB for an element with TRIMMED argument as its atomic number
        ELEMENT_EXISTS=$(echo "$($PSQL "SELECT atomic_number FROM elements WHERE name='$TRIMMED_NAME'")" | sed -r 's/^ *| *$//g')
        #if no result
        if [[ -z "$ELEMENT_EXISTS" ]]
        then
            #output error message and quit function
            echo -e "\nI could not find that element in the database."
            return
        else
            #fetch results
            GET_ELEMENT_DETAILS "$ELEMENT_EXISTS"
            #validate query results
            if [[ -z $SYMBOL || -z $NAME || -z $TYPE_ID || -z $TYPE || -z $ATOMIC_MASS || -z $MELTING_POINT || -z $BOILING_POINT ]]
            then
                echo -e "\nError retrieving element details. Please check the database."
                return
            else
                #output success message
                SUCCESS_MSG_FORMATTED
            fi
        fi
        #else if argument provided is invalid
    else
        echo -e "\nI could not find that element in the database."
        return
    fi
}

GET_ELEMENT_DETAILS() {
    #get symbol of element
    SYMBOL=$(echo "$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ELEMENT_EXISTS")" | sed -r 's/^ *| *$//g')
    #get name of element
    NAME=$(echo "$($PSQL "SELECT name FROM elements WHERE atomic_number=$ELEMENT_EXISTS")" | sed -r 's/^ *| *$//g')
    #get type_id of element to get type
    TYPE_ID=$(echo "$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ELEMENT_EXISTS")" | sed -r 's/^ *| *$//g')
    #get type of element
    TYPE=$(echo "$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")" | sed -r 's/^ *| *$//g')
    #get atomic mass
    ATOMIC_MASS=$(echo "$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ELEMENT_EXISTS")" | sed -r 's/^ *| *$//g')
    #get melting_point
    MELTING_POINT=$(echo "$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ELEMENT_EXISTS")" | sed -r 's/^ *| *$//g')
    #get boiling_point
    BOILING_POINT=$(echo "$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ELEMENT_EXISTS")" | sed -r 's/^ *| *$//g')
}

SUCCESS_MSG_FORMATTED() {
    echo -e "\nThe element with atomic number $ELEMENT_EXISTS is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
}

MAIN "$1"
