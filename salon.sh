#! /bin/bash

PSQL() {
  echo $(psql --no-align --username=freecodecamp --dbname=salon --tuples-only -c "$1")
}

echo -e "\n~~ Harry's Hair Salon - Appointment Setup ~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo "$1"
  fi

  echo "Pick a service:"
  echo $(PSQL "SELECT * FROM services;") | sed -e 's/ /\n/g; s/|/) /g'
  read SERVICE_ID_SELECTED

  SERVICE_NAME=$(PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
  if [[ -z $SERVICE_NAME ]]
  then
    MAIN_MENU "Service doesn't exist"
  else
    echo -e "\nEnter your phone number:"
    read CUSTOMER_PHONE

    CUSTOMER_NAME=$(PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo "The phone number you entered doesn't exist within our records."
      echo -e "\nTo register your phone number, please enter your name:"
      read CUSTOMER_NAME

      REGISTER_CUSTOMER_RESULT=$(PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
    fi
    CUSTOMER_ID=$(PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")
    
    echo -e "\nAt what time would you like to have this appointment?"
    read SERVICE_TIME

    REGISTER_APPOINTMENT_RESULT=$(PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES($SERVICE_ID_SELECTED, $CUSTOMER_ID, '$SERVICE_TIME')")
    echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

MAIN_MENU