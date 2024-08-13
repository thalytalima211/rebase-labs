require 'spec_helper'
require_relative '../../app/app'

RSpec.describe 'User sees test\'s details' do
  it 'from the homepage' do
    json_data = File.read(File.join(Dir.pwd, 'spec/support/json/tests.json'))
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/tests').and_return(fake_response)

    visit '/'
    json_data = File.read(File.join(Dir.pwd, 'spec/support/json/test.json'))
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/test/00S0MD').and_return(fake_response)
    within('#00S0MD') { click_on 'Ver resultados' }

    expect(current_path).to eq '/00S0MD'
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
    within('section div:nth-child(1)') do
      expect(page).to have_content 'Tipo de Exame: hemácias'
      expect(page).to have_content 'Limites Recomendados: 45-52'
      expect(page).to have_content 'Resultado: 97'
    end
    within('section div:nth-child(2)') do
      expect(page).to have_content 'Tipo de Exame: leucócitos'
      expect(page).to have_content 'Limites Recomendados: 9-61'
      expect(page).to have_content 'Resultado: 89'
    end
    within('section div:nth-child(3)') do
      expect(page).to have_content 'Tipo de Exame: plaquetas'
      expect(page).to have_content 'Limites Recomendados: 11-93'
      expect(page).to have_content 'Resultado: 97'
    end
  end

  it 'and cannot acess an invalid token' do
    visit '/ABCDE'

    expect(page).to have_content 'Não foi possível conectar-se com a base de dados'
  end
end
