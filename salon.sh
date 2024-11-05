#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~ Eugene's Salon ~~~~\n"
echo -e "Welcome to Eugene's salon, how can I help you?\n"


SERVICES=$($PSQL "SELECT service_id, name FROM services;" )

SERVICE_MENU () {
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  read SERVICE_ID_SELECTED
  REQUESTED_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
  RSF=$(echo $REQUESTED_SERVICE | sed 's/ //g')
  if [[ -z $REQUESTED_SERVICE ]]
  then
    echo -e "\nI could not find that service. What would you like today?\n"
    SERVICE_MENU
  else
    CUSTOMER
  fi

}

CUSTOMER () {

  echo -e "\nWhat's your phone number"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # check phone number in db
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    # add customer to cutomers.name
    INSERT_CUTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
    APPOINTMENT
  else
    APPOINTMENT
  fi

}

APPOINTMENT () {
  # Set appointment
  echo -e "\nWhat time would you like your $RSF, $CUSTOMER_NAME?"
  read SERVICE_TIME

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")

  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(time, service_id, customer_id) VALUES('$SERVICE_TIME', $SERVICE_ID_SELECTED, $CUSTOMER_ID);")

  echo -e "\nI have put you down for a $RSF at $SERVICE_TIME, $CUSTOMER_NAME.\n"
}


SERVICE_MENU












