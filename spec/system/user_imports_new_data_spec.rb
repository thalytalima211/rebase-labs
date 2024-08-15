require 'spec_helper'
require_relative '../../app/app'

RSpec.describe 'User imports new data' do
  it 'from the navabar' do
    allow(Faraday).to receive(:get).and_return double('faraday_response', status: 200, body: '[]')
    faraday_instance = double('FaradayInstance')
    allow(Faraday).to receive(:new).and_return(faraday_instance)
    allow(faraday_instance).to receive(:post)
      .with('/api/import_csv', instance_of(Sinatra::IndifferentHash))
      .and_return(double('response', status: 200, body: ''))

    visit '/'
    within('nav') { click_on 'Importar novos dados' }
    attach_file 'Arquivo CSV', File.join(Dir.pwd, 'spec/support/csv/data_to_import.csv')
    click_on 'Importar'

    expect(current_path).to eq '/import_csv'
    expect(page).to have_content 'Arquivo recebido! Aguarde alguns instantes para que os dados sejam processados.'
  end

  it 'with missing params' do
    allow(Faraday).to receive(:get).and_return double('faraday_response', status: 200, body: '[]')

    visit '/'
    within('nav') { click_on 'Importar novos dados' }
    click_on 'Importar'

    expect(current_path).to eq '/import_csv'
    expect(page).to have_content 'Nenhum arquivo informado, tente novamente'
  end

  it 'and fails if file type is not supported' do
    allow(Faraday).to receive(:get).and_return double('faraday_response', status: 200, body: '[]')
    faraday_instance = double('FaradayInstance')
    allow(Faraday).to receive(:new).and_return(faraday_instance)
    allow(faraday_instance).to receive(:post)
      .with('/api/import_csv', instance_of(Sinatra::IndifferentHash))
      .and_return(double('response', status: 415, body: ''))

    visit '/'
    within('nav') { click_on 'Importar novos dados' }
    attach_file 'Arquivo CSV', File.join(Dir.pwd, 'spec/support/csv/wrong_file.txt')
    click_on 'Importar'

    expect(current_path).to eq '/import_csv'
    expect(page).to have_content 'Formato inválido! Por favor, utilize o modelo fornecido'
  end

  it 'and fails if file structure is wrong' do
    allow(Faraday).to receive(:get).and_return double('faraday_response', status: 200, body: '[]')
    faraday_instance = double('FaradayInstance')
    allow(Faraday).to receive(:new).and_return(faraday_instance)
    allow(faraday_instance).to receive(:post)
      .with('/api/import_csv', instance_of(Sinatra::IndifferentHash))
      .and_return(double('response', status: 412, body: ''))

    visit '/'
    within('nav') { click_on 'Importar novos dados' }
    attach_file 'Arquivo CSV', File.join(Dir.pwd, 'spec/support/csv/csv_with_error.csv')
    click_on 'Importar'

    expect(current_path).to eq '/import_csv'
    expect(page).to have_content 'O arquivo não possui o cabeçalho esperado. Utilize o modelo de arquivo fornecido.'
  end
end
