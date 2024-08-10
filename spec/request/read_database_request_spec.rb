require 'rack/test'
require 'rspec'
require 'pg'
require_relative '../../app/app.rb'
require_relative '../../db/database_config.rb'

ENV['RACK_ENV'] = 'test'

RSpec.describe 'GET /read_database' do
  before(:all) do
  end

  after(:all) do
  end

  include Rack::Test::Methods
  def app() Sinatra::Application end

  it 'and sees all data' do
    @testdb_conn = PG.connect(host: 'test_db', user: 'myuser', dbname: 'testdb', password: 'mypass')
    allow(PG).to receive(:connect).with(host: 'development_db', user: 'myuser',
                                        dbname: 'devdb', password: 'mypass').and_return(@testdb_conn)
    DatabaseConfig.create_table
    @testdb_conn.exec <<~INSERTDATA
      INSERT INTO exams ("nome paciente", "cpf", "cidade paciente", "estado paciente", "token resultado exame")
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

    expect(data[0]['nome paciente']).to eq 'Emilly Batista Neto'
    expect(data[0]['cpf']).to eq '048.973.170-88'
    expect(data[0]['cidade paciente']).to eq 'Ituverava'
    expect(data[0]['estado paciente']).to eq 'Alagoas'
    expect(data[0]['token resultado exame']).to eq 'IQCZ17'

    expect(data[1]['nome paciente']).to eq 'Juliana dos Reis Filho'
    expect(data[1]['cpf']).to eq '048.108.026-04'
    expect(data[1]['cidade paciente']).to eq 'Lagoa da Canoa'
    expect(data[1]['estado paciente']).to eq 'Paraíba'
    expect(data[1]['token resultado exame']).to eq '0W9I67'

    expect(data[2]['nome paciente']).to eq 'Matheus Barroso'
    expect(data[2]['cpf']).to eq '066.126.400-90'
    expect(data[2]['cidade paciente']).to eq 'Senador Elói de Souza'
    expect(data[2]['estado paciente']).to eq 'Pernambuco'
    expect(data[2]['token resultado exame']).to eq 'T9O6AI'
    @testdb_conn.exec "DROP TABLE IF EXISTS exams"
  end
end
