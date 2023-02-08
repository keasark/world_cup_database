#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")

# INSERT TEAMS 

# read data from file games.csv to new variables
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # check if data is not the title
    if [[ $WINNER != 'winner' ]]
    then 
      # get team_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      
      # not found data in the teams table
      if [[ -z $WINNER_ID ]]
      then
      # then, insert new data into teams table
        INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        # get new team_id
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        if [[ $INSERT_WINNER == "INSERT 0 1" ]]
        then 
          echo Inserted Winner Team, $WINNER
        fi
      fi


      if [[ -z $OPPONENT_ID ]]
      then
        INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        # get new team_id
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
        then 
          echo Inserted Opponent Team, $OPPONENT
        fi
      fi


      # insert new data into games table
      INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
      if [[ $INSERT_GAME == "INSERT 0 1" ]]
      then
        echo Inserted New Game, $YEAR $ROUND
      fi
    fi
done



