require 'pg'

conn = PG.connect host: 'mydb', user: 'myuser', dbname: 'mydb', password: 'mypass'

conn.exec <<-DATABASE_QUERY
  CREATE TABLE IF NOT EXISTS exams(
    cpf VARCHAR(14),
    "nome paciente" VARCHAR(100),
    "email paciente" VARCHAR(100),
    "data nascimento paciente" DATE,
    "endereço/rua paciente" VARCHAR(100),
    "cidade paciente" VARCHAR(50),
    "estado patiente" VARCHAR(30),
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
