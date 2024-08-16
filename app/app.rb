require 'sinatra'
require 'rack/handler/puma'
require 'csv'
require 'pg'
require 'faraday'
require_relative 'jobs/import_csv_job'
require_relative '../db/database_config'

set :public_folder, 'public'
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
    status 404
    [].to_json
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

post '/api/import_csv' do
  unless params[:file] && params[:file][:type] == 'text/csv'
    status 415
    return erb 'Formato inválido! Por favor, utilize o modelo fornecido'
  end

  file = params[:file][:tempfile]

  csv_rows = CSV.read(file, col_sep: ',')
  header = csv_rows.shift.join(',')
  if header == DatabaseConfig.columns_list
    ImportCSVJob.perform_async(csv_rows)
    erb 'Arquivo recebido! Aguarde alguns instantes para que os dados sejam processados.'
  else
    status 412
    erb 'O arquivo não possui o cabeçalho esperado. Utilize o modelo de arquivo fornecido.'
  end
end

get '/' do
  return redirect to "/#{params['token']}" if params['token']

  response = Faraday.get('http://localhost:3000/api/tests')
  if response.status == 200
    @tests = JSON.parse(response.body)
    erb :index
  elsif response.status == 404
    erb 'No momento, não há exames em nossa base de dados.'
  else
    erb '<h5>Não foi possível conectar-se com a base de dados</h5>'
  end
end

get '/:test_token' do
  return redirect to "/#{params['token']}" if params['token']

  response = Faraday.get("http://localhost:3000/api/test/#{params[:test_token]}")
  if response.status == 200
    @test = JSON.parse(response.body)
    erb :show
  else
    erb '<h5>Não foi possível encontrar este exame...</h5>'
  end
end
