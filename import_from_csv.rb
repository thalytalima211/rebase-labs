require 'csv'
require 'pg'

conn = PG.connect host: 'mydb', user: 'myuser', dbname: 'mydb', password: 'mypass'

rows = CSV.read("./data.csv", col_sep: ';')
columns_list = rows.shift.map { |col| "\"#{col}\""}.join(', ')

rows.each do |row|
  data = row.map { |data| "'#{data.gsub("'", "''")}'" }.join(', ')
  conn.exec("INSERT INTO exams (#{columns_list}) VALUES (#{data});")
end
