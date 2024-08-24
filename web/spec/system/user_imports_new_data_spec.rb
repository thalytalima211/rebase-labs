require 'spec_helper'
require_relative '../../app/app'

RSpec.describe 'User imports new data', js: true do
  it 'from the navabar' do
    allow(Faraday).to receive(:get).and_return double('faraday_response', status: 200, body: '[]')

    visit '/'
    within('nav') { click_on 'Importar novos dados' }
    attach_file 'Arquivo CSV', File.join(Dir.pwd, 'spec/support/csv/data_to_import.csv')
    find('button#submit').click

    expect(page).to have_content 'Arquivo recebido! Aguarde alguns instantes para que os dados sejam processados.'
  end

  it 'and fails if file type is not supported', js: true do
    allow(Faraday).to receive(:get).and_return double('faraday_response', status: 200, body: '[]')

    visit '/'
    within('nav') { click_on 'Importar novos dados' }
    attach_file 'Arquivo CSV', File.join(Dir.pwd, 'spec/support/csv/wrong_file.txt')
    find('button#submit').click

    expect(page).to have_content 'Formato inválido! Por favor, utilize o modelo fornecido'
  end

  it 'and fails if file structure is wrong', js: true do
    allow(Faraday).to receive(:get).and_return double('faraday_response', status: 200, body: '[]')

    visit '/'
    within('nav') { click_on 'Importar novos dados' }
    attach_file 'Arquivo CSV', File.join(Dir.pwd, '/spec/support/csv/csv_with_error.csv')
    find('button#submit').click

    expect(page).to have_content 'O arquivo não possui o cabeçalho esperado. Utilize o modelo de arquivo fornecido.'
  end

  it 'with missing params', js: true do
    allow(Faraday).to receive(:get).and_return double('faraday_response', status: 200, body: '[]')

    visit '/'
    within('nav') { click_on 'Importar novos dados' }
    find('button#submit').click

    expect(page).to have_content 'Por favor, selecione um arquivo.'
  end
end
