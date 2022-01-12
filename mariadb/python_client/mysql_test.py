import mariadb

connection = mariadb.connect(
  host="127.0.0.1",
  user="root",
  password="123456789",
  database="mysql"
)

print(connection.server_info)
print(connection.database )


cursor = connection.cursor()

cursor.execute("show tables")
for row in cursor:
    print(row)

cursor.execute("select * from user")
lst = cursor.fetchall()
print(lst)
print(len(lst))
print(lst[1][1])

cursor.execute("select User,Host from user")
for (user, host) in cursor:
    # print("user=%s"%(user))
    print("user=%s, Host=%s"%(user, host))