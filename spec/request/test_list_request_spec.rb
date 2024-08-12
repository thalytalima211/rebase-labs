require 'spec_helper'
require 'rack/test'
require 'rspec'
require 'pg'
require_relative '../../app/app'
require_relative '../../db/database_config'

RSpec.describe 'GET /tests' do
  before(:each) do
    @testdb_conn = PG.connect(host: 'test_db', user: 'myuser', dbname: 'testdb', password: 'mypass')
    allow(PG).to receive(:connect).with(host: 'development_db', user: 'myuser',
                                        dbname: 'devdb', password: 'mypass').and_return(@testdb_conn)
    DatabaseConfig.create_table
  end

  after(:each) do
    @testdb_conn.exec 'DROP TABLE IF EXISTS tests'
    @testdb_conn.close
  end

  include Rack::Test::Methods
  def app
    Sinatra::Application
  end

  it 'and returns all tests data' do
    csv_rows = CSV.read('/app/spec/support/tests_data.csv', col_sep: ';')
    allow(CSV).to receive(:read).with('/app/public/data.csv', col_sep: ';').and_return(csv_rows)

    DatabaseConfig.import_from_csv
    get '/tests'

    expect(last_response.status).to eq 200
    data = JSON.parse last_response.body
    expect(data.class).to eq Array
    expect(data.length).to eq 3

    expect(data[0]['token resultado exame']).to eq 'IQCZ17'
    expect(data[0]['cpf']).to eq '048.973.170-88'
    expect(data[0]['nome paciente']).to eq 'Emilly Batista Neto'
    expect(data[0]['email paciente']).to eq 'gerald.crona@ebert-quigley.com'
    expect(data[0]['data nascimento paciente']).to eq '2001-03-11'
    expect(data[0]['endereço/rua paciente']).to eq '165 Rua Rafaela'
    expect(data[0]['cidade paciente']).to eq 'Ituverava'
    expect(data[0]['estado paciente']).to eq 'Alagoas'
    expect(data[0]['crm médico']).to eq 'B000BJ20J4'
    expect(data[0]['crm médico estado']).to eq 'PI'
    expect(data[0]['nome médico']).to eq 'Maria Luiza Pires'
    expect(data[0]['email médico']).to eq 'denna@wisozk.biz'
    expect(data[0]['data exame']).to eq '2021-08-05'
    expect(data[0].keys).not_to include 'tipo exame'
    expect(data[0].keys).not_to include 'limites tipo exame'
    expect(data[0].keys).not_to include 'resultado tipo exame'

    expect(data[1]['token resultado exame']).to eq 'OW9I67'
    expect(data[1]['cpf']).to eq '048.108.026-04'
    expect(data[1]['nome paciente']).to eq 'Juliana dos Reis Filho'
    expect(data[2]['token resultado exame']).to eq 'T9O6AI'
    expect(data[2]['cpf']).to eq '066.126.400-90'
    expect(data[2]['nome paciente']).to eq 'Matheus Barroso'
  end
end
