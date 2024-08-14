#! /bin/bash
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcom to My Salon, how can I help you?\n"


PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

SERVICES=$($PSQL "SELECT * FROM services")
MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE
  do
    echo $SERVICE_ID")" $SERVICE
  done

  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) MAIN ;;
    2) MAIN ;;
    3) MAIN ;;
    4) MAIN ;;
    5) MAIN ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

MAIN() {
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e  "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
    read SERVICE_TIME
    INSER_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    INSER_APPOINTMENTS_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    SERVICE=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
    echo -e "\nI have put you down for a$SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  else
    SERVICE=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID")
    echo -e "\nWhat time would you like your$SERVICE,$CUSTOMER_NAME?"
    read SERVICE_TIME
    INSER_APPOINTMENTS_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$TIME')")
    SERVICE=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
    echo -e "\nI have put you down for a$SERVICE at $SERVICE_TIME,$CUSTOMER_NAME."
  fi
}

MAIN_MENU