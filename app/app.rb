require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require 'pg'

get '/read_database' do
  content_type :json
  conn = PG.connect host: 'development_db', user: 'myuser', dbname: 'devdb', password: 'mypass'

  result = conn.exec 'SELECT * FROM tests'
  result = result.to_a

  conn.close unless ENV['RACK_ENV'] == 'test'
  result.to_json
end

get '/tests' do
  content_type :json
  conn = PG.connect host: 'development_db', user: 'myuser', dbname: 'devdb', password: 'mypass'

  result = conn.exec <<~CONSULT
    SELECT DISTINCT ON ("token resultado exame") "token resultado exame", "cpf", "nome paciente", "email paciente",
    "data nascimento paciente", "endereço/rua paciente", "cidade paciente", "estado paciente", "crm médico",
    "crm médico estado", "nome médico", "email médico", "data exame"
    FROM tests
    ORDER BY "token resultado exame";
  CONSULT
  result = result.to_a

  conn.close unless ENV['RACK_ENV'] == 'test'
  result.to_json
end

get '/hello' do
  'Hello world!'
end
