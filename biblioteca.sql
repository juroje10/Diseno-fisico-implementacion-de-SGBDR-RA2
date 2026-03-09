-- 1.1 Tabla SOCIOS
CREATE TABLE SOCIOS (
    ID_Socio NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    DNI CHAR(9) NOT NULL,
    Nombre VARCHAR2(100) NOT NULL,
    Email VARCHAR2(150) NOT NULL,
    Telefono VARCHAR2(15),
    CONSTRAINT UQ_SOCIOS_EMAIL UNIQUE (Email)
);

-- 1.2 Tabla LIBROS
CREATE TABLE LIBROS (
    ID_Libro NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ISBN CHAR(13) NOT NULL,
    Titulo VARCHAR2(200) NOT NULL,
    Autor VARCHAR2(150) NOT NULL,
    Paginas NUMBER NOT NULL
);

-- 1.3 Tabla EJEMPLARES
CREATE TABLE EJEMPLARES (
    ID_Ejemplar NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ID_Libro NUMBER NOT NULL,
    Estado VARCHAR2(20) NOT NULL,
    CONSTRAINT CHK_ESTADO
        CHECK (Estado IN ('Nuevo', 'Bueno', 'Deteriorado')),
    CONSTRAINT FK_EJEMPLARES_LIBROS
        FOREIGN KEY (ID_Libro)
        REFERENCES LIBROS(ID_Libro)
        ON DELETE CASCADE
);

-- 1.4 Tabla PRESTAMOS
CREATE TABLE PRESTAMOS (
    ID_Prestamo NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ID_Socio NUMBER NOT NULL,
    ID_Ejemplar NUMBER NOT NULL,
    Fecha DATE NOT NULL,
    CONSTRAINT FK_PRESTAMOS_SOCIOS FOREIGN KEY (ID_Socio)
        REFERENCES SOCIOS(ID_Socio),
    CONSTRAINT FK_PRESTAMOS_EJEMPLARES FOREIGN KEY (ID_Ejemplar)
        REFERENCES EJEMPLARES(ID_Ejemplar)
);


-- Insertar datos a las tablas

INSERT INTO SOCIOS (DNI, Nombre, Email, Telefono) VALUES ('12345678A', 'Ana Pérez', 'ana@mail.com', '600111111');
INSERT INTO SOCIOS (DNI, Nombre, Email, Telefono) VALUES ('23456789B', 'Luis Gómez', 'luis@mail.com', '600222222');
INSERT INTO SOCIOS (DNI, Nombre, Email, Telefono) VALUES ('34567890C', 'María López', 'maria@mail.com', '600333333');
INSERT INTO SOCIOS (DNI, Nombre, Email, Telefono) VALUES ('45678901D', 'Javier Ruiz', 'javier@mail.com', '600444444');
INSERT INTO SOCIOS (DNI, Nombre, Email, Telefono) VALUES ('56789012E', 'Elena Fernández', 'elena@mail.com', '600555555');
INSERT INTO SOCIOS (DNI, Nombre, Email, Telefono) VALUES ('67890123F', 'Pablo Martín', 'pablo@mail.com', '600666666');
INSERT INTO SOCIOS (DNI, Nombre, Email, Telefono) VALUES ('78901234G', 'Laura Sánchez', 'laura@mail.com', '600777777');
INSERT INTO SOCIOS (DNI, Nombre, Email, Telefono) VALUES ('89012345H', 'Carlos Díaz', 'carlos@mail.com', '600888888');
INSERT INTO SOCIOS (DNI, Nombre, Email, Telefono) VALUES ('90123456I', 'Marta Ortega', 'marta@mail.com', '600999999');
INSERT INTO SOCIOS (DNI, Nombre, Email, Telefono) VALUES ('01234567J', 'Diego Ramos', 'diego@mail.com', '601000000');


INSERT INTO LIBROS (ISBN, Titulo, Autor, Paginas) VALUES ('9781234567890', 'El Quijote', 'Cervantes', 1056);
INSERT INTO LIBROS (ISBN, Titulo, Autor, Paginas) VALUES ('9782345678901', 'Cien Años de Soledad', 'García Márquez', 471);
INSERT INTO LIBROS (ISBN, Titulo, Autor, Paginas) VALUES ('9783456789012', '1984', 'George Orwell', 328);
INSERT INTO LIBROS (ISBN, Titulo, Autor, Paginas) VALUES ('9784567890123', 'La Odisea', 'Homero', 500);
INSERT INTO LIBROS (ISBN, Titulo, Autor, Paginas) VALUES ('9785678901234', 'El Principito', 'Antoine de Saint-Exupéry', 96);
INSERT INTO LIBROS (ISBN, Titulo, Autor, Paginas) VALUES ('9786789012345', 'Don Juan Tenorio', 'Zorrilla', 240);
INSERT INTO LIBROS (ISBN, Titulo, Autor, Paginas) VALUES ('9787890123456', 'Hamlet', 'Shakespeare', 320);
INSERT INTO LIBROS (ISBN, Titulo, Autor, Paginas) VALUES ('9788901234567', 'Orgullo y Prejuicio', 'Jane Austen', 432);
INSERT INTO LIBROS (ISBN, Titulo, Autor, Paginas) VALUES ('9789012345678', 'Moby Dick', 'Herman Melville', 635);
INSERT INTO LIBROS (ISBN, Titulo, Autor, Paginas) VALUES ('9780123456789', 'Crimen y Castigo', 'Fiódor Dostoyevski', 671);


INSERT INTO EJEMPLARES (ID_Libro, Estado) VALUES (1, 'Disponible');
INSERT INTO EJEMPLARES (ID_Libro, Estado) VALUES (1, 'Prestado');
INSERT INTO EJEMPLARES (ID_Libro, Estado) VALUES (2, 'Disponible');
INSERT INTO EJEMPLARES (ID_Libro, Estado) VALUES (2, 'Disponible');
INSERT INTO EJEMPLARES (ID_Libro, Estado) VALUES (3, 'Prestado');
INSERT INTO EJEMPLARES (ID_Libro, Estado) VALUES (4, 'Disponible');
INSERT INTO EJEMPLARES (ID_Libro, Estado) VALUES (5, 'Disponible');
INSERT INTO EJEMPLARES (ID_Libro, Estado) VALUES (6, 'Prestado');
INSERT INTO EJEMPLARES (ID_Libro, Estado) VALUES (7, 'Disponible');
INSERT INTO EJEMPLARES (ID_Libro, Estado) VALUES (8, 'Disponible');


INSERT INTO PRESTAMOS (ID_Socio, ID_Ejemplar, Fecha) VALUES (2, 2, SYSDATE - 5);
INSERT INTO PRESTAMOS (ID_Socio, ID_Ejemplar, Fecha) VALUES (3, 5, SYSDATE - 10);
INSERT INTO PRESTAMOS (ID_Socio, ID_Ejemplar, Fecha) VALUES (4, 6, SYSDATE - 2);
INSERT INTO PRESTAMOS (ID_Socio, ID_Ejemplar, Fecha) VALUES (1, 3, SYSDATE - 1);
INSERT INTO PRESTAMOS (ID_Socio, ID_Ejemplar, Fecha) VALUES (5, 8, SYSDATE - 7);
INSERT INTO PRESTAMOS (ID_Socio, ID_Ejemplar, Fecha) VALUES (6, 2, SYSDATE - 3);
INSERT INTO PRESTAMOS (ID_Socio, ID_Ejemplar, Fecha) VALUES (7, 5, SYSDATE - 4);
INSERT INTO PRESTAMOS (ID_Socio, ID_Ejemplar, Fecha) VALUES (8, 6, SYSDATE - 6);
INSERT INTO PRESTAMOS (ID_Socio, ID_Ejemplar, Fecha) VALUES (9, 9, SYSDATE - 8);
INSERT INTO PRESTAMOS (ID_Socio, ID_Ejemplar, Fecha) VALUES (10, 10, SYSDATE - 9);


-- Fecha de registro (por defecto la fecha actual al insertar)
ALTER TABLE SOCIOS
ADD FechaRegistro DATE DEFAULT SYSDATE NOT NULL;

-- Última modificación
ALTER TABLE SOCIOS
ADD UltimaModificacion TIMESTAMP DEFAULT SYSTIMESTAMP;


-- Modificación de las tablas EJEMPLARES Y SOCIOS
ALTER TABLE EJEMPLARES
ADD CONSTRAINT CHK_EJEMPLARES_ESTADO
CHECK (Estado IN ('Disponible', 'Prestado', 'Nuevo', 'Bueno', 'Deteriorado'));

ALTER TABLE SOCIOS
ADD CONSTRAINT UQ_SOCIOS_EMAIL
UNIQUE (Email);


-- Creación de la vista VISTA_PRESTAMOS_ACTIVOS
ALTER TABLE PRESTAMOS
ADD Fecha_Devolucion DATE;

CREATE OR REPLACE VIEW VISTA_PRESTAMOS_ACTIVOS AS
SELECT
    L.Titulo           AS Titulo_Libro,
    E.ID_Ejemplar      AS Ejemplar,
    S.Nombre           AS Socio
FROM PRESTAMOS P
JOIN SOCIOS S     ON P.ID_Socio = S.ID_Socio
JOIN EJEMPLARES E ON P.ID_Ejemplar = E.ID_Ejemplar
JOIN LIBROS L     ON E.ID_Libro = L.ID_Libro
WHERE P.Fecha_Devolucion IS NULL;


-- Creación de INDEX para Libros
CREATE INDEX IDX_LIBROS_TITULO
ON LIBROS (Titulo);


-- Crear super_admin con todos los privilegios
CREATE USER super_admin IDENTIFIED BY 'Inauzma1';
GRANT DBA TO super_admin;

-- Crear tecnico_inventario
CREATE USER tecnico_inventario IDENTIFIED BY 'Inazuma1';
GRANT CREATE SESSION TO tecnico_inventario;

-- Permisos de consulta y actualización sobre EJEMPLARES
GRANT SELECT, UPDATE ON EJEMPLARES TO tecnico_inventario;

-- Revocar el permiso de actualización
REVOKE UPDATE ON EJEMPLARES FROM tecnico_inventario;

-- Eliminar el usuario del sistema
DROP USER tecnico_inventario CASCADE;


















