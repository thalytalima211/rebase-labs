require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require 'pg'

get '/tests' do
  rows = CSV.read('./data.csv', col_sep: ';')

  columns = rows.shift

  rows.map do |row|
    row.each_with_object({}).with_index do |(cell, acc), idx|
      column = columns[idx]
      acc[column] = cell
    end
  end.to_json
end

get '/read_database' do
  content_type :json
  conn = PG.connect host: 'development_db', user: 'myuser', dbname: 'devdb', password: 'mypass'

  result = conn.exec 'SELECT * FROM exams'
  result = result.to_a

  conn.close unless ENV['RACK_ENV'] == 'test'
  result.to_json
end

get '/hello' do
  'Hello world!'
end
