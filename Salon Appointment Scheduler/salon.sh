#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
  if [[ $1 ]]
  then 
    echo -e "\n$1"
  else
  echo -e "\nWelcome to My Salon! Would you like to book an appointment with us?"
  fi
  echo -e "\nHere are the services we offer:"
  echo -e "\n1) Haircut\n2) Manicure\n3) Massage\n4) Exit\n"
  echo "Please enter the number of the service you would like to book:"
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) SELECTION;;
    2) SELECTION;;
    3) SELECTION;;
    4) EXIT;;
    *) MAIN_MENU "I could not find that service. Please enter a valid selection.";;
  esac
}

SELECTION() {
  echo -e "\nPlease enter your phone number:"
  read CUSTOMER_PHONE
  # check if customer exists
  CHECK=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo $CHECK
  if [[ -z $CHECK ]]
  then
    # add new customer
    echo -e "\nCreating new customer record. Please enter your name:"
    read CUSTOMER_NAME
    NEW_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi
  # add new appointment entry
  echo -e "\nPlease enter your requested appointment time:"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  NEW_APPT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
  # print appointment confirmation
  echo -e "\nI have put you down for a$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED") at $SERVICE_TIME,$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID")."
}

EXIT() {
  echo -e "\nThank you for stopping in!\n"
}

MAIN_MENU