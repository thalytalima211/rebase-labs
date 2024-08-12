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
    SELECT DISTINCT ON (result_token) result_token, cpf, name, email, birthday, address, city, state, doctor_crm,
    doctor_crm_state, doctor_name, doctor_email, result_date
    FROM tests ORDER BY result_token;
  CONSULT

  if result.any?
    formatted_results = result.map do |row|
      {
        result_token: row['result_token'], result_date: row['result_date'], cpf: row['cpf'], name: row['name'],
        email: row['email'], birthday: row['birthday'], address: row['address'], city: row['city'], state: row['state'],
        doctor: {
          crm: row['doctor_crm'], crm_state: row['doctor_crm_state'],
          name: row['doctor_name'], email: row['doctor_email']
        }
      }
    end
    conn.close unless ENV['RACK_ENV'] == 'test'
    formatted_results.to_json
  else
    conn.close unless ENV['RACK_ENV'] == 'test'
    []
  end

end

get '/api/test/:token' do
  content_type :json
  conn = PG.connect host: 'development_db', user: 'myuser', dbname: 'devdb', password: 'mypass'

  result = conn.exec_params('SELECT * FROM tests WHERE result_token = $1', [params[:token]])

  if result.any?
    tests_list = result.map do |row|
      { type: row['test_type'], limits: row['test_type_limits'], result: row['test_type_result'] }
    end

    row = result.first
    formatted_results = {
      result_token: row['result_token'], result_date: row['result_date'], cpf: row['cpf'], name: row['name'],
      email: row['email'], birthday: row['birthday'], address: row['address'], city: row['city'], state: row['state'],
      doctor: {
        crm: row['doctor_crm'], crm_state: row['doctor_crm_state'],
        name: row['doctor_name'], email: row['doctor_email']
      },
      tests: tests_list
    }

    conn.close unless ENV['RACK_ENV'] == 'test'
    formatted_results.to_json
  else
    conn.close unless ENV['RACK_ENV'] == 'test'
    status 404
  end
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
