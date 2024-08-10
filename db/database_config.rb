require 'pg'
require 'csv'

class DatabaseConfig
  def self.create_table
    conn = PG.connect host: 'development_db', user: 'myuser', dbname: 'devdb', password: 'mypass'

    puts '=== Criando tabela EXAMS ===' unless ENV['RACK_ENV'] = 'test'

    conn.exec <<-DATABASE_QUERY
    CREATE TABLE IF NOT EXISTS exams(
      cpf VARCHAR(14),
      "nome paciente" VARCHAR(100),
      "email paciente" VARCHAR(100),
      "data nascimento paciente" DATE,
      "endereço/rua paciente" VARCHAR(100),
      "cidade paciente" VARCHAR(50),
      "estado paciente" VARCHAR(30),
      "crm médico" VARCHAR(30),
      "crm médico estado" VARCHAR(30),
      "nome médico" VARCHAR(70),
      "email médico" VARCHAR(50),
      "token resultado exame" VARCHAR(40),
      "data exame" DATE,
      "tipo exame" VARCHAR(40),
      "limites tipo exame" VARCHAR(15),
      "resultado tipo exame" VARCHAR(7)
    );
    DATABASE_QUERY

    puts '=== Tabela EXAMS criada === ' unless ENV['RACK_ENV'] = 'test'
    conn.close unless ENV['RACK_ENV'] = 'test'
  end

  def self.import_from_csv
    conn = PG.connect host: 'development_db', user: 'myuser', dbname: 'devdb', password: 'mypass'

    rows = CSV.read("./data.csv", col_sep: ';')
    columns_list = rows.shift.map { |col| "\"#{col}\""}.join(', ')

    puts '=== POPULANDO TABELA... ===' unless ENV['RACK_ENV'] = 'test'

    rows.each do |row|
      data = row.map { |data| "'#{data.gsub("'", "''")}'" }.join(', ')
      conn.exec("INSERT INTO exams (#{columns_list}) VALUES (#{data});")
    end

    puts '=== TABELA POPULADA COM SUCESSO === ' unless ENV['RACK_ENV'] = 'test'
    conn.close unless ENV['RACK_ENV'] = 'test'
  end
end
