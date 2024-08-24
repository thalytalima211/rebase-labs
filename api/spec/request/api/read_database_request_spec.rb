require 'spec_helper'
require_relative '../../../app/app'
require_relative '../../../db/database_config'

RSpec.describe 'GET /read_database' do
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

  it 'returns all data' do
    @testdb_conn.exec <<~INSERTDATA
      INSERT INTO tests (name, cpf, city, state, result_token)
      VALUES
      ('Emilly Batista Neto', '048.973.170-88', 'Ituverava', 'Alagoas', 'IQCZ17'),
      ('Juliana dos Reis Filho', '048.108.026-04', 'Lagoa da Canoa', 'Paraíba', '0W9I67'),
      ('Matheus Barroso', '066.126.400-90', 'Senador Elói de Souza', 'Pernambuco', 'T9O6AI');
    INSERTDATA

    get '/read_database'

    expect(last_response.status).to eq 200
    data = JSON.parse last_response.body
    expect(data.class).to eq Array
    expect(data.length).to eq 3

    expect(data[0]['name']).to eq 'Emilly Batista Neto'
    expect(data[0]['cpf']).to eq '048.973.170-88'
    expect(data[0]['city']).to eq 'Ituverava'
    expect(data[0]['state']).to eq 'Alagoas'
    expect(data[0]['result_token']).to eq 'IQCZ17'

    expect(data[1]['name']).to eq 'Juliana dos Reis Filho'
    expect(data[1]['cpf']).to eq '048.108.026-04'
    expect(data[1]['city']).to eq 'Lagoa da Canoa'
    expect(data[1]['state']).to eq 'Paraíba'
    expect(data[1]['result_token']).to eq '0W9I67'

    expect(data[2]['name']).to eq 'Matheus Barroso'
    expect(data[2]['cpf']).to eq '066.126.400-90'
    expect(data[2]['city']).to eq 'Senador Elói de Souza'
    expect(data[2]['state']).to eq 'Pernambuco'
    expect(data[2]['result_token']).to eq 'T9O6AI'
  end

  it 'returns an empty array' do
    get '/read_database'

    expect(last_response.status).to eq 200
    data = JSON.parse last_response.body
    expect(data.length).to eq 0
  end
end
