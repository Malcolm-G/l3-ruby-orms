require 'bundler'
Bundler.require

require_relative '../lib/student'

DB = { conn: SQLite3::Database.new("db/school.db") }

# RUN CODE FROM HERE
# reset table
Student.reset

# create table
Student.create_table

s1 = Student.new(name:'Jane Doe', age:20)
s2 = Student.new(name:'Jack Daniel', age:50)
s3 = Student.new(name:'Jack Byron', age:25)

#save student data
s1.create
s2.create
s3.create

# check student
pp s1

#view student data
pp Student.all

print "Search Results: "
pp Student.search_by(age:50)










# # student data
# ian = Student.new(name:"Ian",age:20)
# # insert record
# ian.create

# #view all records
# Student.all

# #update student
# ian.age = 22
# ian.update
# Student.all

# #delete student
# ian.destroy