require 'spec_helper'
require_relative '../../db/database_config'
require_relative '../../app/jobs/import_csv_job'

RSpec.describe ImportCSVJob do
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

  it 'Should insert new exams data' do
    csv_rows = CSV.read('/api/spec/support/csv/data_to_import.csv', col_sep: ';')
    csv_rows.shift

    ImportCSVJob.new.perform(csv_rows)
    result = @testdb_conn.exec 'SELECT * FROM tests;'

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

  it 'Skip invalid rows' do
    csv_rows = CSV.read('/api/spec/support/csv/csv_with_error.csv', col_sep: ';')
    csv_rows.shift

    ImportCSVJob.new.perform(csv_rows)
    result = @testdb_conn.exec 'SELECT * FROM tests;'

    expect(result.ntuples).to eq 1
    expect(result[0]['cpf']).to eq '048.108.026-04'
    expect(result[0]['name']).to eq 'Juliana dos Reis Filho'
  end
end
