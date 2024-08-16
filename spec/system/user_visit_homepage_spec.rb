require 'spec_helper'
require_relative '../../app/app'

RSpec.describe 'User visit homepage' do
  it 'and sees a list of all tests' do
    json_data = File.read(File.join(Dir.pwd, 'spec/support/json/tests.json'))
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/tests').and_return(fake_response)

    visit '/'

    expect(page).to have_content 'MeuExame.com'
    within('#00S0MD') do
      expect(page).to have_content '00S0MD'
      expect(page).to have_content 'CPF: 099.204.552-53'
      expect(page).to have_content 'Nome: Ladislau Duarte'
      expect(page).to have_content 'Email: lisha@rosenbaum.org'
      expect(page).to have_content 'Data de Nascimento: 1981-02-02'
      expect(page).to have_content 'Endereço: s/n Marginal Pietro'
      expect(page).to have_content 'Cidade: Peritiba'
      expect(page).to have_content 'Estado: Rio Grande do Norte'
      expect(page).to have_content 'CRM: B000BJ8TIA'
      expect(page).to have_content 'Estado do CRM: PR'
      expect(page).to have_content 'Nome do Médico: Ana Sophia Aparício Neto'
      expect(page).to have_content 'Email do Médico: corene.hane@pagac.io'
      expect(page).to have_content 'Data de Realização do Exame: 2022-03-03'
    end
    within('#06LD0G') do
      expect(page).to have_content '06LD0G'
      expect(page).to have_content 'CPF: 003.596.348-42'
      expect(page).to have_content 'Nome: Valentina Cruz'
      expect(page).to have_content 'Email: cortez.dickens@farrell.name'
      expect(page).to have_content 'Data de Nascimento: 1979-04-04'
      expect(page).to have_content 'Endereço: 644 Ponte Ryan Esteves'
      expect(page).to have_content 'Cidade: São José da Coroa Grande'
      expect(page).to have_content 'Estado: Rondônia'
      expect(page).to have_content 'CRM: B00067668W'
      expect(page).to have_content 'Estado do CRM: RS'
      expect(page).to have_content 'Nome do Médico: Félix Garcês'
      expect(page).to have_content 'Email do Médico: letty_greenfelder@herzog.name'
      expect(page).to have_content 'Data de Realização do Exame: 2021-05-15'
    end
  end

  it 'and get an alert if there is no tests' do
    fake_response = double('faraday_response', status: 404, body: '[]')
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/tests').and_return(fake_response)

    visit '/'
    expect(page).to have_content 'No momento, não há exames em nossa base de dados.'
  end

  it 'and get an alert if there is a internal error' do
    fake_response = double('faraday_response', status: 500, body: '')
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/tests').and_return(fake_response)

    visit '/'

    expect(page).to have_content 'Não foi possível conectar-se com a base de dados'
  end
end
