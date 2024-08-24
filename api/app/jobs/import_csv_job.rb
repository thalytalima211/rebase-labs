require 'sidekiq'
require 'pg'

class ImportCSVJob
  include Sidekiq::Job

  def perform(csv_rows)
    conn = PG.connect host: 'development_db', user: 'myuser', dbname: 'devdb', password: 'mypass'

    columns = columns_list

    csv_rows.each do |row|
      data_values = row.map { |data| "'#{data.gsub("'", "''")}'" }.join(', ')
      begin
        conn.exec("INSERT INTO tests (#{columns}) VALUES (#{data_values});")
      rescue PG::Error
        puts 'Erro ao inserir registro'
      end
    end
  end

  def columns_list
    <<~COLUMNS
      cpf, name, email, birthday, address, city, state, doctor_crm, doctor_crm_state, doctor_name, doctor_email,
      result_token, result_date, test_type, test_type_limits, test_type_result
    COLUMNS
  end
end
