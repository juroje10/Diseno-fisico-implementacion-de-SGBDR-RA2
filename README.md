# Diseño Físico e Implementación de SGBDR

Para esra práctica vamos a usar el sistema "BiblioGuest2.0"

---

## Apartado 1: Creación del Esquema Relacional

Se crean las cuatro tablas del sistema. Cada tabla dispone de una clave primaria artificial (ID autoincremental). Las claves foráneas incluyen opciones de borrado y actualización.

### 1.1 - Tabla SOCIOS

```mysql
-- 1.1 Tabla SOCIOS
CREATE TABLE SOCIOS (
    ID_Socio NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    DNI CHAR(9) NOT NULL,
    Nombre VARCHAR2(100) NOT NULL,
    Email VARCHAR2(150) NOT NULL,
    Telefono VARCHAR2(15)
);
```

### 1.2 - Tabla LIBROS

```mysql
-- 1.2 Tabla LIBROS
CREATE TABLE LIBROS (
    ID_Libro NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ISBN CHAR(13) NOT NULL,
    Titulo VARCHAR2(200) NOT NULL,
    Autor VARCHAR2(150) NOT NULL,
    Paginas NUMBER NOT NULL
);
```

### 1.3 - Tabla EJEMPLARES

```mysql
-- 1.3 Tabla EJEMPLARES
CREATE TABLE EJEMPLARES (
    ID_Ejemplar NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ID_Libro NUMBER NOT NULL,
    Estado VARCHAR2(20) NOT NULL,
    CONSTRAINT FK_EJEMPLARES_LIBROS FOREIGN KEY (ID_Libro)
        REFERENCES LIBROS(ID_Libro)
        ON DELETE CASCADE
);
```

### 1.4 - Tabla PRESTAMOS

```mysql
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
```

---

## Apartado 2: Tipos de Datos y ALTER TABLE

### 2.1 - Modificar SOCIOS: añadir fechas de registro y última modificación

```mysql
-- Fecha de registro (por defecto la fecha actual al insertar)
ALTER TABLE SOCIOS
ADD FechaRegistro DATE DEFAULT SYSDATE NOT NULL;

-- Última modificación
ALTER TABLE SOCIOS
ADD UltimaModificacion TIMESTAMP DEFAULT SYSTIMESTAMP;
```

### 2.2 - Diferencia entre DATE y TIMESTAMP

Ambos tipos almacenan información temporal, pero con distintos niveles de detalle:

- **DATE** → `'YYYY-MM-DD'` es una forma literal de fecha en Oracle.
- **SYSTIMESTAMP** → devuelve fecha, hora y fracciones de segundo actuales.

### 2.3 - Diferencia entre CHAR y VARCHAR

- `CHAR(9)` para DNI y `CHAR(13)` para ISBN: son identificadores de longitud siempre fija, por lo que CHAR es más eficiente.
- `VARCHAR` para Nombre, Email, Titulo, Autor: su longitud varía mucho entre registros, por lo que VARCHAR ahorra espacio y es más adecuado.

---

## Apartado 3: Restricciones CHECK y Clave Candidata

Se añade una restricción CHECK sobre el campo `Estado` del ejemplar para limitar los valores permitidos, y se declara `Email` como clave candidata (UNIQUE) en la tabla SOCIOS.

### Código SQL - ALTER TABLE

```mysql
-- Modificación de las tablas EJEMPLARES Y SOCIOS
ALTER TABLE EJEMPLARES
ADD CONSTRAINT CHK_EJEMPLARES_ESTADO
CHECK (Estado IN ('Disponible', 'Prestado', 'Nuevo', 'Bueno', 'Deteriorado'));

ALTER TABLE SOCIOS
ADD CONSTRAINT UQ_SOCIOS_EMAIL
UNIQUE (Email);
```

### Alternativa: restricciones integradas en CREATE TABLE

```mysql
-- 1.1 Tabla SOCIOS
CREATE TABLE SOCIOS (
    ID_Socio NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    DNI CHAR(9) NOT NULL,
    Nombre VARCHAR2(100) NOT NULL,
    Email VARCHAR2(150) NOT NULL,
    Telefono VARCHAR2(15),
    CONSTRAINT UQ_SOCIOS_EMAIL UNIQUE (Email)
);
```

```mysql
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
```

- `CHECK (Estado IN (...))`: garantiza integridad de dominio. Ningún INSERT o UPDATE podrá asignar un valor distinto a los definidos.
- `UNIQUE (Email)`: convierte Email en clave candidata. Al igual que la clave primaria (DNI), identifica unívocamente a cada socio, pero se permite que sea NULL (a diferencia de PK).

---

## Apartado 4: VISTA_PRESTAMOS_ACTIVOS

```mysql
-- Creación de la vista VISTA_PRESTAMOS_ACTIVOS
ALTER TABLE PRESTAMOS
ADD Fecha_Devolucion DATE;

CREATE OR REPLACE VIEW VISTA_PRESTAMOS_ACTIVOS AS
SELECT
    L.Titulo     AS Titulo_Libro,
    E.ID_Ejemplar AS Ejemplar,
    S.Nombre      AS Socio
FROM PRESTAMOS P
JOIN SOCIOS S     ON P.ID_Socio    = S.ID_Socio
JOIN EJEMPLARES E ON P.ID_Ejemplar = E.ID_Ejemplar
JOIN LIBROS L     ON E.ID_Libro    = L.ID_Libro
WHERE P.Fecha_Devolucion IS NULL;
```

---

## Apartado 5: Creación de un Índice

```mysql
-- Creación de INDEX para Libros
CREATE INDEX IDX_LIBROS_TITULO
ON LIBROS (Titulo);
```

---

## Apartado 6: TABLESPACE en Oracle

Un **TABLESPACE** es la unidad lógica de almacenamiento de Oracle. Agrupa uno o varios archivos físicos del sistema operativo (datafiles) donde se guardan los objetos de la base de datos.

---

## Apartado 7: Seguridad y Privilegios

```mysql
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
```

---

## Apartado 8: Conexión a Consola

**MySQL:**

```mysql
mysql -u root -p
```

**Oracle (SQL\*Plus):**

```mysql
sqlplus sys/Password1@//localhost:1521/XEPDB1 AS SYSDBA
```

---

## Apartado 9: Identificación de Herramientas

| Herramienta       | CLI (Consola) | Web | Escritorio (GUI) | Multi-extensión | Nativo MySQL | Nativo Oracle |
|-------------------|:---:|:---:|:---:|:---:|:---:|:---:|
| MySQL Workbench   |     |     | ✓   |     | ✓   |     |
| phpMyAdmin        |     | ✓   |     |     | ✓   |     |
| SQL Developer     |     |     | ✓   |     |     | ✓   |
| Visual Studio Code|     |     | ✓   | ✓   |     |     |
| mysql / sqlplus   | ✓   |     |     |     | ✓   | ✓   |
