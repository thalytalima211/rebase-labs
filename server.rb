require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require 'pg'

get '/tests' do
  rows = CSV.read("./data.csv", col_sep: ';')

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
  conn = PG.connect host: 'mydb', user: 'myuser', dbname: 'mydb', password: 'mypass'

  result = conn.exec "SELECT * FROM exams"
  result = result.to_a

  conn.close
  result.to_json
end

get '/hello' do
  'Hello world!'
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
