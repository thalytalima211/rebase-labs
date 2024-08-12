require 'csv'
require 'spec_helper'
require_relative '../../db/database_config'

RSpec.describe 'Import data from csv' do
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

  it 'sucessfully' do
    csv_rows = CSV.read('/app/spec/support/csv/data_to_import.csv', col_sep: ';')
    allow(CSV).to receive(:read).with('/app/public/data.csv', col_sep: ';').and_return(csv_rows)

    DatabaseConfig.import_from_csv
    result = @testdb_conn.exec 'SELECT * FROM tests'

    expect(result.ntuples).to eq 2
    expect(result[0]['cpf']).to eq '048.973.170-88'
    expect(result[0]['name']).to eq 'Emilly Batista Neto'
    expect(result[0]['city']).to eq 'Ituverava'
    expect(result[0]['result_token']).to eq 'IQCZ17'

    expect(result[1]['cpf']).to eq '048.108.026-04'
    expect(result[1]['name']).to eq 'Juliana dos Reis Filho'
    expect(result[1]['city']).to eq 'Lagoa da Canoa'
    expect(result[1]['result_token']).to eq '0W9I67'
  end
end
