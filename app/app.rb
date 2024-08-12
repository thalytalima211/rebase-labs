require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require 'pg'
require 'faraday'
set :views, File.expand_path('../app/views', __dir__)

get '/read_database' do
  content_type :json
  conn = PG.connect host: 'development_db', user: 'myuser', dbname: 'devdb', password: 'mypass'

  result = conn.exec 'SELECT * FROM tests'
  result = result.to_a

  conn.close unless ENV['RACK_ENV'] == 'test'
  result.to_json
end

get '/api/tests' do
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

get '/' do
  response = Faraday.get('http://localhost:3000/api/tests')
  if response.status == 200
    @tests = JSON.parse(response.body)
    erb :index
  else
    erb 'Não foi possível conectar-se com a base de dados'
  end
end

get '/hello' do
  'Hello world!'
end
