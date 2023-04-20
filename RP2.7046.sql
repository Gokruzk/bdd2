IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'ACADEMICO')
	BEGIN
		CREATE DATABASE ACADEMICO
	END

USE ACADEMICO

EXEC sp_addtype txtCodigo, 'varchar(15)', 'NOT NULL'
EXEC sp_addtype txtNombres, 'varchar(50)', 'NOT NULL'
EXEC sp_addtype txtCedulas, 'char(10)', 'NOT NULL'

EXEC sp_addtype txtTelefonos, 'varchar(15)'
EXEC sp_addtype dtFechas, 'datetime', 'NOT NULL'
EXEC sp_addtype txtSexos, 'char(1)'

EXEC sp_addtype txtCategorias, 'char(1)'
EXEC sp_addtype mnSalarios, 'money'
EXEC sp_addtype bytAcumulados, 'tinyint'

EXEC sp_addtype bytNotas, 'tinyint'
EXEC sp_addtype bytTotales, 'tinyint'
EXEC sp_addtype bytAsistencias, 'tinyint'
EXEC sp_addtype txtEquivalencias, 'char(1)'

CREATE TABLE MATERIAS(
	txtCodigo txtCodigo PRIMARY KEY,
	txtNombre txtNombres
)

CREATE TABLE DOCENTES(
	txtCodigo txtCodigo PRIMARY KEY,
	txtCedula txtCedulas,
	txtNombre txtNombres,
	txtDireccion varchar(50),
	txtTelefono txtTelefonos,
	txtSexo txtSexos,
	txtCategorias txtCategorias,
	mnSalario mnSalarios,
	dtFechaNac dtFechas,
	dtFechaIng dtFechas
)

CREATE TABLE ESTUDIANTES(
	txtCodigo txtCodigo PRIMARY KEY,
	txtCedula txtCedulas,
	txtNombre txtNombres,
	txtDireccion varchar(50),
	txtTelefono txtTelefonos,
	dtFechaNac dtFechas,
	dtFechaIng dtFechas,
	txtSexo txtSexos
)

CREATE TABLE EVALUACIONES(
	txtCodEstudiante txtCodigo,
	txtCodMateria txtCodigo,
	txtCodDocente txtCodigo,
	bytAcumulado bytAcumulados,
	bytNota bytNotas,
	bytTotal bytTotales,
	bytAsistencia bytAsistencias,
	txtEquivalencia txtEquivalencias,
	PRIMARY KEY(txtCodEstudiante, txtCodMateria),
	FOREIGN KEY(txtCodEstudiante) REFERENCES ESTUDIANTES(txtCodigo),
	FOREIGN KEY(txtCodMateria) REFERENCES MATERIAS(txtCodigo)
)