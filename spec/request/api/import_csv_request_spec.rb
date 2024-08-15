require 'spec_helper'
require 'sidekiq/testing'
require_relative '../../../app/app'
require_relative '../../../db/database_config'
require_relative '../../../app/jobs/import_csv_job'

RSpec.describe 'POST /api/import_csv' do
  before(:each) do
    Sidekiq::Worker.clear_all
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
    csv_file = Rack::Test::UploadedFile.new('spec/support/csv/data_to_import.csv', 'text/csv')

    post '/api/import_csv', file: csv_file

    expect(last_response.status).to eq 200
    expect(ImportCSVJob.jobs.size).to eq 1
  end

  it 'with invalid headers' do
    csv_file = Rack::Test::UploadedFile.new('spec/support/csv/csv_with_error.csv', 'text/csv')

    post '/api/import_csv', file: csv_file

    expect(last_response.status).to eq 412
    expect(ImportCSVJob.jobs.size).to eq 0
  end

  it 'with invalid file type' do
    txt_file = Rack::Test::UploadedFile.new('spec/support/csv/wrong_file.txt', 'text/plain')

    post '/api/import_csv', file: txt_file

    expect(last_response.status).to eq 412
    expect(ImportCSVJob.jobs.size).to eq 0
  end
end
