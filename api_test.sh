#!/bin/bash
#
# Usage:
# => regist a new user
# url: /register
# data(JSON): { "email": "abc@asd.com", "password": "12345" }
# verb(UpperCase): POST
#

read -p "api URL:" url
read -p "json data:" data
read -p "http verb:" verb

content_type="Content-Type: application/json"
user_agent='Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.91 Safari/537.36'
cookies='cookies'
curl "http://localhost:8080$url" -A "'$user_agent'" -H "'$content_type'" -X $verb -c $cookies -b "@$cookies" -d "$data"