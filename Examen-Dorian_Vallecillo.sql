/*
Examen  #3 Diseño e Implementacion de Bases de Datos
Profesora; Marianela Solano Orias
Estudiantes: Dorian Vallecillo Calderon 
Grupo: 06
*/
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';


/*
Insercion de  Modelo
*/
create table cliente(
   cedula int not null,
   nombre varchar(30) not null,
   apellido_1 varchar(30) not null,
   apellido_2 varchar(30) not null,
   direccion varchar(50),
   e_mail varchar(30),
   fecha_inscripcion date not null,
   constraint pkcliente primary key (cedula)
);

create table instructores(
    cod_instructor int not null,
    nombre varchar(30) not null,
    apellido_1 varchar(30) not null,
    apellido_2 varchar(30) not null,
    direccion varchar(50),
    e_mail varchar(30),
    tel_cel int not null,
    tel_habitacion int not null,
    fecha_contratacion date not null,
    constraint pkinstructores primary key (cod_instructor)
);

create table cursos(
    id_curso int not null,
    descripcion varchar(50) not null,
    constraint pkcursos primary key (id_curso)
);

create table maquinas(
    id_maquina int not null,
    descripcion varchar(50) not null,
    constraint pkmaquinas primary key (id_maquina)
);

create table rutinas(
    id_rutina int not null,
    cliente int not null,
    instructor int not null,
    maquina int not null,
    fecha date not null,
    horas int not null,
    constraint pkrutinas primary key (id_rutina)
);

create table historial_curso(
    id_historial int not null,
    cliente int not null,
    instructor int not null,
    curso int not null,
    fecha date not null,
    horas int not null,
    constraint pkhistorial_curso primary key (id_historial),
    constraint fk1historial_curso foreign key (cliente) references cliente (cedula),
    constraint fk2historial_curso foreign key (instructor) references instructores (cod_instructor),
    constraint fk3historial_curso foreign key (curso) references cursos (id_curso)
);




/*c. Agregar a la tabla cliente los campos: Celular int y Tel_habitacion int , ambos deben ser
Not Null.*/
alter table cliente add celular int not null;

alter table cliente add tel_habitacion int not null;

--d. Agregar a la tabla Maquinas la columna Estado , varchar (15).
alter table maquinas add estado varchar(15);

/*e. Validar en las tablas Cliente e Instructores que si el campo e-mail no tiene datos se debe
almacenar lo siguiente *@*.com y si el campo direcci�n de ambas tablas no tiene datos
se debe almacenar N/A.*/

alter table cliente modify direccion default 'n/a';
alter table instructores modify direccion default 'n/a';

alter table cliente modify e_mail default '*@*.com';

alter table instructores modify e_mail  default '*@*.com';


/*f. Establecer los campos Cedula_Cliente, Cod_Instructor , Cod_Maquina , como llaves
for�neas en la tabla Rutinas.*/
alter table rutinas add constraint fkrutina_cliente foreign key (cliente) references cliente (cedula);
alter table rutinas add constraint fk2rutina_instructor foreign key (instructor) references instructores (cod_instructor);
/*Parte I

Validar INSERCIONES en cada tabla
1.No se deben insertar duplicados, si el registro que se va a insertar ya existe debe indicar por medio de un mensaje al usuario que ya existe.
2.Si el registro es insertado con éxito debe indicar al usuario por medio de un mensaje que la información se ha insertado correctamente.
3.En el caso de las tablas que poseen llaves foráneas, además de los puntos a y b se debe validar que la información a insertar realmente exista en las tablas padres correspondientes, en caso contrario indicar al usuario por medio de un mensaje.
*/


SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER VALIDATE_INSERT_CLIENTE
BEFORE INSERT ON cliente

FOR EACH ROW
DECLARE
    CLIENTE_EXISTENCE NUMBER := 0;
BEGIN
    IF INSERTING THEN
        SELECT COUNT(cedula) 
        INTO CLIENTE_EXISTENCE
        FROM cliente WHERE cedula = :NEW.cedula;
        IF CLIENTE_EXISTENCE != 0 THEN
        RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'El usuario ya existe');
        ELSE
        DBMS_OUTPUT.PUT_LINE('Usuario Insertado con exito!');
        END IF;
    END IF;
END VALIDATE_INSERT_CLIENTE;
/



SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER VALIDATE_INSERT_INSTRUCTORES
BEFORE INSERT ON instructores
FOR EACH ROW
DECLARE
    INSTRUCTORES_EXISTENCE NUMBER:=0;
BEGIN
    IF INSERTING THEN
        SELECT COUNT(cod_instructor)
        INTO INSTRUCTORES_EXISTENCE
        FROM instructores WHERE cod_instructor= :NEW.cod_instructor;
        IF INSTRUCTORES_EXISTENCE !=0 THEN
            RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'El instructor ya existe');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Instructor Insertado con exito!');
        END IF;
    END IF;
END VALIDATE_INSERT_INSTRUCTORES;
/

SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER VALIDATE_INSERT_CURSOS
BEFORE INSERT ON cursos
FOR EACH ROW
DECLARE
CURSOS_EXISTENCE NUMBER:=0;
BEGIN
    IF INSERTING THEN
    SELECT COUNT(id_curso)
    INTO CURSOS_EXISTENCE
    FROM cursos where id_curso= :NEW.id_curso;
        IF CURSOS_EXISTENCE !=0 THEN
            RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'El curso ya existe');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Curso Insertado con exito!');
        END IF;
    END IF;
END VALIDATE_INSERT_CURSOS;
/

SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER VALIDATE_INSERT_MAQUINAS
BEFORE INSERT ON maquinas
FOR EACH ROW
DECLARE
MAQUINAS_EXISTENCE NUMBER:=0;
BEGIN
    IF INSERTING THEN
    SELECT COUNT(id_maquina) 
    INTO MAQUINAS_EXISTENCE
    FROM maquinas WHERE id_maquina= :NEW.id_maquina;
        IF MAQUINAS_EXISTENCE !=0 THEN
            RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'La maquina ya existe');
        ELSE
        DBMS_OUTPUT.PUT_LINE('Maquina insertada con exito!');
        END IF;
    END IF;
END VALIDATE_INSERT_MAQUINAS;
/

SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER VALIDATE_INSERT_RUTINAS
BEFORE INSERT ON rutinas 

FOR EACH ROW
DECLARE
RUTINAS_EXISTENCE NUMBER:=0;
INSTRUCTORES_EXISTENCE NUMBER:=0;
CLIENTE_EXISTENCE NUMBER:=0;
BEGIN
    IF INSERTING THEN
        SELECT COUNT(id_rutina) 
        INTO RUTINAS_EXISTENCE
        FROM rutinas WHERE id_rutina= :NEW.id_rutina;

        SELECT COUNT(cod_instructor)
        INTO INSTRUCTORES_EXISTENCE
        FROM instructores WHERE cod_instructor= :NEW.instructor;

        SELECT COUNT(cedula)
        INTO CLIENTE_EXISTENCE
        FROM cliente where cedula= :NEW.cliente;

        IF CLIENTE_EXISTENCE = 0 THEN
            RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'El cliente no existe en la tabla Cliente');
        END IF;
        
        IF INSTRUCTORES_EXISTENCE = 0 THEN
            RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'El instructor no existe en la tabla Instructores');
        END IF;
        

        IF RUTINAS_EXISTENCE !=0 THEN
            RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'La rutina ya existe');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Rutina insertada con exito!');
        END IF;
    END IF;    
END VALIDATE_INSERT_RUTINAS;
/

SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER VALIDATE_INSERT_HIST_CURSO
BEFORE INSERT ON historial_curso
FOR EACH ROW
DECLARE
CURSO_EXISTENCE NUMBER:=0;
INSTRUCTORES_EXISTENCE NUMBER:=0;
CLIENTE_EXISTENCE NUMBER:=0;
HIST_EXISTENCE NUMBER :=0;
BEGIN
    IF INSERTING THEN

        SELECT COUNT(id_curso) 
        INTO CURSO_EXISTENCE
        FROM cursos where id_curso= :NEW.curso;

        SELECT COUNT(cedula)
        INTO CLIENTE_EXISTENCE
        FROM cliente where cedula= :NEW.cliente;

        SELECT COUNT(cod_instructor)
        INTO INSTRUCTORES_EXISTENCE
        FROM instructores WHERE cod_instructor= :NEW.instructor;

        SELECT COUNT(id_historial) 
        INTO HIST_EXISTENCE
        from historial_curso WHERE id_historial=:NEW.id_historial;

        IF CLIENTE_EXISTENCE = 0 THEN
                RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'El cliente no existe en la tabla Cliente');
        END IF;

        IF INSTRUCTORES_EXISTENCE = 0 THEN
            RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'El instructor no existe en la tabla Instructores');
        END IF;

        IF CURSO_EXISTENCE = 0 THEN
            RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'El curso no existe en la tabla Curso');
        END IF;

        IF HIST_EXISTENCE !=0 THEN
            RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Este historico ya existe');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Historico insertada con exito!');
        END IF;
        
            
    END IF;
END VALIDATE_INSERT_HIST_CURSO;
/




/*Parte II

Validar ACTUALIZACIONES en cada tabla
1.No se debe actualizar el campo de llave primaria o foránea (en el caso de las tablas hijas
2.Si la información que desea actualizar no existe, debe mostrar un mensaje al usuario que la información no se encuentra.
3.En caso de que la información sea actualizada correctamente, debe mostrar un mensaje al usuario indicando que la actualización se realizó correctamente y la cantidad de registros actualizados.
*/
SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER VALIDATE_UPDATE_CLIENTE
FOR UPDATE ON cliente
COMPOUND TRIGGER
COUNTER NUMBER := 0;
BEFORE EACH ROW IS 
     BEGIN
     IF :NEW.cedula!= :OLD.cedula THEN
    RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'No se pueden modificar las llaves primarias de las tablas hijas!');
    END IF;
END BEFORE EACH ROW; 
AFTER EACH ROW IS
BEGIN
COUNTER:= COUNTER + 1;
END AFTER EACH ROW;
AFTER STATEMENT IS
BEGIN
    IF COUNTER=0 THEN
            RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de cliente(s) especificado(s) NO existe!');
    END IF;
    IF UPDATING THEN
        DBMS_OUTPUT.PUT_LINE('Informacion actualizada con exito!');
        DBMS_OUTPUT.PUT_LINE('Registros actualizados en tabla Cliente: ' || COUNTER); 
    END IF;
END AFTER STATEMENT;
END VALIDATE_UPDATE_CLIENTE;
/


SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER VALIDATE_UPDATE_INSTRUCTORES
FOR UPDATE ON instructores
COMPOUND TRIGGER
COUNTER NUMBER := 0;
BEFORE EACH ROW IS
     BEGIN
     IF :NEW.cod_instructor!= :OLD.cod_instructor THEN
    RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'No se pueden modificar las llaves primarias de las tablas hijas!');
    END IF;
END BEFORE EACH ROW; 
AFTER EACH ROW IS
BEGIN
COUNTER:= COUNTER + 1;
END AFTER EACH ROW;
AFTER STATEMENT IS
BEGIN
    IF COUNTER=0 THEN
            RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de instructor especificado(s) NO existe!');
    END IF;
    IF UPDATING THEN
        DBMS_OUTPUT.PUT_LINE('Informacion actualizada con exito!');
        DBMS_OUTPUT.PUT_LINE('Registros actualizados en tabla Instructores: ' || COUNTER); 
    END IF;
END AFTER STATEMENT;
END VALIDATE_UPDATE_INSTRUCTORES;
/

SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER VALIDATE_UPDATE_CURSOS
FOR UPDATE ON cursos
COMPOUND TRIGGER
COUNTER NUMBER := 0;
BEFORE EACH ROW IS
     BEGIN
     IF :NEW.id_curso!= :OLD.id_curso THEN
    RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'No se pueden modificar las llaves primarias de las tablas hijas!');
    END IF;
END BEFORE EACH ROW; 
AFTER EACH ROW IS
BEGIN
COUNTER:= COUNTER + 1;
END AFTER EACH ROW;
AFTER STATEMENT IS
BEGIN
    IF COUNTER=0 THEN
            RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Curso especificado(s) NO existe!');
    END IF;
    IF UPDATING THEN
        DBMS_OUTPUT.PUT_LINE('Informacion actualizada con exito!');
        DBMS_OUTPUT.PUT_LINE('Registros actualizados en tabla Cursos: ' || COUNTER); 
    END IF;
END AFTER STATEMENT;
END VALIDATE_UPDATE_CURSOS;
/


SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER VALIDATE_UPDATE_MAQUINAS
FOR UPDATE ON maquinas
COMPOUND TRIGGER
COUNTER NUMBER := 0;
AFTER EACH ROW IS
BEGIN
COUNTER:= COUNTER + 1;
END AFTER EACH ROW;
AFTER STATEMENT IS
BEGIN
    IF COUNTER=0 THEN
            RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Maquina especificada(s) NO existe!');
    END IF;
    IF UPDATING THEN
        DBMS_OUTPUT.PUT_LINE('Informacion actualizada con exito!');
        DBMS_OUTPUT.PUT_LINE('Registros actualizados en tabla Maquinas: ' || COUNTER); 
    END IF;
END AFTER STATEMENT;
END VALIDATE_UPDATE_MAQUINAS;
/

SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER VALIDATE_UPDATE_RUTINAS
FOR UPDATE ON rutinas
COMPOUND TRIGGER
COUNTER NUMBER := 0;
AFTER EACH ROW IS
BEGIN
COUNTER:= COUNTER + 1;
END AFTER EACH ROW;
AFTER STATEMENT IS
BEGIN
    IF COUNTER=0 THEN
            RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Rutina especificado(s) NO existe!');
    END IF;
    IF UPDATING THEN
        DBMS_OUTPUT.PUT_LINE('Informacion actualizada con exito!');
        DBMS_OUTPUT.PUT_LINE('Registros actualizados en tabla Rutinas: ' || COUNTER); 
    END IF;
END AFTER STATEMENT;
END VALIDATE_UPDATE_RUTINAS;
/

SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER VALIDATE_UPDATE_HIST_CURSO
FOR UPDATE ON historial_curso
COMPOUND TRIGGER
COUNTER NUMBER := 0;
AFTER EACH ROW IS
BEGIN
COUNTER:= COUNTER + 1;
END AFTER EACH ROW;
AFTER STATEMENT IS
BEGIN
    IF COUNTER=0 THEN
            RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de HISTORIAL_CURSO especificado(s) NO existe!');
    END IF;
    IF UPDATING THEN
        DBMS_OUTPUT.PUT_LINE('Informacion actualizada con exito!');
        DBMS_OUTPUT.PUT_LINE('Registros actualizados en tabla HISTORIAL_CURSO: ' || COUNTER); 
    END IF;
END AFTER STATEMENT;
END VALIDATE_UPDATE_HIST_CURSO;
/


/*Parte III

Validar BORRADOS en cada tabla
1.No es permitido eliminar registros que estén relacionados, por lo que debe indicar al usuario por medio de mensaje, cual es la relación existente por la cual el registro o registros no pueden ser eliminados.
2.Si la información que desee eliminar no se encuentra, debe indicar al usuario por medio de un mensaje de que no ha encontrado la información.
3.En caso de que se realice el borrado correctamente, indicar al usuario por medio de un mensaje que el registro se eliminó con éxito y la cantidad de registros eliminados
*/
SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER VALIDATE_DELETE_CLIENTE
FOR DELETE ON cliente
COMPOUND TRIGGER
COUNTER NUMBER := 0;
EXISTENCE NUMBER:=0;
RELATED EXCEPTION;
PRAGMA EXCEPTION_INIT(RELATED, -2292);
BEFORE STATEMENT IS
     BEGIN
     IF EXISTENCE!=0 THEN
     RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Cliente NO se puede borrar ya que esta relacionada con Historial_Cursos!');
     END IF;
EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Cliente NO se puede borrar ya que esta relacionada con Historial_Cursos!');
END BEFORE STATEMENT;
BEFORE EACH ROW IS
BEGIN
 SELECT COUNT(cliente)
    INTO EXISTENCE
    FROM historial_curso where cliente=:NEW.cedula;
EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Cliente NO se puede borrar ya que esta relacionada con Historial_Cursos!');
END BEFORE EACH ROW;
AFTER EACH ROW IS
BEGIN
COUNTER:= COUNTER + 1;
EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Cliente NO se puede borrar ya que esta relacionada con Historial_Cursos!');
END AFTER EACH ROW;
AFTER STATEMENT IS
BEGIN
    IF COUNTER=0 THEN
            RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Cliente NO se puede borrar ya que esta relacionada con Historial_Cursos!');
        END IF;
    IF DELETING THEN
        DBMS_OUTPUT.PUT_LINE('Informacion elimiada con exito!');
        DBMS_OUTPUT.PUT_LINE('Registros borrados en tabla Cliente:' || COUNTER); 
    END IF;
EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Cliente NO se puede borrar ya que esta relacionada con Historial_Cursos!');
END AFTER STATEMENT;
END VALIDATE_DELETE_CLIENTE;
/


SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER VALIDATE_DELETE_INSTRUCTORES
FOR DELETE ON instructores
COMPOUND TRIGGER
COUNTER NUMBER := 0;
EXISTENCE_CLIENTE NUMBER:=0;
EXISTENCE_RUTINAS NUMBER:=0;
RELATED EXCEPTION;
PRAGMA EXCEPTION_INIT(RELATED, -2292);
BEFORE STATEMENT IS
     BEGIN
     IF EXISTENCE_RUTINAS!=0 THEN
     RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Instructores NO se puede borrar ya que esta relacionada con Rutinas!');
     END IF;
     IF EXISTENCE_CLIENTE!=0 THEN
     RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Instructores NO se puede borrar ya que esta relacionada con otras tablas!');
     END IF;
EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Instructores NO se puede borrar ya que esta relacionada con otras tablas');
END BEFORE STATEMENT;
BEFORE EACH ROW IS
BEGIN
 SELECT COUNT(instructor)
    INTO EXISTENCE_RUTINAS
    FROM historial_curso where instructor=:NEW.cod_instructor;

SELECT count(instructor)
INTO EXISTENCE_CLIENTE
FROM rutinas where instructor=:NEW.cod_instructor;

EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Instructores NO se puede borrar ya que esta relacionada con otras tablas');
END BEFORE EACH ROW;
AFTER EACH ROW IS
BEGIN
COUNTER:= COUNTER + 1;
EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Instructores NO se puede borrar ya que esta relacionada con otras tablas');
END AFTER EACH ROW;
AFTER STATEMENT IS
BEGIN
    IF COUNTER=0 THEN
            RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion no existe en la tabla Instructores');
        END IF;
    IF DELETING THEN
        DBMS_OUTPUT.PUT_LINE('Informacion elimiada con exito!');
        DBMS_OUTPUT.PUT_LINE('Registros borrados en tabla Instructores:' || COUNTER); 
    END IF;
EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Instructores NO se puede borrar ya que esta relacionada con otras tablas');
END AFTER STATEMENT;
END VALIDATE_DELETE_INSTRUCTORES;
/

SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER VALIDATE_DELETE_CURSOS
FOR DELETE ON cursos
COMPOUND TRIGGER
COUNTER NUMBER := 0;
EXISTENCE_CLIENTE NUMBER:=0;
RELATED EXCEPTION;
PRAGMA EXCEPTION_INIT(RELATED, -2292);
BEFORE STATEMENT IS
     BEGIN
     IF EXISTENCE_CLIENTE!=0 THEN
     RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Cursos NO se puede borrar ya que esta relacionada con otras tablas!');
     END IF;
EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Cursos NO se puede borrar ya que esta relacionada con otras tablas');
END BEFORE STATEMENT;
BEFORE EACH ROW IS
BEGIN
 SELECT COUNT(curso)
    INTO EXISTENCE_CLIENTE
    FROM historial_curso where curso=:NEW.id_curso;



EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Cursos NO se puede borrar ya que esta relacionada con otras tablas');
END BEFORE EACH ROW;
AFTER EACH ROW IS
BEGIN
COUNTER:= COUNTER + 1;
EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Cursos NO se puede borrar ya que esta relacionada con otras tablas');
END AFTER EACH ROW;
AFTER STATEMENT IS
BEGIN
    IF COUNTER=0 THEN
            RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion no existe en la tabla Cursos');
        END IF;
    IF DELETING THEN
        DBMS_OUTPUT.PUT_LINE('Informacion elimiada con exito!');
        DBMS_OUTPUT.PUT_LINE('Registros borrados en tabla Cursos:' || COUNTER); 
    END IF;
EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Cursos NO se puede borrar ya que esta relacionada con otras tablas');
END AFTER STATEMENT;
END VALIDATE_DELETE_CURSOS;
/
/*delete from cursos where id_curso=3 or id_curso =4;*/

SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER VALIDATE_DELETE_MAQUINAS
FOR DELETE ON maquinas
COMPOUND TRIGGER
COUNTER NUMBER := 0;
RELATED EXCEPTION;
PRAGMA EXCEPTION_INIT(RELATED, -2292);
BEFORE STATEMENT IS
     BEGIN
     NULL;
EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Maquinas NO se puede borrar ya que esta relacionada con otras tablas');
END BEFORE STATEMENT;

AFTER EACH ROW IS
BEGIN
COUNTER:= COUNTER + 1;
EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Maquinas NO se puede borrar ya que esta relacionada con otras tablas');
END AFTER EACH ROW;
AFTER STATEMENT IS
BEGIN
    IF COUNTER=0 THEN
            RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion no existe en la tabla Maquinas');
        END IF;
    IF DELETING THEN
        DBMS_OUTPUT.PUT_LINE('Informacion elimiada con exito!');
        DBMS_OUTPUT.PUT_LINE('Registros borrados en tabla Maquinas:' || COUNTER); 
    END IF;
EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Maquinas NO se puede borrar ya que esta relacionada con otras tablas');
END AFTER STATEMENT;
END VALIDATE_DELETE_MAQUINAS;
/

SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER VALIDATE_DELETE_RUTINAS
FOR DELETE ON RUTINAS
COMPOUND TRIGGER
COUNTER NUMBER := 0;
EXISTENCE_CLIENTE NUMBER:=0;
EXISTANCE_INSTRUCTORES NUMBER:=0;
RELATED EXCEPTION;
PRAGMA EXCEPTION_INIT(RELATED, -2292);
BEFORE STATEMENT IS
     BEGIN
     IF EXISTENCE_CLIENTE!=0  THEN
     RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Rutinas NO se puede borrar ya que esta relacionada con tabla Cliente!');
     END IF;
     IF EXISTANCE_INSTRUCTORES!=0 THEN
     RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Rutinas NO se puede borrar ya que esta relacionada con tabla Instructores');
     END IF;
EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Rutinas NO se puede borrar ya que esta relacionada con otras tablas');
END BEFORE STATEMENT;
BEFORE EACH ROW IS
BEGIN


 SELECT COUNT(cedula)
    INTO EXISTENCE_CLIENTE
    FROM cliente where cedula=:NEW.cliente;

SELECT COUNT(cod_instructor)
INTO EXISTANCE_INSTRUCTORES
FROM instructores where cod_instructor=:NEW.instructor;


EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Rutinas NO se puede borrar ya que esta relacionada con otras tablas');
END BEFORE EACH ROW;
AFTER EACH ROW IS
BEGIN
COUNTER:= COUNTER + 1;
EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Rutinas NO se puede borrar ya que esta relacionada con otras tablas');
END AFTER EACH ROW;
AFTER STATEMENT IS
BEGIN
    IF COUNTER=0 THEN
            RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion no existe en la tabla Instructores');
        END IF;
    IF DELETING THEN
        DBMS_OUTPUT.PUT_LINE('Informacion elimiada con exito!');
        DBMS_OUTPUT.PUT_LINE('Registros borrados en tabla Instructores:' || COUNTER); 
    END IF;
EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Rutinas NO se puede borrar ya que esta relacionada con otras tablas');
END AFTER STATEMENT;
END VALIDATE_DELETE_RUTINAS;
/

SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER VALIDATE_DELETE_HIST_CURSO
FOR DELETE ON historial_curso
COMPOUND TRIGGER
COUNTER NUMBER := 0;
EXISTENCE_CLIENTE NUMBER:=0;
EXISTANCE_INSTRUCTORES NUMBER:=0;
EXISTANCE_CURSO NUMBER:=0;
RELATED EXCEPTION;
PRAGMA EXCEPTION_INIT(RELATED, -2292);
BEFORE STATEMENT IS
     BEGIN
     IF EXISTENCE_CLIENTE!=0  THEN
     RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Rutinas NO se puede borrar ya que esta relacionada con tabla Cliente!');
     END IF;
     IF EXISTANCE_INSTRUCTORES!=0 THEN
     RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Rutinas NO se puede borrar ya que esta relacionada con tabla Cursos');
     END IF;
     IF EXISTANCE_CURSO !=0 THEN
     RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Rutinas NO se puede borrar ya que esta relacionada con tabla Cursos');
     END IF;
EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Rutinas NO se puede borrar ya que esta relacionada con otras tablas');
END BEFORE STATEMENT;
BEFORE EACH ROW IS
BEGIN

    SELECT COUNT(cedula)
    INTO EXISTENCE_CLIENTE
    FROM cliente where cedula=:NEW.cliente;

    SELECT COUNT(cod_instructor)
    INTO EXISTANCE_INSTRUCTORES
    FROM instructores where cod_instructor=:NEW.instructor;

    SELECT COUNT(id_curso)
    INTO EXISTANCE_CURSO 
    from cursos where id_curso=:NEW.curso;


EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Rutinas NO se puede borrar ya que esta relacionada con otras tablas');
END BEFORE EACH ROW;
AFTER EACH ROW IS
BEGIN
COUNTER:= COUNTER + 1;
EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Rutinas NO se puede borrar ya que esta relacionada con otras tablas');
END AFTER EACH ROW;
AFTER STATEMENT IS
BEGIN
    IF COUNTER=0 THEN
            RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion no existe en la tabla Cursos');
        END IF;
    IF DELETING THEN
        DBMS_OUTPUT.PUT_LINE('Informacion elimiada con exito!');
        DBMS_OUTPUT.PUT_LINE('Registros borrados en tabla Cursos:' || COUNTER); 
    END IF;
EXCEPTION
   WHEN RELATED THEN
           RAISE_APPLICATION_ERROR(NUM=> -20525, MSG=> 'Informacion de Rutinas NO se puede borrar ya que esta relacionada con otras tablas');
END AFTER STATEMENT;
END VALIDATE_DELETE_HIST_CURSO;
/

/*Parte IV

PROGRAMAR LAS SIGUIENTES PROCESOS ALMACENADOS
1.Permita mostrar por medio de la cédula de cliente, toda la información del cliente, el nombre del curso y el id de la rutina, así como el nombre del o los instructores que lo están entrenando.

2.Permita mostrar por medio del nombre del instructor, toda la información del instructor, el nombre del curso y el id la rutina, que tiene cargo y la cantidad de años que tiene de trabajar en el gimnasio (para este caso debe utilizar una función).*/
SET SERVEROUTPUT ON 
CREATE OR REPLACE PROCEDURE SHOW_CLIENTE(ID IN cliente.cedula%TYPE) AS
V_CEDULA NUMBER;
v_NOMBRE VARCHAR2(30);
V_AP1 VARCHAR2(30);
V_AP2 VARCHAR2(30);
V_DIRECCION VARCHAR2(50);
V_EMAIL VARCHAR2(30);
V_FECHA_INS DATE;
V_CELULAR NUMBER;
V_TEL_HAB NUMBER;
v_NOMBRE_INSTRUCTOR VARCHAR2(30);
v_NOMBRE_INSTRUCTOR1 VARCHAR2(30);

BEGIN
    DBMS_OUTPUT.PUT_LINE('----------------------Inicio-de-Proceso-Almacenado-------------------------------');
    
    DBMS_OUTPUT.PUT_LINE('  ');
    DBMS_OUTPUT.PUT_LINE('Informacion de cliente: ');
    DBMS_OUTPUT.PUT_LINE('  ');
     SELECT cedula, nombre, apellido_1, apellido_2, direccion, e_mail, fecha_inscripcion, celular, tel_habitacion
    INTO V_CEDULA, v_NOMBRE, V_AP1, V_AP2, V_DIRECCION, V_EMAIL, V_FECHA_INS, V_CELULAR, V_TEL_HAB
    from cliente WHERE cedula=ID;
    DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_NOMBRE);
    DBMS_OUTPUT.PUT_LINE('Primer Apellido: '|| V_AP1);
    DBMS_OUTPUT.PUT_LINE('Segundo Apellido: '|| V_AP2);
    DBMS_OUTPUT.PUT_LINE('Cedula: '||V_CEDULA);
    DBMS_OUTPUT.PUT_LINE('Direccion: '|| V_DIRECCION);
    DBMS_OUTPUT.PUT_LINE('e_mail: '|| V_EMAIL );
    DBMS_OUTPUT.PUT_LINE('Fecha de inscripcion: ' || V_FECHA_INS);
    DBMS_OUTPUT.PUT_LINE('Celular: '|| V_CELULAR);
    DBMS_OUTPUT.PUT_LINE('Telefono de habitacion: ' ||V_TEL_HAB);

    DBMS_OUTPUT.PUT_LINE('---Fin-Informacion-de-cliente------ ');
    DBMS_OUTPUT.PUT_LINE('  ');
    DBMS_OUTPUT.PUT_LINE('---Inicio-Informacion-de-Rutinas-del-cliente------ ');
    FOR i IN (SELECT id_rutina, instructor FROM rutinas where cliente=ID) LOOP
        SELECT nombre INTO v_NOMBRE_INSTRUCTOR FROM instructores where cod_instructor = i.instructor;
      dbms_output.put_line('RUTINA: ' || i.id_rutina || ' con el/la Instuctor : ' || v_NOMBRE_INSTRUCTOR);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('---Fin-Informacion-de-Rutinas-del-cliente------ ');
    DBMS_OUTPUT.PUT_LINE('  ');
    DBMS_OUTPUT.PUT_LINE('---Inicio-Informacion-de-Cursos-del-cliente------ ');
    FOR i IN (SELECT curso, instructor FROM historial_curso where cliente=ID) LOOP
        SELECT nombre INTO v_NOMBRE_INSTRUCTOR1 FROM instructores where cod_instructor = i.instructor;
      dbms_output.put_line('Curso: ' || i.curso || ' con el/la Instuctor : ' || v_NOMBRE_INSTRUCTOR1);
    END LOOP;
 DBMS_OUTPUT.PUT_LINE('---Fin-Informacion-de-Cursos-del-cliente------ ');
 DBMS_OUTPUT.PUT_LINE('  ');
 DBMS_OUTPUT.PUT_LINE('----------------------fin-de-Proceso-Almacenado-------------------------------');

END;
/

CREATE OR REPLACE FUNCTION instructor_anos(ID IN instructores.cod_instructor%TYPE) return NUMBER IS
SYS_DATE DATE;
HIRE_DATE DATE;
YEAR_1 NUMBER;
YEAR_2 NUMBER;
BEGIN
    SELECT SYSDATE INTO SYS_DATE FROM dual;

    SELECT fecha_contratacion INTO HIRE_DATE from instructores where cod_instructor=ID;
    YEAR_1:=EXTRACT(YEAR FROM SYS_DATE);
    YEAR_2:=EXTRACT(YEAR FROM HIRE_DATE);
    RETURN  YEAR_1 - YEAR_2 ;
END instructor_anos;
/


SET SERVEROUTPUT ON 
CREATE OR REPLACE PROCEDURE SHOW_CLIENTE(ID IN cliente.cedula%TYPE) AS
V_CEDULA NUMBER;
v_NOMBRE VARCHAR2(30);
V_AP1 VARCHAR2(30);
V_AP2 VARCHAR2(30);
V_DIRECCION VARCHAR2(50);
V_EMAIL VARCHAR2(30);
V_FECHA_INS DATE;
V_CELULAR NUMBER;
V_TEL_HAB NUMBER;
v_NOMBRE_INSTRUCTOR VARCHAR2(30);
v_NOMBRE_INSTRUCTOR1 VARCHAR2(30);
V_EXISTANCE NUMBER;

BEGIN
SELECT COUNT(cedula) into V_EXISTANCE from cliente where cedula=ID;
IF V_EXISTANCE!=0 THEN
    DBMS_OUTPUT.PUT_LINE('----------------------Inicio-de-Proceso-Almacenado-------------------------------');
    
    DBMS_OUTPUT.PUT_LINE('  ');
    DBMS_OUTPUT.PUT_LINE('Informacion de cliente: ');
    DBMS_OUTPUT.PUT_LINE('  ');
     SELECT cedula, nombre, apellido_1, apellido_2, direccion, e_mail, fecha_inscripcion, celular, tel_habitacion
    INTO V_CEDULA, v_NOMBRE, V_AP1, V_AP2, V_DIRECCION, V_EMAIL, V_FECHA_INS, V_CELULAR, V_TEL_HAB
    from cliente WHERE cedula=ID;
    DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_NOMBRE);
    DBMS_OUTPUT.PUT_LINE('Primer Apellido: '|| V_AP1);
    DBMS_OUTPUT.PUT_LINE('Segundo Apellido: '|| V_AP2);
    DBMS_OUTPUT.PUT_LINE('Cedula: '||V_CEDULA);
    DBMS_OUTPUT.PUT_LINE('Direccion: '|| V_DIRECCION);
    DBMS_OUTPUT.PUT_LINE('e_mail: '|| V_EMAIL );
    DBMS_OUTPUT.PUT_LINE('Fecha de inscripcion: ' || V_FECHA_INS);
    DBMS_OUTPUT.PUT_LINE('Celular: '|| V_CELULAR);
    DBMS_OUTPUT.PUT_LINE('Telefono de habitacion: ' ||V_TEL_HAB);

    DBMS_OUTPUT.PUT_LINE('---Fin-Informacion-de-cliente------ ');
    DBMS_OUTPUT.PUT_LINE('  ');
    DBMS_OUTPUT.PUT_LINE('---Inicio-Informacion-de-Rutinas-del-cliente------ ');
    FOR i IN (SELECT id_rutina, instructor FROM rutinas where cliente=ID) LOOP
        SELECT nombre INTO v_NOMBRE_INSTRUCTOR FROM instructores where cod_instructor = i.instructor;
      dbms_output.put_line('RUTINA: ' || i.id_rutina || ' con el/la Instuctor : ' || v_NOMBRE_INSTRUCTOR);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('---Fin-Informacion-de-Rutinas-del-cliente------ ');
    DBMS_OUTPUT.PUT_LINE('  ');
    DBMS_OUTPUT.PUT_LINE('---Inicio-Informacion-de-Cursos-del-cliente------ ');
    FOR i IN (SELECT curso, instructor FROM historial_curso where cliente=ID) LOOP
        SELECT nombre INTO v_NOMBRE_INSTRUCTOR1 FROM instructores where cod_instructor = i.instructor;
      dbms_output.put_line('Curso: ' || i.curso || ' con el/la Instuctor : ' || v_NOMBRE_INSTRUCTOR1);
    END LOOP;
 DBMS_OUTPUT.PUT_LINE('---Fin-Informacion-de-Cursos-del-cliente------ ');
 DBMS_OUTPUT.PUT_LINE('  ');
 DBMS_OUTPUT.PUT_LINE('----------------------fin-de-Proceso-Almacenado-------------------------------');
 ELSE
    DBMS_OUTPUT.PUT_LINE('No existe el cliente la cedula dada. ');
END IF;
END;
/







/*Insercion de datos*/
 --Tabla cliente 
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';
insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, fecha_inscripcion, celular, tel_habitacion) values (200,'maria','ruiz','ruiz','barva','01/01/1995',11111111,22222222);
insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, e_mail, fecha_inscripcion, celular, tel_habitacion) values (201,'juan','paz','arias','alajuela','juan@hotmail.com','01/01/1995',22222222,11111111);
insert into cliente (cedula, nombre, apellido_1, apellido_2, fecha_inscripcion, celular, tel_habitacion) values (202,'pedro','perez','perez','20/04/1998',33333333,33333335);
insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, e_mail, fecha_inscripcion, celular, tel_habitacion) values (203,'jose','castro','ruiz','santo domingo','jruiz@gmail.com','20061998',44444444,55555555);
insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, e_mail, fecha_inscripcion, celular, tel_habitacion) values (204,'martha','diaz','ruiz','pavas','mdiaz@yahoo.es','02/01/2000',22222229,33333333);
insert into cliente (cedula, nombre, apellido_1, apellido_2, e_mail, fecha_inscripcion, celular, tel_habitacion) values (205,'xiomara','diaz','diaz','xdiaz@hotmail.com','03/02/2000',55555555,11111119);
insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, fecha_inscripcion, celular, tel_habitacion) values (206,'pablo','arias','arias','san jose','20/04/2001',55555556,11111112);
insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, e_mail, fecha_inscripcion, celular, tel_habitacion) values (207,'ana','arias','arias','san pedro','arias@gmail.com','25/04/2001',55555556,11111115);
insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, fecha_inscripcion, celular, tel_habitacion) values (208,'carmen','paz','arias','san jose','20/04/2002',55555556,11111115);
insert into cliente (cedula, nombre, apellido_1, apellido_2, fecha_inscripcion, celular, tel_habitacion) values (209,'miguel','orias','arias','20082002',55555557,11111114);

insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, fecha_inscripcion, celular, tel_habitacion) values (210,'julia','arias','cruz','san rafael','20/04/2003',55555559,11111119);
insert into cliente (cedula, nombre, apellido_1, apellido_2, fecha_inscripcion, celular, tel_habitacion) values (211,'paula','castillo','reyes','15/05/2003',66666666,77777777);
insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, e_mail, fecha_inscripcion, celular, tel_habitacion) values (212,'david','arias','arias','san jose','darias@gmail.com','20/10/2005',88888888,99999999);
insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, e_mail, fecha_inscripcion, celular, tel_habitacion) values (213,'andres','aguilar','rios','guadalupe','aaguilar@yahoo.com','10/12/2007',99999999,88888888);
insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, e_mail, fecha_inscripcion, celular, tel_habitacion) values (214,'maria jose','villalta','paz','heredia','mjvillalta@gmail.com','20/04/2011',77777777,66666666);
insert into cliente (cedula, nombre, apellido_1, apellido_2, direccion, fecha_inscripcion, celular, tel_habitacion) values (215,'pablo jose','castillo','arias','san jose','20/04/2011',33333333,66666666);


--tabla instructores
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';
insert into instructores (cod_instructor,nombre,apellido_1,apellido_2,direccion,tel_cel,tel_habitacion,fecha_contratacion)values(100, 'matio','jhoson','ruiz','san jose',11111111,22222222,'01/01/1995');
insert into instructores (cod_instructor,nombre,apellido_1,apellido_2,direccion,e_mail,tel_cel,tel_habitacion,fecha_contratacion)values(101, 'juliana','blackz','arias','alajuela','jul@hotmail.com',22222222,11111111,'01/01/1995');
insert into instructores (cod_instructor,nombre,apellido_1,apellido_2,tel_cel,tel_habitacion,fecha_contratacion)values(102, 'maria','perez','perez',33333333,33333335,'20/04/1998');
insert into instructores (cod_instructor,nombre,apellido_1,apellido_2,direccion,e_mail,tel_cel,tel_habitacion,fecha_contratacion)values(103, 'cristian','castro','ruiz','alajuela','cruiz@gmail.com',44444444,55555555,'20-06-1998');
insert into instructores (cod_instructor,nombre,apellido_1,apellido_2,direccion,e_mail,tel_cel,tel_habitacion,fecha_contratacion)values(104, 'margarita','mata','ruiz','pavas','mmata@yahoo.es',11111112,22222228,'20/01/2000');
insert into instructores (cod_instructor,nombre,apellido_1,apellido_2,e_mail,tel_cel,tel_habitacion,fecha_contratacion)values(105, 'shirley','ruiz','diaz','sruiz@hotmail.com',22222229,33333333,'03/02/2000');
insert into instructores (cod_instructor,nombre,apellido_1,apellido_2,tel_cel,tel_habitacion,fecha_contratacion)values(106, 'cameron','rojas','rojas',88888889,77777777,'20/07/2010');
insert into instructores (cod_instructor,nombre,apellido_1,apellido_2,e_mail,tel_cel,tel_habitacion,fecha_contratacion)values(107, 'patrick','ruiz','diaz','pactrick@hotmail.com',10101010,98989898,'15/12/2011');
insert into instructores (cod_instructor,nombre,apellido_1,apellido_2,tel_cel,tel_habitacion,fecha_contratacion)values(110, 'sharlotte','castillo','paz',99999999,22222233,'03/05/2010');



--tabla cursos
insert into cursos values (1,'yoga');
insert into cursos values (2,'defensa personal');
insert into cursos values (3,'kinboxing');
insert into cursos values (4,'spinnig');
insert into cursos values (5,'taebo');
insert into cursos values (6,'zumba');



--tabla maquinas

insert into maquinas values (51,'mancuernas','excelente');
insert into maquinas values (52,'caminadora','regular');
insert into maquinas values (53,'bicicleta estacionaria','excelente');
insert into maquinas values (54,'bicicleta spinning','bueno');
insert into maquinas values (55,'press de banca','regular');
insert into maquinas values (56,'press de pecho','bueno');

--tabla historial_curso
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';
insert into historial_curso values(1,200,110,6,'20/02/2000',2);
insert into historial_curso values(2,200,101,1,'20/02/2000',2);
insert into historial_curso values(3,205,105,2,'20/02/2000',3);
insert into historial_curso values(4,206,102,3,'03/05/2000',2);
insert into historial_curso values(5,201,101,4,'20/07/2000',4);
insert into historial_curso values(6,208,110,3,'18/08/2000',3);
insert into historial_curso values(7,208,110,1,'18/08/2000',2);
insert into historial_curso values(8,201,110,6,'18/08/2000',1);
insert into historial_curso values(9,210,102,1,'15/04/2007',1);
insert into historial_curso values(10,210,101,4,'15/04/2007',2);
insert into historial_curso values(11,210,105,3,'15/04/2007',1);
insert into historial_curso values(12,212,105,1,'10/05/2008',2);
insert into historial_curso values(13,213,105,2,'10/05/2008',2);
insert into historial_curso values(14,210,105,3,'10/05/2008',2);
insert into historial_curso values(15,201,105,4,'10/05/2008',2);
insert into historial_curso values(16,202,105,5,'10/05/2008',2);

--tabla rutinas
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';
insert into rutinas values(1,209,110,50,'20/02/2000',2);
insert into rutinas values(3,209,101,50,'20/02/2000',2);
insert into rutinas values(5,205,105,55,'20/02/2000',3);
insert into rutinas values(7,215,102,53,'03/05/2000',2);
insert into rutinas values(9,215,101,55,'20/07/2000',4);
insert into rutinas values(11,208,110,56,'18/08/2000',3);
insert into rutinas values(13,208,110,52,'18/08/2000',2);
insert into rutinas values(15,201,110,53,'18/08/2000',1);
insert into rutinas values(17,210,102,55,'15/04/2007',1);
insert into rutinas values(19,210,101,50,'15/04/2007',2);
insert into rutinas values(21,210,107,50,'15/04/2007',1);
insert into rutinas values(23,212,107,51,'10/05/2008',2);
insert into rutinas values(25,213,107,52,'10/05/2008',2);
insert into rutinas values(27,210,107,53,'10/05/2008',2);
insert into rutinas values(29,201,107,54,'10/05/2008',2);
insert into rutinas values(31,202,105,55,'10/05/2008',2);





/*Elimidado de datos*/
delete from historial_curso;
delete from rutinas;
delete from maquinas;
delete from instructores;
delete from cliente;
delete from cursos;
