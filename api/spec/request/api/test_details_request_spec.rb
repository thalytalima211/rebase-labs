require 'spec_helper'
require_relative '../../../app/app'
require_relative '../../../db/database_config'

RSpec.describe 'GET /test/:token' do
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

  it 'and returns test details' do
    csv_rows = CSV.read('/api/spec/support/csv/tests_data.csv', col_sep: ';')
    allow(CSV).to receive(:read).with('/api/public/data.csv', col_sep: ';').and_return(csv_rows)

    DatabaseConfig.import_from_csv
    get '/api/test/IQCZ17'

    expect(last_response.status).to eq 200
    data = JSON.parse last_response.body
    expect(data.class).to eq Hash

    expect(data['result_token']).to eq 'IQCZ17'
    expect(data['result_date']).to eq '2021-08-05'
    expect(data['cpf']).to eq '048.973.170-88'
    expect(data['name']).to eq 'Emilly Batista Neto'
    expect(data['email']).to eq 'gerald.crona@ebert-quigley.com'
    expect(data['birthday']).to eq '2001-03-11'
    expect(data['address']).to eq '165 Rua Rafaela'
    expect(data['city']).to eq 'Ituverava'
    expect(data['state']).to eq 'Alagoas'
    expect(data['doctor']['crm']).to eq 'B000BJ20J4'
    expect(data['doctor']['crm_state']).to eq 'PI'
    expect(data['doctor']['name']).to eq 'Maria Luiza Pires'
    expect(data['doctor']['email']).to eq 'denna@wisozk.biz'
    expect(data['tests'].length).to eq 3
    expect(data['tests'][0]['type']).to eq 'hemácias'
    expect(data['tests'][0]['limits']).to eq '45-52'
    expect(data['tests'][0]['result']).to eq '97'
    expect(data['tests'][1]['type']).to eq 'leucócitos'
    expect(data['tests'][1]['limits']).to eq '9-61'
    expect(data['tests'][1]['result']).to eq '89'
    expect(data['tests'][2]['type']).to eq 'plaquetas'
    expect(data['tests'][2]['limits']).to eq '11-93'
    expect(data['tests'][2]['result']).to eq '97'
  end

  it 'and cannot find test token' do
    get '/api/test/ABCDE'

    expect(last_response.status).to eq 404
  end
end
