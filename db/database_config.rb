require 'pg'
require 'csv'

class DatabaseConfig
  def self.create_table
    conn = PG.connect host: 'development_db', user: 'myuser', dbname: 'devdb', password: 'mypass'

    conn.exec create_table_query

    conn.close unless ENV['RACK_ENV'] == 'test'
  end

  def self.import_from_csv
    conn = PG.connect host: 'development_db', user: 'myuser', dbname: 'devdb', password: 'mypass'

    rows = CSV.read('/app/public/data.csv', col_sep: ';')
    rows.shift
    columns = columns_list

    rows.each do |row|
      data_values = row.map { |data| "'#{data.gsub("'", "''")}'" }.join(', ')
      conn.exec("INSERT INTO tests (#{columns}) VALUES (#{data_values});")
    end

    conn.close unless ENV['RACK_ENV'] == 'test'
  end

  def self.create_table_query
    <<-DATABASE_QUERY
    CREATE TABLE IF NOT EXISTS tests(
      cpf VARCHAR(14), name VARCHAR(100), email VARCHAR(100), birthday DATE, address VARCHAR(100), city VARCHAR(50),
      state VARCHAR(30), doctor_crm VARCHAR(30), doctor_crm_state VARCHAR(30), doctor_name VARCHAR(70),
      doctor_email VARCHAR(50), result_token VARCHAR(40), result_date DATE, test_type VARCHAR(40),
      test_type_limits VARCHAR(15), test_type_result VARCHAR(7)
    );
    DATABASE_QUERY
  end

  def self.columns_list
    <<~COLUMNS
      cpf, name, email, birthday, address, city, state, doctor_crm, doctor_crm_state, doctor_name, doctor_email,
      result_token, result_date, test_type, test_type_limits, test_type_result
    COLUMNS
  end

  private_class_method :create_table_query, :columns_list
end
