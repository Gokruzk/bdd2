--Crear base de datos si no existe
IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'ACADEMICO')
	BEGIN
		CREATE DATABASE ACADEMICO
	END

USE ACADEMICO

--Crear tipos de datos
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

--Crear valores predeterminados
GO
CREATE DEFAULT vp_CategoriaAuxiliar
	AS 'A'
GO
CREATE DEFAULT vp_Reprobado
	AS 'R'
GO
CREATE DEFAULT vp_Cero
	AS 0
GO
CREATE DEFAULT vp_SexoFemenino
	AS 'F'

GO

--ASIGNAR VALORES PREDETERMINADOS A TIPOS DE DATOS
EXEC sp_bindefault vp_SexoFemenino, 'txtSexos'
EXEC sp_bindefault vp_CategoriaAuxiliar, 'txtCategorias'
EXEC sp_bindefault vp_Cero, 'mnSalarios'
EXEC sp_bindefault vp_Cero, 'bytAcumulados'
EXEC sp_bindefault vp_Cero, 'bytNotas'
EXEC sp_bindefault vp_Cero, 'bytAsistencias'
EXEC sp_bindefault vp_Cero, 'bytTotales'
EXEC sp_bindefault vp_Reprobado, 'txtEquivalencias'

--Crear reglas
CREATE RULE r_Cedula
	AS @r_Cedula like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
CREATE RULE r_Sexo  
	AS @r_Sexo IN('F', 'M')
CREATE RULE r_Categoria
	AS @r_Categoria IN ('A', 'G', 'P')
CREATE RULE r_Salario
	AS @r_Salario >=0
CREATE RULE r_Fecha
	AS @r_Fecha <= getdate()
CREATE RULE r_NotaAcumulada
	AS @r_NotaAcumulada >=0 and @r_NotaAcumulada <=28
CREATE RULE r_NotaExamen
	AS @r_NotaExamen >=0 and @r_NotaExamen <=12
CREATE RULE r_NotaTotal
	AS @r_NotaTotal >=0 and @r_NotaTotal <=40
CREATE RULE r_Asistencia
	AS @r_Asistencia >=0 and @r_Asistencia <=100
CREATE RULE r_Equivalencia
	AS @r_Equivalencia IN ('E', 'A', 'R')
--Vincular reglas con tipos de datos
EXEC sp_bindrule r_Cedula, 'txtCedulas'
EXEC sp_bindrule r_Fecha, 'dtFechas'
EXEC sp_bindrule r_Sexo, 'txtSexos'
EXEC sp_bindrule r_Categoria, 'txtCategorias'
EXEC sp_bindrule r_Salario, 'mnSalarios'
EXEC sp_bindrule r_NotaAcumulada, 'bytAcumulados'
EXEC sp_bindrule r_NotaExamen, 'bytNotas'
EXEC sp_bindrule r_NotaTotal, 'bytTotales'
EXEC sp_bindrule r_Asistencia, 'bytAsistencias'
EXEC sp_bindrule r_Equivalencia, 'txtEquivalencias'

--CREAR TABLAS
CREATE TABLE MATERIAS(
	txtCodigo txtCodigo,
	txtNombre txtNombres
)

CREATE TABLE DOCENTES(
	txtCodigo txtCodigo,
	txtCedula txtCedulas,
	txtNombre txtNombres,
	txtDireccion varchar(50),
	txtTelefono txtTelefonos,
	txtSexo txtSexos,
	txtCategorias txtCategorias,
	mnSalario mnSalarios,
	dtFecha_Nacimiento dtFechas,
	dtFecha_Ingreso dtFechas
)

CREATE TABLE ESTUDIANTES(
	txtCodigo txtCodigo,
	txtCedula txtCedulas,
	txtNombre txtNombres,
	txtDireccion varchar(50),
	txtTelefono txtTelefonos,
	dtFecha_Nacimiento dtFechas,
	dtFecha_Ingreso dtFechas,
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
	txtEquivalencia txtEquivalencias
)

--AGREGAR LLAVES PRIMARIAS
ALTER TABLE MATERIAS ADD PRIMARY KEY(txtCodigo)
ALTER TABLE DOCENTES ADD PRIMARY KEY(txtCodigo)
ALTER TABLE ESTUDIANTES ADD PRIMARY KEY(txtCodigo)
ALTER TABLE EVALUACIONES ADD PRIMARY KEY(txtCodigoEstudiantes, txtCodMateria)--AGREGAR RESTRICCIONES DE VALORES ÚNICOSALTER TABLE DOCENTES ADD CONSTRAINT U_txtCedulaD UNIQUE txtCedula
ALTER TABLE ESTUDIANTES ADD CONSTRAINT U_txtCedulaE UNIQUE txtCedula--AGREGAR RELACIONESALTER TABLE EVALUACIONES ADD FOREIGN KEY(txtCodEstudiante) REFERENCES ESTUDIANTES(txtCodigo)
ALTER TABLE EVALUACIONES ADD FOREIGN KEY(txtCodMateria) REFERENCES MATERIAS(txtCodigo)--AGREGAR CHEQUEOSALTER TABLE DOCENTES ADD CONSTRAINT CK_FechaDocente CHECK(dtFecha_Ingreso > dtFecha_Nacimiento)
ALTER TABLE ESTUDIANTES ADD CONSTRAINT CK_FechaEstudiante CHECK (dtFecha_Ingreso > dtFecha_Nacimiento)