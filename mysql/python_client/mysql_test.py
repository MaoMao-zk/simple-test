import mysql.connector

mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  password="123456789"
)

print(mydb.is_connected())
print(mydb.database )
