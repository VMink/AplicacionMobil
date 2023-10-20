USE Donation_Tracking_DB;
DROP TABLE IF EXISTS OPE_BITACORA_PAGOS_DONATIVOS;
DROP TABLE IF EXISTS OPE_DONANTES;
DROP TABLE IF EXISTS OPE_DIRECCIONES_COBRO;
DROP TABLE IF EXISTS OPE_RECOLECTORES;
DROP TABLE IF EXISTS OPE_MANAGERS;
GO


--Creacion BD
CREATE TABLE OPE_MANAGERS (
    ID_MANAGER numeric(18,0) IDENTITY(1,1) NOT NULL PRIMARY KEY,
    A_PATERNO varchar(100) NOT NULL,
    A_MATERNO varchar(100),
    NOMBRE varchar(100) NOT NULL,
    USUARIO varchar(255) NOT NULL,
    PASS varchar(255) NOT NULL,
    SS_ varchar(255)
);
GO

CREATE TABLE OPE_RECOLECTORES (
    ID_RECOLECTOR numeric(18,0) IDENTITY(1,1) NOT NULL PRIMARY KEY,
    USUARIO varchar(255) NOT NULL,
    PASS varchar(255) NOT NULL,
    SS_ varchar(255),
    A_PATERNO varchar(100) NOT NULL,
    A_MATERNO varchar(100),
    NOMBRE varchar(100) NOT NULL,
    ZONA varchar(255),
    ID_MANAGER numeric(18,0) FOREIGN KEY REFERENCES OPE_MANAGERS (ID_MANAGER),
);
GO

CREATE TABLE OPE_DIRECCIONES_COBRO (
    ID_DIRECCION_COBRO numeric(18,0) IDENTITY(1,1) NOT NULL PRIMARY KEY,
    DIRECCION VARCHAR(500),
    REFERENCIA_DOMICILIO VARCHAR(255)
);
GO

CREATE TABLE OPE_DONANTES (
    ID_DONANTE numeric(18,0) IDENTITY(72000,69) NOT NULL PRIMARY KEY,
    A_PATERNO varchar(100) NOT NULL,
    A_MATERNO varchar(100),
    NOMBRE varchar(100) NOT NULL,
    FECHA_NAC date,
    EMAIL varchar(50) NOT NULL,
    ID_DIRECCION_COBRO numeric(18,0) FOREIGN KEY REFERENCES OPE_DIRECCIONES_COBRO(ID_DIRECCION_COBRO),
    TEL_CASA numeric(18,0),
    TEL_MOVIL numeric(13,0),
    GENERO varchar(100)
);
GO

CREATE TABLE OPE_BITACORA_PAGOS_DONATIVOS (
    ID_BITACORA numeric(18,0) IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ID_DONANTE numeric(18,0) FOREIGN KEY REFERENCES OPE_DONANTES (ID_DONANTE),
    ID_RECOLECTOR numeric(18,0) FOREIGN KEY REFERENCES OPE_RECOLECTORES (ID_RECOLECTOR),
    FECHA_COBRO date,
    FECHA_PAGO date,
    FORMA_PAGO varchar(255),
    IMPORTE float,
    RECIBO varchar(50),
    ESTATUS_PAGO numeric(18,0),
    COMENTARIOS varchar(max),
    FECHA_CONFIRMACION datetime,
    FECHA_REPROGRAMACION datetime,
);
GO

--STORED PROCEDURES
---- Create new OPE_MANAGERS
CREATE OR ALTER PROCEDURE InsertarNuevoManager (
        @A_PATERNO VARCHAR(100),
        @A_MATERNO VARCHAR(100),
        @NOMBRE VARCHAR(100),
        @USUARIO VARCHAR(255),
        @PASS VARCHAR(255)
    )
    AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @SALT NVARCHAR(255);
        SET @SALT = CONVERT(NVARCHAR(255), NEWID());

        DECLARE @PASSWORD_HASH NVARCHAR(255);
        SET @PASSWORD_HASH = HASHBYTES('SHA2_256', @SALT + @PASS);

        INSERT INTO OPE_MANAGERS (A_PATERNO, A_MATERNO, NOMBRE, USUARIO, PASS, SS_)
        VALUES (@A_PATERNO, @A_MATERNO, @NOMBRE, @USUARIO, @PASSWORD_HASH, @SALT);
END;
GO

---- Create new OPE_RECOLECTORES
CREATE OR ALTER PROCEDURE InsertarNuevoRecolector (
        @USUARIO VARCHAR(255),
        @PASS VARCHAR(255),
        @A_PATERNO VARCHAR(100),
        @A_MATERNO VARCHAR(100),
        @NOMBRE VARCHAR(100),
        @ZONA VARCHAR(255),
        @ID_MANAGER NUMERIC(18,0)
    )
    AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @SALT NVARCHAR(255);
        SET @SALT = CONVERT(NVARCHAR(255), NEWID());

        DECLARE @PASSWORD_HASH NVARCHAR(255);
        SET @PASSWORD_HASH = HASHBYTES('SHA2_256', @SALT + @PASS);

        INSERT INTO OPE_RECOLECTORES (USUARIO, PASS, SS_, A_PATERNO, A_MATERNO, NOMBRE, ZONA, ID_MANAGER)
        VALUES (@USUARIO, @PASSWORD_HASH, @SALT, @A_PATERNO, @A_MATERNO, @NOMBRE, @ZONA, @ID_MANAGER);
END;
GO

----Create new OPE_DIRECCIONES
CREATE OR ALTER PROCEDURE InsertarNuevaDireccion (
        @Direccion VARCHAR(500),
        @ReferenciaDomicilio VARCHAR(255)
    )
    AS
    BEGIN
        SET NOCOUNT ON;
        INSERT INTO OPE_DIRECCIONES_COBRO (
            DIRECCION,
            REFERENCIA_DOMICILIO
        )
        VALUES (
            @Direccion,
            @ReferenciaDomicilio
        );
END;
GO

---- Create new OPE_DONANTES
CREATE OR ALTER PROCEDURE InsertarNuevoDonante (
        @A_PATERNO VARCHAR(100),
        @A_MATERNO VARCHAR(100),
        @NOMBRE VARCHAR(100),
        @FECHA_NAC DATE,
        @EMAIL VARCHAR(50),
        @ID_DIRECCION_COBRO NUMERIC,
        @TEL_CASA NUMERIC,
        @TEL_MOVIL NUMERIC,
        @GENERO VARCHAR(100)
    )
    AS
    BEGIN
        SET NOCOUNT ON;
        INSERT INTO OPE_DONANTES (
            A_PATERNO,
            A_MATERNO,
            NOMBRE,
            FECHA_NAC,
            EMAIL,
            ID_DIRECCION_COBRO,
            TEL_CASA,
            TEL_MOVIL,
            GENERO
        )
        VALUES (
            @A_PATERNO,
            @A_MATERNO,
            @NOMBRE,
            @FECHA_NAC,
            @EMAIL,
            @ID_DIRECCION_COBRO,
            @TEL_CASA,
            @TEL_MOVIL,
            @GENERO
        );
END;
GO

---- Create new OPE_BITACORA_PAGOS_DONATIVOS
CREATE OR ALTER PROCEDURE InsertarNuevaBitacoraPagoDonativos (
        @ID_DONANTE NUMERIC(18,0),
        @ID_RECOLECTOR NUMERIC(18,0),
        @FECHA_COBRO DATE,
        @FECHA_PAGO DATE,
        @FORMA_PAGO VARCHAR(100),
        @IMPORTE FLOAT,
        @RECIBO VARCHAR(50),
        @ESTATUS_PAGO NUMERIC(18,0),
        @COMENTARIOS VARCHAR(MAX),
        @FECHA_CONFIRMACION DATETIME,
        @FECHA_REPROGRAMACION DATETIME
    )
    AS
    BEGIN
        SET NOCOUNT ON;
        INSERT INTO OPE_BITACORA_PAGOS_DONATIVOS 
        (
            ID_DONANTE,
            ID_RECOLECTOR,
            FECHA_COBRO,
            FECHA_PAGO,
            FORMA_PAGO,
            IMPORTE,
            RECIBO,
            ESTATUS_PAGO,
            COMENTARIOS,
            FECHA_CONFIRMACION,
            FECHA_REPROGRAMACION
        )
        VALUES
        (
            @ID_DONANTE,
            @ID_RECOLECTOR,
            @FECHA_COBRO,
            @FECHA_PAGO,
            @FORMA_PAGO,
            @IMPORTE,
            @RECIBO,
            @ESTATUS_PAGO,
            @COMENTARIOS,
            @FECHA_CONFIRMACION,
            @FECHA_REPROGRAMACION
        );  
END;
GO

---- Obtain daily data
CREATE OR ALTER PROCEDURE ObtenerDatosDiarios
        --@IdRecolector NUMERIC(18,0)
    AS
    BEGIN
        SET NOCOUNT ON;
        --DECLARE @CurrentDate date = GETDATE();
        SELECT
            --OPE_BITACORA_PAGOS_DONATIVOS.ID_BITACORA,
            OPE_BITACORA_PAGOS_DONATIVOS.ID_DONANTE,
            OPE_BITACORA_PAGOS_DONATIVOS.IMPORTE,
            OPE_BITACORA_PAGOS_DONATIVOS.ESTATUS_PAGO,
            OPE_DONANTES.TEL_CASA,
            OPE_DONANTES.TEL_MOVIL,
            OPE_DIRECCIONES_COBRO.DIRECCION,
            OPE_DIRECCIONES_COBRO.REFERENCIA_DOMICILIO
        FROM OPE_BITACORA_PAGOS_DONATIVOS

        INNER JOIN OPE_DONANTES ON OPE_BITACORA_PAGOS_DONATIVOS.ID_DONANTE = OPE_DONANTES.ID_DONANTE
        INNER JOIN OPE_DIRECCIONES_COBRO ON OPE_DONANTES.ID_DIRECCION_COBRO = OPE_DIRECCIONES_COBRO.ID_DIRECCION_COBRO
        --INNER JOIN OPE_RECOLECTORES ON OPE_BITACORA_PAGOS_DONATIVOS.ID_RECOLECTOR = OPE_RECOLECTORES.ID_RECOLECTOR
        --WHERE OPE_RECOLECTORES.ID_RECOLECTOR = @IdRecolector
            --AND OPE_BITACORA_PAGOS_DONATIVOS.FECHA_COBRO = @CurrentDate;
END;
GO

---- # Envio de Datos, actualizacion por botón
CREATE OR ALTER PROCEDURE ActualizarBitacoraPagosDonativos
        @ID_BITACORA numeric(18,0),
        @ESTATUS_PAGO numeric(18,0),
        @COMENTARIOS varchar(max)
    AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @CurrentDate date = GETDATE();
        UPDATE OPE_BITACORA_PAGOS_DONATIVOS
        SET ESTATUS_PAGO = @ESTATUS_PAGO,
            COMENTARIOS = @COMENTARIOS,
            FECHA_PAGO = @CurrentDate
        WHERE ID_BITACORA = @ID_BITACORA
END;
GO

-- Create a login procedure to verify user credentials
CREATE OR ALTER PROCEDURE VerificarCredencialesRecolector
    (
        @USUARIO VARCHAR(255),
        @PASS VARCHAR(255)
    )
    AS
    BEGIN 
        SET NOCOUNT ON;
        DECLARE @SALT NVARCHAR(255);
        DECLARE @STORED_PASSWORD_HASH NVARCHAR(255);

        -- Obtener el salt para el usuario
        SELECT @SALT = SS_, @STORED_PASSWORD_HASH = PASS
        FROM OPE_RECOLECTORES
        WHERE USUARIO = @USUARIO;

        -- Caso 1: Usuario no existe
        IF @SALT IS NULL
        BEGIN
            PRINT 'Username doesnt exist';
        END;
        DECLARE @INPUT_PASSWORD_HASH NVARCHAR(255);
        SET @INPUT_PASSWORD_HASH = HASHBYTES('SHA2_256', @SALT + @PASS);

        -- Caso 2: Contraseña corresponde a usuario
        IF @INPUT_PASSWORD_HASH = @STORED_PASSWORD_HASH
        BEGIN
            PRINT 'Login successful'; -- CAMBIAR
        END
        -- Caso 3: Contraseña es incorrecta
        ELSE
        BEGIN
            PRINT 'Incorrect Password';
        END;
    END;
GO

    

--POBLACION
-- Crear OPE_MANAGERS
EXEC InsertarNuevoManager @A_PATERNO = 'ArguetaA', @A_MATERNO = 'WolkeA', @NOMBRE = 'Maria Fernanda Admin', @USUARIO = 'Maferadmin', @PASS = '1234';
EXEC InsertarNuevoManager @A_PATERNO = 'LugoA', @A_MATERNO = 'QuintanaA', @NOMBRE = 'Eduardo Francisco Admin', @USUARIO = 'Lalodmin', @PASS = '1234';
EXEC InsertarNuevoManager @A_PATERNO = 'TellezA', @A_MATERNO = 'MirelesA', @NOMBRE = 'Gustavo Admin', @USUARIO = 'Gustavoadmin', @PASS = '1234';
EXEC InsertarNuevoManager @A_PATERNO = 'CurielA', @A_MATERNO = 'LopezA', @NOMBRE = 'Noemí Abigail Admin', @USUARIO = 'Abiadmin', @PASS = '1234';
EXEC InsertarNuevoManager @A_PATERNO = 'DanzosA', @A_MATERNO = 'GarciaA', @NOMBRE = 'Ramón Yuri Admin', @USUARIO = 'Ramonadmin', @PASS = '1234';
EXEC InsertarNuevoManager @A_PATERNO = 'Doeadmin', @A_MATERNO = 'Williamsadmin', @NOMBRE = 'Michaeladmin', @USUARIO = 'michael.doe.admin', @PASS = 'AdminSecure123';
EXEC InsertarNuevoManager @A_PATERNO = 'Smithadmin', @A_MATERNO = 'Brownadmin', @NOMBRE = 'Emilyadmin', @USUARIO = 'emily.smith.admin', @PASS = 'SecureAdminPass123';
EXEC InsertarNuevoManager @A_PATERNO = 'Johnsonadmin', @A_MATERNO = 'Milleradmin', @NOMBRE = 'Sophiaadmin', @USUARIO = 'sophia.johnson.admin', @PASS = 'AdminPassSophia123';
EXEC InsertarNuevoManager @A_PATERNO = 'Clarkadmin', @A_MATERNO = 'Andersonadmin', @NOMBRE = 'Matthewadmin', @USUARIO = 'matthew.clark.admin', @PASS = 'AdminMatthewSecure123';
EXEC InsertarNuevoManager @A_PATERNO = 'Tayloradmin', @A_MATERNO = 'Halladmin', @NOMBRE = 'Oliviaadmin', @USUARIO = 'olivia.taylor.admin', @PASS = 'TaylorAdminPass123';
EXEC InsertarNuevoManager @A_PATERNO = 'Smithadmin', @A_MATERNO = 'Garciaadmin', @NOMBRE = 'Danieladmin', @USUARIO = 'daniel.smith.admin', @PASS = 'DanielAdminPass123';
EXEC InsertarNuevoManager @A_PATERNO = 'Davisadmin', @A_MATERNO = 'Youngadmin', @NOMBRE = 'Avaadmin', @USUARIO = 'ava.davis.admin', @PASS = 'AdminAvaSecure123';
EXEC InsertarNuevoManager @A_PATERNO = 'Milleradmin', @A_MATERNO = 'Thompsonadmin', @NOMBRE = 'Jamesadmin', @USUARIO = 'james.miller.admin', @PASS = 'JamesAdminPass123';
EXEC InsertarNuevoManager @A_PATERNO = 'Martinezadmin', @A_MATERNO = 'Wardadmin', @NOMBRE = 'Sophieadmin', @USUARIO = 'sophie.martinez.admin', @PASS = 'SophieAdminSecure123';
EXEC InsertarNuevoManager @A_PATERNO = 'Johnsonadmin', @A_MATERNO = 'Bakeradmin', @NOMBRE = 'Nathanadmin', @USUARIO = 'nathan.johnson.admin', @PASS = 'AdminNathanSecure123';
EXEC InsertarNuevoManager @A_PATERNO = 'Smithadmin', @A_MATERNO = 'Rossadmin', @NOMBRE = 'Emmaadmin', @USUARIO = 'emma.smith.admin', @PASS = 'EmmaAdminPass123';
EXEC InsertarNuevoManager @A_PATERNO = 'Gonzalezadmin', @A_MATERNO = 'Leeadmin', @NOMBRE = 'Williamadmin', @USUARIO = 'william.gonzalez.admin', @PASS = 'AdminWilliamSecure123';
EXEC InsertarNuevoManager @A_PATERNO = 'Harrisadmin', @A_MATERNO = 'Carteradmin', @NOMBRE = 'Isabellaadmin', @USUARIO = 'isabella.harris.admin', @PASS = 'IsabellaAdminPass123';
EXEC InsertarNuevoManager @A_PATERNO = 'Johnsonadmin', @A_MATERNO = 'Murphyadmin', @NOMBRE = 'Alexanderadmin', @USUARIO = 'alexander.johnson.admin', @PASS = 'AdminAlexander123';
EXEC InsertarNuevoManager @A_PATERNO = 'Thomasadmin', @A_MATERNO = 'Martinadmin', @NOMBRE = 'Graceadmin', @USUARIO = 'grace.thomas.admin', @PASS = 'AdminGraceSecure123';
EXEC InsertarNuevoManager @A_PATERNO = 'Smithadmin', @A_MATERNO = 'Youngadmin', @NOMBRE = 'Ethanadmin', @USUARIO = 'ethan.smith.admin', @PASS = 'EthanAdminPass123';
EXEC InsertarNuevoManager @A_PATERNO = 'Halladmin', @A_MATERNO = 'Phillipsadmin', @NOMBRE = 'Miaadmin', @USUARIO = 'mia.hall.admin', @PASS = 'AdminMiaSecure123';
EXEC InsertarNuevoManager @A_PATERNO = 'Carteradmin', @A_MATERNO = 'Adamsadmin', @NOMBRE = 'Liamadmin', @USUARIO = 'liam.carter.admin', @PASS = 'AdminLiamSecure123';
EXEC InsertarNuevoManager @A_PATERNO = 'Scottadmin', @A_MATERNO = 'Mitchelladmin', @NOMBRE = 'Chloeadmin', @USUARIO = 'chloe.scott.admin', @PASS = 'AdminChloePass123';
EXEC InsertarNuevoManager @A_PATERNO = 'Smithadmin', @A_MATERNO = 'Davisadmin', @NOMBRE = 'Jacobadmin', @USUARIO = 'jacob.smith.admin', @PASS = 'AdminJacobSecure123'
EXEC InsertarNuevoManager @A_PATERNO = 'Smithadmin', @A_MATERNO = 'Johnsonadmin', @NOMBRE = 'Johnadmin', @USUARIO = 'john.smith.admin', @PASS = 'AdminPassword123';
-- Crear OPE_RECOLECTORES
EXEC InsertarNuevoRecolector @USUARIO = 'Maferrecolectora', @PASS = '1234', @A_PATERNO = 'ArguetaR', @A_MATERNO = 'WolkeR', @NOMBRE = 'Maria Fernanda Recolector', @ZONA = 'Central', @ID_MANAGER = 1;
EXEC InsertarNuevoRecolector @USUARIO = 'Lalorecolector', @PASS = '1234', @A_PATERNO = 'LugoR', @A_MATERNO = 'QuintanaR', @NOMBRE = 'Eduardo Francisco Recolector', @ZONA = 'Escobedo', @ID_MANAGER = 2;
EXEC InsertarNuevoRecolector @USUARIO = 'Gusrecolector', @PASS = '1234', @A_PATERNO = 'TellezR', @A_MATERNO = 'MirelesR', @NOMBRE = 'Gustavo Recolector', @ZONA = 'Guadalupe', @ID_MANAGER = 3;
EXEC InsertarNuevoRecolector @USUARIO = 'Abirecolector', @PASS = '1234', @A_PATERNO = 'CurielR', @A_MATERNO = 'LopezR', @NOMBRE = 'Noemí Abigail Recolector', @ZONA = 'Santa Catarina', @ID_MANAGER = 4;
EXEC InsertarNuevoRecolector @USUARIO = 'Ramonrecolector', @PASS = '1234', @A_PATERNO = 'DanzosR', @A_MATERNO = 'GarciaR', @NOMBRE = 'Ramón Yuri Recolector', @ZONA = 'San Jeronimo', @ID_MANAGER = 5;
EXEC InsertarNuevoRecolector @USUARIO = 'johndoerecolector', @PASS = 'RecolectorPassword123', @A_PATERNO = 'Doerecolector', @A_MATERNO = 'Johnsonrecolector', @NOMBRE = 'Johnrecolector', @ZONA = 'Central', @ID_MANAGER = 1;
EXEC InsertarNuevoRecolector @USUARIO = 'michaelrecolector', @PASS = 'RecolectorSecure123', @A_PATERNO = 'Smithrecolector', @A_MATERNO = 'Brownrecolector', @NOMBRE = 'Michaelrecolector', @ZONA = 'Apodaca', @ID_MANAGER = 1;
EXEC InsertarNuevoRecolector @USUARIO = 'emilyrecolector', @PASS = 'RecolectorPass123', @A_PATERNO = 'Johnsonrecolector', @A_MATERNO = 'Clarkrecolector', @NOMBRE = 'Emilyrecolector', @ZONA = 'San Pedro', @ID_MANAGER = 2;
EXEC InsertarNuevoRecolector @USUARIO = 'sophiarecolector', @PASS = 'RecolectorSecurePass123', @A_PATERNO = 'Martinezrecolector', @A_MATERNO = 'Davisrecolector', @NOMBRE = 'Sophierecolector', @ZONA = 'Guadalupe', @ID_MANAGER = 3;
EXEC InsertarNuevoRecolector @USUARIO = 'jamesrecolector', @PASS = 'RecolectorAdminPass123', @A_PATERNO = 'Taylorrecolector', @A_MATERNO = 'Martinrecolector', @NOMBRE = 'Jamesrecolector', @ZONA = 'Santa Catarina', @ID_MANAGER = 4;
EXEC InsertarNuevoRecolector @USUARIO = 'avarecolector', @PASS = 'RecolectorSecureAdmin123', @A_PATERNO = 'Jonesrecolector', @A_MATERNO = 'Lopezrecolector', @NOMBRE = 'Avarecolector', @ZONA = 'Garcia', @ID_MANAGER = 5;
EXEC InsertarNuevoRecolector @USUARIO = 'nathanrecolector', @PASS = 'RecolectorAdminSecure123', @A_PATERNO = 'Hillrecolector', @A_MATERNO = 'Gonzalezrecolector', @NOMBRE = 'Nathanrecolector', @ZONA = 'San Jeronimo', @ID_MANAGER = 1;
EXEC InsertarNuevoRecolector @USUARIO = 'emmarecolector', @PASS = 'RecolectorPassSecure123', @A_PATERNO = 'Bakerecolector', @A_MATERNO = 'Collinsrecolector', @NOMBRE = 'Emmarecolector', @ZONA = 'Escobedo', @ID_MANAGER = 2;
EXEC InsertarNuevoRecolector @USUARIO = 'alexanderrecolector', @PASS = 'RecolectorAdmin123', @A_PATERNO = 'Turnerrecolector', @A_MATERNO = 'Diazrecolector', @NOMBRE = 'Alexanderrecolector', @ZONA = 'Apodaca', @ID_MANAGER = 3;
EXEC InsertarNuevoRecolector @USUARIO = 'gracerecolector', @PASS = 'RecolectorPass123Secure', @A_PATERNO = 'Morrisonrecolector', @A_MATERNO = 'Smithrecolector', @NOMBRE = 'Gracerecolector', @ZONA = 'San Pedro', @ID_MANAGER = 4;
EXEC InsertarNuevoRecolector @USUARIO = 'ethanrecolector', @PASS = 'RecolectorPassAdmin123', @A_PATERNO = 'Jamesrecolector', @A_MATERNO = 'Walkerrecolector', @NOMBRE = 'Ethanrecolector', @ZONA = 'Guadalupe', @ID_MANAGER = 5;
EXEC InsertarNuevoRecolector @USUARIO = 'miarecolector', @PASS = 'RecolectorAdminSecurePass123', @A_PATERNO = 'Harrisonrecolector', @A_MATERNO = 'Lopezrecolector', @NOMBRE = 'Miarecolector', @ZONA = 'Santa Catarina', @ID_MANAGER = 1;
EXEC InsertarNuevoRecolector @USUARIO = 'liamrecolector', @PASS = 'RecolectorSecureAdmin123', @A_PATERNO = 'Carterrecolector', @A_MATERNO = 'Hernandezrecolector', @NOMBRE = 'Liamrecolector', @ZONA = 'Garcia', @ID_MANAGER = 2;
EXEC InsertarNuevoRecolector @USUARIO = 'chloerecolector', @PASS = 'RecolectorAdminPass123', @A_PATERNO = 'Phillipsrecolector', @A_MATERNO = 'Gutierrezrecolector', @NOMBRE = 'Chloerecolector', @ZONA = 'San Jeronimo', @ID_MANAGER = 3;
EXEC InsertarNuevoRecolector @USUARIO = 'jacobrecolector', @PASS = 'RecolectorPassSecure123', @A_PATERNO = 'Clarkrecolector', @A_MATERNO = 'Rodriguezrecolector', @NOMBRE = 'Jacobrecolector', @ZONA = 'Escobedo', @ID_MANAGER = 4;
EXEC InsertarNuevoRecolector @USUARIO = 'oliviarecolector', @PASS = 'RecolectorAdmin123Secure', @A_PATERNO = 'Youngrecolector', @A_MATERNO = 'Mendozarecolector', @NOMBRE = 'Oliviarecolector', @ZONA = 'Apodaca', @ID_MANAGER = 5;
EXEC InsertarNuevoRecolector @USUARIO = 'williamrecolector', @PASS = 'RecolectorPassSecureAdmin123', @A_PATERNO = 'Bakerecolector', @A_MATERNO = 'Lopezrecolector', @NOMBRE = 'Williamrecolector', @ZONA = 'San Pedro', @ID_MANAGER = 1;
EXEC InsertarNuevoRecolector @USUARIO = 'avarecolector', @PASS = 'RecolectorAdminPassSecure123', @A_PATERNO = 'Diazrecolector', @A_MATERNO = 'Collinsrecolector', @NOMBRE = 'Avarecolector', @ZONA = 'Guadalupe', @ID_MANAGER = 2;
EXEC InsertarNuevoRecolector @USUARIO = 'liamrecolector', @PASS = 'RecolectorSecurePass123Admin', @A_PATERNO = 'Turnerrecolector', @A_MATERNO = 'Smithrecolector', @NOMBRE = 'Liamrecolector', @ZONA = 'Santa Catarina', @ID_MANAGER = 3;
-- Crear OPE_DIRECCIONES
EXEC InsertarNuevaDireccion @Direccion = 'Monterrey, Calle A, 123, Apt 101', @ReferenciaDomicilio = 'Edificio al lado del parque';
EXEC InsertarNuevaDireccion @Direccion = 'Apodaca, Avenida B, 456, 2B', @ReferenciaDomicilio = 'Cerca del centro comercial';
EXEC InsertarNuevaDireccion @Direccion = 'Guadalupe, Calle C, 789, 3C', @ReferenciaDomicilio = 'Frente a la escuela';
EXEC InsertarNuevaDireccion @Direccion = 'Apodaca, Avenida D, 1011, 5D', @ReferenciaDomicilio = 'Al lado del supermercado';
EXEC InsertarNuevaDireccion @Direccion = 'San Pedro, Calle E, 1314, 4E', @ReferenciaDomicilio = 'Cerca del parque industrial';
EXEC InsertarNuevaDireccion @Direccion = 'Apodaca, Altavista, Apt 101, 5B, 12345', @ReferenciaDomicilio = 'Edificio al lado de tec';
EXEC InsertarNuevaDireccion @Direccion = 'Santa Catarina, Buenos Aires, 235, A2, 54321', @ReferenciaDomicilio = 'Casa roja';
EXEC InsertarNuevaDireccion @Direccion = 'San Pedro, Ingenieros, 283, BB, 13579', @ReferenciaDomicilio = 'A un lado de parque tec';
EXEC InsertarNuevaDireccion @Direccion = 'Guadalupe, Arquitectos, 69, C, 97531', @ReferenciaDomicilio = 'Cerca del edificio azul';
EXEC InsertarNuevaDireccion @Direccion = 'Guadalupe, Primavera, 999, Bb, 02468', @ReferenciaDomicilio = 'A un costado de Toshi Tiger';
EXEC InsertarNuevaDireccion @Direccion = 'Santiago, Buenos Aires, 1111111, NOP, 86420', @ReferenciaDomicilio = 'Frente la iglesia';
EXEC InsertarNuevaDireccion @Direccion = 'Santiago, Altavista, Apartamento 532, X69, 67140', @ReferenciaDomicilio = 'Por CEDES';
EXEC InsertarNuevaDireccion @Direccion = 'Apodaca, Altavista, Apt 102, 6C, 11111', @ReferenciaDomicilio = 'Cerca de Aulas 1';
EXEC InsertarNuevaDireccion @Direccion = 'Santa Catarina, Ingenieros, 235, B3, 22222', @ReferenciaDomicilio = 'Cerca de Aulas 2';
EXEC InsertarNuevaDireccion @Direccion = 'San Pedro, Arquitectos, 284, CC, 33333', @ReferenciaDomicilio = 'Cerca de Aulas 3';
EXEC InsertarNuevaDireccion @Direccion = 'Guadalupe, Primavera, 6969, D, 44444', @ReferenciaDomicilio = 'Cerca de Aulas 4';
EXEC InsertarNuevaDireccion @Direccion = 'Guadalupe, Altavista, 9999, Ee, 55555', @ReferenciaDomicilio = 'Cerca de Aulas 5';
EXEC InsertarNuevaDireccion @Direccion = 'Santiago, Ingenieros, 2222222, SIP, 66666', @ReferenciaDomicilio = 'Cerca de Aulas 6';
EXEC InsertarNuevaDireccion @Direccion = 'Santiago, Arquitectos, Apartamento 533, 69X, 77777', @ReferenciaDomicilio = 'Por tec';
-- Crear OPE_DONANTES
EXEC InsertarNuevoDonante @A_PATERNO = 'ArguetaD', @A_MATERNO = 'WolkeD', @NOMBRE = 'Maria Fernanda Donante', @FECHA_NAC = '1985-11-20', @EMAIL = 'maferargueta@tec.mx', @ID_DIRECCION_COBRO = 1, @TEL_CASA = 4445556666, @TEL_MOVIL = 9990001111, @GENERO = 'M';
EXEC InsertarNuevoDonante @A_PATERNO = 'LugoD', @A_MATERNO = 'QuintanaD', @NOMBRE = 'Eduardo Francisco Donante', @FECHA_NAC = '1980-03-15', @EMAIL = 'eduardo.lugo.donante@tec.mx', @ID_DIRECCION_COBRO = 2, @TEL_CASA = 5556667777, @TEL_MOVIL = 8889990000, @GENERO = 'Otro';
EXEC InsertarNuevoDonante @A_PATERNO = 'MirelesD', @A_MATERNO = 'TellezD', @NOMBRE = 'Gustavo Donante', @FECHA_NAC = '1992-07-10', @EMAIL = 'gustavo.mireles.donante@tec.mx', @ID_DIRECCION_COBRO = 3, @TEL_CASA = 6667778888, @TEL_MOVIL = 7778889999, @GENERO = 'M';
EXEC InsertarNuevoDonante @A_PATERNO = 'CurielD', @A_MATERNO = 'LopezD', @NOMBRE = 'Noemí Abigail Donante', @FECHA_NAC = '1988-05-03', @EMAIL = 'noemi.curiel.donante@tec.mx', @ID_DIRECCION_COBRO = 4, @TEL_CASA = 7778889999, @TEL_MOVIL = 8889990000, @GENERO = 'F';
EXEC InsertarNuevoDonante @A_PATERNO = 'DanzosD', @A_MATERNO = 'GarciaD', @NOMBRE = 'Ramón Yuri Donante', @FECHA_NAC = '1987-12-28', @EMAIL = 'ramon.danzos.donante@tec.mx', @ID_DIRECCION_COBRO = 5, @TEL_CASA = 8889990000, @TEL_MOVIL = 9990001111, @GENERO = 'M';
EXEC InsertarNuevoDonante @A_PATERNO = 'Lopezzdonante', @A_MATERNO = 'Hernandezdonante', @NOMBRE = 'Carladonante', @FECHA_NAC = '1985-11-20', @EMAIL = 'carla.lopez.donante@tec.mx', @ID_DIRECCION_COBRO = 6, @TEL_CASA = 4445556666, @TEL_MOVIL = 9990001111, @GENERO = "M";
EXEC InsertarNuevoDonante @A_PATERNO = 'Gonzalezdonante', @A_MATERNO = 'Martinezdonante', @NOMBRE = 'Josedonante', @FECHA_NAC = '1977-08-18', @EMAIL = 'jose.gonzalez.donante@tec.mx', @ID_DIRECCION_COBRO = 7, @TEL_CASA = 8887776666, @TEL_MOVIL = 2223334444, @GENERO = "M";
EXEC InsertarNuevoDonante @A_PATERNO = 'Perezdonante', @A_MATERNO = 'Ramirezdonante', @NOMBRE = 'Adriandonante', @FECHA_NAC = '1990-03-05', @EMAIL = 'adrian.perez.donante@tec.mx', @ID_DIRECCION_COBRO = 8, @TEL_CASA = 6665554444, @TEL_MOVIL = 5556667777, @GENERO = "M";
EXEC InsertarNuevoDonante @A_PATERNO = 'Suarezdonante', @A_MATERNO = 'Diazdonante', @NOMBRE = 'Rociodonante', @FECHA_NAC = '1984-06-27', @EMAIL = 'rocio.suarez.donante@tec.mx', @ID_DIRECCION_COBRO = 9, @TEL_CASA = 3334445555, @TEL_MOVIL = 5556667777 , @GENERO = "F";
EXEC InsertarNuevoDonante @A_PATERNO = 'Herreradonante', @A_MATERNO = 'Gomezdonante', @NOMBRE = 'Mariadonante', @FECHA_NAC = '1983-09-08', @EMAIL = 'maria.herrera.donante@tec.mx', @ID_DIRECCION_COBRO = 10, @TEL_CASA = 2223334444, @TEL_MOVIL = 8889990000, @GENERO = "F";
EXEC InsertarNuevoDonante @A_PATERNO = 'Maldonadodonante', @A_MATERNO = 'Herreradonante', @NOMBRE = 'Franciscodonante', @FECHA_NAC = '1979-12-12', @EMAIL = 'francisco.maldonado.donante@tec.mx', @ID_DIRECCION_COBRO = 11, @TEL_CASA = 5556667777, @TEL_MOVIL = 1112223333, @GENERO = "F";
EXEC InsertarNuevoDonante @A_PATERNO = 'Gomezdonante', @A_MATERNO = 'Fernandezdonante', @NOMBRE = 'Pauladonante', @FECHA_NAC = '1987-07-10', @EMAIL = 'paula.gomez.donante@tec.mx', @ID_DIRECCION_COBRO = 12, @TEL_CASA = 7778889999, @TEL_MOVIL = 1112223333, @GENERO = "M";
EXEC InsertarNuevoDonante @A_PATERNO = 'Fernandezdonante', @A_MATERNO = 'Torresdonante', @NOMBRE = 'Pedrodonante', @FECHA_NAC = '1986-09-18', @EMAIL = 'pedro.fernandez.donante@tec.mx', @ID_DIRECCION_COBRO = 13, @TEL_CASA = 8887776666, @TEL_MOVIL = 2223334444, @GENERO = "Otro";
EXEC InsertarNuevoDonante @A_PATERNO = 'Garciadonante', @A_MATERNO = 'Ruizdonante', @NOMBRE = 'Luciadonante', @FECHA_NAC = '1989-04-25', @EMAIL = 'lucia.garcia.donante@tec.mx', @ID_DIRECCION_COBRO = 14, @TEL_CASA = 6665554444, @TEL_MOVIL = 5556667777, @GENERO = "M";
EXEC InsertarNuevoDonante @A_PATERNO = 'Smithdonante', @A_MATERNO = 'Johnsondonante', @NOMBRE = 'Johndonante', @FECHA_NAC = '1980-01-01', @EMAIL = 'john.smith.donante@tec.mx', @ID_DIRECCION_COBRO = 15, @TEL_CASA = 1234567890, @TEL_MOVIL = 5555555555, @GENERO = "F";
EXEC InsertarNuevoDonante @A_PATERNO = 'Johnsondonante', @A_MATERNO = 'Smithdonante', @NOMBRE = 'Marydonante', @FECHA_NAC = '1975-05-15', @EMAIL = 'mary.johnson.donante@tec.mx', @ID_DIRECCION_COBRO = 16, @TEL_CASA = 1112223333, @TEL_MOVIL = 7778889999, @GENERO = "M";
EXEC InsertarNuevoDonante @A_PATERNO = 'Rodriguezdonante', @A_MATERNO = 'Garciadonante', @NOMBRE = 'Pedrodonante', @FECHA_NAC = '1988-09-25', @EMAIL = 'pedro.rodriguez.donante@tec.mx', @ID_DIRECCION_COBRO = 17, @TEL_CASA = 9876543210, @TEL_MOVIL = 9998887777, @GENERO = "Otro";
EXEC InsertarNuevoDonante @A_PATERNO = 'Martinezdonante', @A_MATERNO = 'Lopezzdonante', @NOMBRE = 'Anadonante', @FECHA_NAC = '1992-07-12', @EMAIL = 'ana.martinez.donante@tec.mx', @ID_DIRECCION_COBRO = 18, @TEL_CASA = 5554443333, @TEL_MOVIL = 1231231234, @GENERO = "F";
EXEC InsertarNuevoDonante @A_PATERNO = 'Santosdonante', @A_MATERNO = 'Gutierrezdonante', @NOMBRE = 'Luisdonante', @FECHA_NAC = '1982-04-03', @EMAIL = 'luis.santos.donante@tec.mx', @ID_DIRECCION_COBRO = 19, @TEL_CASA = 7776665555, @TEL_MOVIL = 1112223333, @GENERO = "F";

-- Crear OPE_BITACORA_PAGOS_DONATIVOS
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 72000, @ID_RECOLECTOR = 1, @FECHA_COBRO = '2023-10-18', @FECHA_PAGO = '2023-10-18', @FORMA_PAGO = "Tarjeta", @IMPORTE = 7187.47, @RECIBO = 'RC123', @ESTATUS_PAGO = 1, @COMENTARIOS = 'Pendiente', @FECHA_CONFIRMACION = '2023-10-21 00:00:00', @FECHA_REPROGRAMACION = NULL;
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 72069, @ID_RECOLECTOR = 2, @FECHA_COBRO = '2023-10-18', @FECHA_PAGO = '2023-10-18', @FORMA_PAGO = "Efectivo", @IMPORTE = 7764.43, @RECIBO = 'RC124', @ESTATUS_PAGO = 1, @COMENTARIOS = 'Pendiente', @FECHA_CONFIRMACION = '2023-10-21 00:00:00', @FECHA_REPROGRAMACION = NULL;
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 72138, @ID_RECOLECTOR = 3, @FECHA_COBRO = '2023-10-18', @FECHA_PAGO = '2023-10-18', @FORMA_PAGO = "Efectivo", @IMPORTE = 9247.53, @RECIBO = 'RC125', @ESTATUS_PAGO = 1, @COMENTARIOS = 'Pendiente', @FECHA_CONFIRMACION = '2023-10-21 00:00:00', @FECHA_REPROGRAMACION = NULL;
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 72207, @ID_RECOLECTOR = 4, @FECHA_COBRO = '2023-10-18', @FECHA_PAGO = '2023-10-18', @FORMA_PAGO = "Efectivo", @IMPORTE = 6207.56, @RECIBO = 'RC126', @ESTATUS_PAGO = 1, @COMENTARIOS = 'Pendiente', @FECHA_CONFIRMACION = '2023-10-21 00:00:00', @FECHA_REPROGRAMACION = NULL;
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 72276, @ID_RECOLECTOR = 5, @FECHA_COBRO = '2023-10-18', @FECHA_PAGO = '2023-10-18', @FORMA_PAGO = "Tarjeta", @IMPORTE = 8334.65, @RECIBO = 'RC127', @ESTATUS_PAGO = 1, @COMENTARIOS = 'Pendiente', @FECHA_CONFIRMACION = '2023-10-21 00:00:00', @FECHA_REPROGRAMACION = NULL;
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 72345, @ID_RECOLECTOR = 4, @FECHA_COBRO = '2023-10-18', @FECHA_PAGO = '2023-10-18', @FORMA_PAGO = "Efectivo", @IMPORTE = 1023.23, @RECIBO = 'RC128', @ESTATUS_PAGO = 1, @COMENTARIOS = 'Pendiente', @FECHA_CONFIRMACION = '2023-10-21 00:00:00', @FECHA_REPROGRAMACION = NULL;
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 72414, @ID_RECOLECTOR = 1, @FECHA_COBRO = '2023-10-18', @FECHA_PAGO = '2023-10-18', @FORMA_PAGO = "Cheque", @IMPORTE = 2824.99, @RECIBO = 'RC129', @ESTATUS_PAGO = 1, @COMENTARIOS = 'Pendiente', @FECHA_CONFIRMACION = '2023-10-21 00:00:00', @FECHA_REPROGRAMACION = NULL;
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 72483, @ID_RECOLECTOR = 2, @FECHA_COBRO = '2023-10-18', @FECHA_PAGO = '2023-10-18', @FORMA_PAGO = "Efectivo", @IMPORTE = 6806.12, @RECIBO = 'RC130', @ESTATUS_PAGO = 1, @COMENTARIOS = 'Pendiente', @FECHA_CONFIRMACION = '2023-10-21 00:00:00', @FECHA_REPROGRAMACION = NULL;
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 72552, @ID_RECOLECTOR = 3, @FECHA_COBRO = '2023-10-18', @FECHA_PAGO = '2023-10-18', @FORMA_PAGO = "Tarjeta", @IMPORTE = 3254.62, @RECIBO = 'RC131', @ESTATUS_PAGO = 1, @COMENTARIOS = 'Pendiente', @FECHA_CONFIRMACION = '2023-10-21 00:00:00', @FECHA_REPROGRAMACION = NULL;
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 72621,  @ID_RECOLECTOR = 1, @FECHA_COBRO = '2023-10-18', @FECHA_PAGO = '2023-10-18', @FORMA_PAGO = "Cheque", @IMPORTE = 9970.75, @RECIBO = 'RC132', @ESTATUS_PAGO = 1, @COMENTARIOS = 'Pendiente', @FECHA_CONFIRMACION = '2023-10-21 00:00:00', @FECHA_REPROGRAMACION = NULL;
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 72690,  @ID_RECOLECTOR = 2, @FECHA_COBRO = '2023-10-18', @FECHA_PAGO = '2023-10-18', @FORMA_PAGO = "Efectivo", @IMPORTE = 948.15, @RECIBO = 'RC133', @ESTATUS_PAGO = 1, @COMENTARIOS = 'Pendiente', @FECHA_CONFIRMACION = '2023-10-21 00:00:00', @FECHA_REPROGRAMACION = NULL;
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 72759,  @ID_RECOLECTOR = 1, @FECHA_COBRO = '2023-10-18', @FECHA_PAGO = '2023-10-18', @FORMA_PAGO = "Tarjeta", @IMPORTE = 5919.94, @RECIBO = 'RC134', @ESTATUS_PAGO = 1, @COMENTARIOS = 'Pendiente', @FECHA_CONFIRMACION = '2023-10-21 00:00:00', @FECHA_REPROGRAMACION = NULL;
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 72828,  @ID_RECOLECTOR = 5, @FECHA_COBRO = '2023-10-18', @FECHA_PAGO = '2023-10-18', @FORMA_PAGO = "Tarjeta", @IMPORTE = 2356.56, @RECIBO = 'RC135', @ESTATUS_PAGO = 1, @COMENTARIOS = 'Pendiente', @FECHA_CONFIRMACION = '2023-10-21 00:00:00', @FECHA_REPROGRAMACION = NULL;
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 72897,  @ID_RECOLECTOR = 4, @FECHA_COBRO = '2023-10-18', @FECHA_PAGO = '2023-10-18', @FORMA_PAGO = "Cheque", @IMPORTE = 5797.65, @RECIBO = 'RC136', @ESTATUS_PAGO = 1, @COMENTARIOS = 'Pendiente', @FECHA_CONFIRMACION = '2023-10-21 00:00:00', @FECHA_REPROGRAMACION = NULL;

--EXEC ObtenerDatosDiarios @UsuarioRecolector = 'johndoerecolector';
--EXEC ObtenerDatosDiarios
--EXEC ActualizarBitacoraPagosDonativos @ID_DONATIVO = 40514, @ESTATUS_PAGO = 2, @COMENTARIOS = 'PAGADO, WOOO';
--EXEC ActualizarBitacoraPagosDonativos @ID_DONATIVO = 41515, @ESTATUS_PAGO = 3, @COMENTARIOS = 'Reprogramado para 23 octubre de 5 a 6 pm';}