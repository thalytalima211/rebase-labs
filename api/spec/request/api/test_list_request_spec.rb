require 'spec_helper'
require_relative '../../../app/app'
require_relative '../../../db/database_config'

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

  it 'and returns all tests data' do
    csv_rows = CSV.read('/api/spec/support/csv/tests_data.csv', col_sep: ';')
    allow(CSV).to receive(:read).with('/api/public/data.csv', col_sep: ';').and_return(csv_rows)

    DatabaseConfig.import_from_csv
    get '/api/tests'

    expect(last_response.status).to eq 200
    data = JSON.parse last_response.body
    expect(data.class).to eq Array
    expect(data.length).to eq 3

    expect(data[0]['result_token']).to eq 'IQCZ17'
    expect(data[0]['cpf']).to eq '048.973.170-88'
    expect(data[0]['name']).to eq 'Emilly Batista Neto'
    expect(data[0]['email']).to eq 'gerald.crona@ebert-quigley.com'
    expect(data[0]['birthday']).to eq '2001-03-11'
    expect(data[0]['address']).to eq '165 Rua Rafaela'
    expect(data[0]['city']).to eq 'Ituverava'
    expect(data[0]['state']).to eq 'Alagoas'
    expect(data[0]['doctor']['crm']).to eq 'B000BJ20J4'
    expect(data[0]['doctor']['crm_state']).to eq 'PI'
    expect(data[0]['doctor']['name']).to eq 'Maria Luiza Pires'
    expect(data[0]['doctor']['email']).to eq 'denna@wisozk.biz'
    expect(data[0]['result_date']).to eq '2021-08-05'
    expect(data[0].keys).not_to include 'test_type'
    expect(data[0].keys).not_to include 'test_type_limits'
    expect(data[0].keys).not_to include 'test_type_result'

    expect(data[1]['result_token']).to eq 'OW9I67'
    expect(data[1]['cpf']).to eq '048.108.026-04'
    expect(data[1]['name']).to eq 'Juliana dos Reis Filho'
    expect(data[2]['result_token']).to eq 'T9O6AI'
    expect(data[2]['cpf']).to eq '066.126.400-90'
    expect(data[2]['name']).to eq 'Matheus Barroso'
  end

  it 'and can\'t find any test' do
    allow(CSV).to receive(:read).with('/api/public/data.csv', col_sep: ';').and_return([])

    get '/api/tests'

    expect(last_response.status).to eq 404
    data = JSON.parse last_response.body
    expect(data).to eq []
  end
end
