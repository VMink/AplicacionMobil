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
    ID_DONANTE numeric(18,0) IDENTITY(2000,69) NOT NULL PRIMARY KEY,
    A_PATERNO varchar(100) NOT NULL,
    A_MATERNO varchar(100),
    NOMBRE varchar(100) NOT NULL,
    FECHA_NAC date,
    EMAIL varchar(50) NOT NULL,
    ID_DIRECCION_COBRO numeric(18,0) FOREIGN KEY REFERENCES OPE_DIRECCIONES_COBRO(ID_DIRECCION_COBRO),
    TEL_CASA VARCHAR(30),
    TEL_MOVIL VARCHAR(30),
    GENERO varchar(100)
);
GO

CREATE TABLE OPE_BITACORA_PAGOS_DONATIVOS (
    ID_BITACORA numeric(18,0) IDENTITY(100,1) NOT NULL PRIMARY KEY,
    ID_DONANTE numeric(18,0) FOREIGN KEY REFERENCES OPE_DONANTES (ID_DONANTE),
    ID_RECOLECTOR numeric(18,0) FOREIGN KEY REFERENCES OPE_RECOLECTORES (ID_RECOLECTOR),
    ID_RECIBO numeric (18,0),
    FECHA_COBRO date,
    FECHA_PAGO datetime,
    IMPORTE float,
    ESTATUS_PAGO numeric(18,0),
    COMENTARIOS varchar(max),
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
        DECLARE @SALT VARCHAR(255);
        SET @SALT = CONVERT(VARCHAR(255), NEWID());

        DECLARE @PASSWORD_HASH VARCHAR(255);
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
        DECLARE @SALT VARCHAR(255);
        SET @SALT = CONVERT(VARCHAR(255), NEWID());

        DECLARE @PASSWORD_HASH VARCHAR(255);
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
        @TEL_CASA VARCHAR(18),
        @TEL_MOVIL VARCHAR(18),
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
        @ID_RECIBO NUMERIC (18,0),
        @FECHA_COBRO DATE,
        @IMPORTE FLOAT,
        @ESTATUS_PAGO NUMERIC(18,0),
        @COMENTARIOS VARCHAR(MAX)
    )
    AS
    BEGIN
        SET NOCOUNT ON;
        INSERT INTO OPE_BITACORA_PAGOS_DONATIVOS 
        (
            ID_DONANTE,
            ID_RECOLECTOR,
            FECHA_COBRO,
            ID_RECIBO,
            IMPORTE,
            ESTATUS_PAGO,
            COMENTARIOS
        )
        VALUES
        (
            @ID_DONANTE,
            @ID_RECOLECTOR,
            @FECHA_COBRO,
            @ID_RECIBO,
            @IMPORTE,
            @ESTATUS_PAGO,
            @COMENTARIOS
        );  
END;
GO

---- Obtener datos diarios de todos los repartidores
CREATE OR ALTER PROCEDURE ObtenerDatosDiariosManager
AS
BEGIN
    SET NOCOUNT ON;
    --DECLARE @Today DATE = GETDATE();

    SELECT
        OPE_BITACORA_PAGOS_DONATIVOS.ID_BITACORA,
        OPE_BITACORA_PAGOS_DONATIVOS.ID_DONANTE,
        OPE_BITACORA_PAGOS_DONATIVOS.ID_RECOLECTOR,
        OPE_RECOLECTORES.USUARIO AS USUARIO_RECOLECTOR,
        OPE_BITACORA_PAGOS_DONATIVOS.ID_RECIBO,
        OPE_BITACORA_PAGOS_DONATIVOS.FECHA_COBRO,
        OPE_BITACORA_PAGOS_DONATIVOS.FECHA_PAGO,
        OPE_BITACORA_PAGOS_DONATIVOS.IMPORTE,
        OPE_BITACORA_PAGOS_DONATIVOS.ESTATUS_PAGO,
        OPE_BITACORA_PAGOS_DONATIVOS.COMENTARIOS,
        OPE_DONANTES.TEL_CASA,
        OPE_DONANTES.TEL_MOVIL,
        OPE_DIRECCIONES_COBRO.DIRECCION,
        OPE_DIRECCIONES_COBRO.REFERENCIA_DOMICILIO,
        CONCAT(OPE_DONANTES.NOMBRE, ' ', OPE_DONANTES.A_PATERNO, ' ', OPE_DONANTES.A_MATERNO) AS NOMBRE_DONANTE
    FROM OPE_BITACORA_PAGOS_DONATIVOS
    INNER JOIN OPE_RECOLECTORES ON OPE_BITACORA_PAGOS_DONATIVOS.ID_RECOLECTOR = OPE_RECOLECTORES.ID_RECOLECTOR
    INNER JOIN OPE_DONANTES ON OPE_BITACORA_PAGOS_DONATIVOS.ID_DONANTE = OPE_DONANTES.ID_DONANTE
    INNER JOIN OPE_DIRECCIONES_COBRO ON OPE_DONANTES.ID_DIRECCION_COBRO = OPE_DIRECCIONES_COBRO.ID_DIRECCION_COBRO
    --WHERE OPE_BITACORA_PAGOS_DONATIVOS.FECHA_COBRO = @Today;
END;
GO

---- Datos diarios por recolector
CREATE OR ALTER PROCEDURE ObtenerDatosDiarios
        @IdRecolector NUMERIC(18,0)
    AS
    BEGIN
        SET NOCOUNT ON;
        --DECLARE @Today DATE = GETDATE();
        SELECT
            OPE_BITACORA_PAGOS_DONATIVOS.ID_BITACORA,
			OPE_BITACORA_PAGOS_DONATIVOS.ID_RECIBO,
            OPE_BITACORA_PAGOS_DONATIVOS.ID_DONANTE,
            OPE_BITACORA_PAGOS_DONATIVOS.IMPORTE,
            OPE_BITACORA_PAGOS_DONATIVOS.ESTATUS_PAGO,
            OPE_DONANTES.TEL_CASA,
            OPE_DONANTES.TEL_MOVIL,
            OPE_DIRECCIONES_COBRO.DIRECCION,
            OPE_DIRECCIONES_COBRO.REFERENCIA_DOMICILIO,
            CONCAT(OPE_DONANTES.NOMBRE, ' ', OPE_DONANTES.A_PATERNO, ' ', OPE_DONANTES.A_MATERNO) AS NOMBRE_DONANTE,
			OPE_BITACORA_PAGOS_DONATIVOS.FECHA_PAGO
        FROM OPE_BITACORA_PAGOS_DONATIVOS

        INNER JOIN OPE_DONANTES ON OPE_BITACORA_PAGOS_DONATIVOS.ID_DONANTE = OPE_DONANTES.ID_DONANTE
        INNER JOIN OPE_DIRECCIONES_COBRO ON OPE_DONANTES.ID_DIRECCION_COBRO = OPE_DIRECCIONES_COBRO.ID_DIRECCION_COBRO
        INNER JOIN OPE_RECOLECTORES ON OPE_BITACORA_PAGOS_DONATIVOS.ID_RECOLECTOR = OPE_RECOLECTORES.ID_RECOLECTOR
        WHERE OPE_RECOLECTORES.ID_RECOLECTOR = @IdRecolector
            --AND OPE_BITACORA_PAGOS_DONATIVOS.FECHA_COBRO = @Today;
END;
GO

---- Envio de Datos, actualizacion por botón
CREATE OR ALTER PROCEDURE ActualizarBitacoraPagosDonativos
    @ID_BITACORA numeric(18,0),
    @ESTATUS_PAGO numeric(18,0),
    @COMENTARIOS varchar(max)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        DECLARE @CurrentDateTime datetime = GETDATE();

        UPDATE OPE_BITACORA_PAGOS_DONATIVOS
        SET ESTATUS_PAGO = @ESTATUS_PAGO,
            COMENTARIOS = @COMENTARIOS,
            FECHA_PAGO = @CurrentDateTime
        WHERE ID_BITACORA = @ID_BITACORA;

        COMMIT TRANSACTION;
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO


-- Login Recolector con hasheo
CREATE OR ALTER PROCEDURE VerificarCredencialesRecolector
    (
        @USUARIO VARCHAR(255),
        @PASS VARCHAR(255)
    )
    AS
    BEGIN 
        SET NOCOUNT ON;
        DECLARE @SALT VARCHAR(255);
        DECLARE @STORED_PASSWORD_HASH VARCHAR(255);

        -- Obtener el salt para el usuario
        SELECT @SALT = SS_, @STORED_PASSWORD_HASH = PASS
        FROM OPE_RECOLECTORES
        WHERE USUARIO = @USUARIO;

        -- Caso 1: Usuario no existe
        IF @SALT IS NULL
        BEGIN
             SELECT 0 AS result;
            RETURN;
        END;

        DECLARE @INPUT_PASSWORD_HASH VARCHAR(255);
        SET @INPUT_PASSWORD_HASH = HASHBYTES('SHA2_256', @SALT + @PASS);

        -- Caso 2: Contraseña corresponde a usuario
        IF @INPUT_PASSWORD_HASH = @STORED_PASSWORD_HASH
        BEGIN
            SELECT OPE_RECOLECTORES.ID_RECOLECTOR AS result FROM OPE_RECOLECTORES WHERE USUARIO = @USUARIO;
            RETURN;
        END

        -- Caso 3: Contraseña es incorrecta
        ELSE
        BEGIN
            SELECT 0 AS result;
            RETURN;
        END;
    END;
GO

-- Login Manager con hasheo
CREATE OR ALTER PROCEDURE VerificarCredencialesManager
    (
        @USUARIO VARCHAR(255),
        @PASS VARCHAR(255)
    )
    AS
    BEGIN 
        SET NOCOUNT ON;
        DECLARE @SALT VARCHAR(255);
        DECLARE @STORED_PASSWORD_HASH VARCHAR(255);

        -- Obtener el salt para el usuario
        SELECT @SALT = SS_, @STORED_PASSWORD_HASH = PASS
        FROM OPE_MANAGERS
        WHERE USUARIO = @USUARIO;

        -- Caso 1: Usuario no existe
        IF @SALT IS NULL
        BEGIN
            SELECT 'Authentication failed' AS Result;
            RETURN;
        END;

        DECLARE @INPUT_PASSWORD_HASH VARCHAR(255);
        SET @INPUT_PASSWORD_HASH = HASHBYTES('SHA2_256', @SALT + @PASS);

        -- Caso 2: Contraseña corresponde a usuario
        IF @INPUT_PASSWORD_HASH = @STORED_PASSWORD_HASH
        BEGIN
            SELECT 'Authentication successful' AS Result;
            RETURN;
        END

        -- Caso 3: Contraseña es incorrecta
        ELSE
        BEGIN
            SELECT 'Authentication failed' AS Result;
            RETURN;
        END;
    END;
GO
    

--POBLACION
-- Crear OPE_MANAGERS
EXEC InsertarNuevoManager @A_PATERNO = 'Tellez', @A_MATERNO = 'Mireles', @NOMBRE = 'Gustavo Admin', @USUARIO = 'Gustavoadmin', @PASS = '12345';
EXEC InsertarNuevoManager @A_PATERNO = 'Argueta', @A_MATERNO = 'Wolke', @NOMBRE = 'Maria Fernanda Admin', @USUARIO = 'Maferadmin', @PASS = 'PawPatr0l13+';
EXEC InsertarNuevoManager @A_PATERNO = 'Lugo', @A_MATERNO = 'Quintana', @NOMBRE = 'Eduardo Francisco Admin', @USUARIO = 'Lalodmin', @PASS = 'PawPatr0l13+';
EXEC InsertarNuevoManager @A_PATERNO = 'Curiel', @A_MATERNO = 'Lopez', @NOMBRE = 'Noemí Abigail Admin', @USUARIO = 'Abiadmin', @PASS = 'PawPatr0l13+';
EXEC InsertarNuevoManager @A_PATERNO = 'Danzos', @A_MATERNO = 'Garcia', @NOMBRE = 'Ramón Yuri Admin', @USUARIO = 'Ramonadmin', @PASS = 'PawPatr0l13+';
EXEC InsertarNuevoManager @A_PATERNO = 'Doe', @A_MATERNO = 'William', @NOMBRE = 'Michaeladmin', @USUARIO = 'michael.doe.admin', @PASS = 'AdminSecure123';
EXEC InsertarNuevoManager @A_PATERNO = 'Smith', @A_MATERNO = 'Brown', @NOMBRE = 'Emilyadmin', @USUARIO = 'emily.smith.admin', @PASS = 'SecureAdminPass123';
EXEC InsertarNuevoManager @A_PATERNO = 'Johnson', @A_MATERNO = 'Miller', @NOMBRE = 'Sophiaadmin', @USUARIO = 'sophia.johnson.admin', @PASS = 'AdminPassSophia123';
EXEC InsertarNuevoManager @A_PATERNO = 'Clark', @A_MATERNO = 'Anderson', @NOMBRE = 'Matthewadmin', @USUARIO = 'matthew.clark.admin', @PASS = 'AdminMatthewSecure123';
EXEC InsertarNuevoManager @A_PATERNO = 'Taylor', @A_MATERNO = 'Hall', @NOMBRE = 'Oliviaadmin', @USUARIO = 'olivia.taylor.admin', @PASS = 'TaylorAdminPass123';
EXEC InsertarNuevoManager @A_PATERNO = 'Smith', @A_MATERNO = 'Garcia', @NOMBRE = 'Danieladmin', @USUARIO = 'daniel.smith.admin', @PASS = 'DanielAdminPass123';
EXEC InsertarNuevoManager @A_PATERNO = 'Davis', @A_MATERNO = 'Young', @NOMBRE = 'Avaadmin', @USUARIO = 'ava.davis.admin', @PASS = 'AdminAvaSecure123';
EXEC InsertarNuevoManager @A_PATERNO = 'Miller', @A_MATERNO = 'Thompson', @NOMBRE = 'Jamesadmin', @USUARIO = 'james.miller.admin', @PASS = 'JamesAdminPass123';
EXEC InsertarNuevoManager @A_PATERNO = 'Martinez', @A_MATERNO = 'Ward', @NOMBRE = 'Sophieadmin', @USUARIO = 'sophie.martinez.admin', @PASS = 'SophieAdminSecure123';
EXEC InsertarNuevoManager @A_PATERNO = 'Johnson', @A_MATERNO = 'Baker', @NOMBRE = 'Nathanadmin', @USUARIO = 'nathan.johnson.admin', @PASS = 'AdminNathanSecure123';
EXEC InsertarNuevoManager @A_PATERNO = 'Smith', @A_MATERNO = 'Ross', @NOMBRE = 'Emmaadmin', @USUARIO = 'emma.smith.admin', @PASS = 'EmmaAdminPass123';
EXEC InsertarNuevoManager @A_PATERNO = 'Gonzalez', @A_MATERNO = 'Lea', @NOMBRE = 'Williamadmin', @USUARIO = 'william.gonzalez.admin', @PASS = 'AdminWilliamSecure123';
EXEC InsertarNuevoManager @A_PATERNO = 'Harris', @A_MATERNO = 'Carter', @NOMBRE = 'Isabellaadmin', @USUARIO = 'isabella.harris.admin', @PASS = 'IsabellaAdminPass123';
EXEC InsertarNuevoManager @A_PATERNO = 'Johnson', @A_MATERNO = 'Murphy', @NOMBRE = 'Alexanderadmin', @USUARIO = 'alexander.johnson.admin', @PASS = 'AdminAlexander123';
EXEC InsertarNuevoManager @A_PATERNO = 'Thomas', @A_MATERNO = 'Martin', @NOMBRE = 'Graceadmin', @USUARIO = 'grace.thomas.admin', @PASS = 'AdminGraceSecure123';
EXEC InsertarNuevoManager @A_PATERNO = 'Smith', @A_MATERNO = 'Young', @NOMBRE = 'Ethanadmin', @USUARIO = 'ethan.smith.admin', @PASS = 'EthanAdminPass123';
EXEC InsertarNuevoManager @A_PATERNO = 'Hall', @A_MATERNO = 'Phillips', @NOMBRE = 'Miaadmin', @USUARIO = 'mia.hall.admin', @PASS = 'AdminMiaSecure123';
EXEC InsertarNuevoManager @A_PATERNO = 'Carter', @A_MATERNO = 'Adams', @NOMBRE = 'Liamadmin', @USUARIO = 'liam.carter.admin', @PASS = 'AdminLiamSecure123';
EXEC InsertarNuevoManager @A_PATERNO = 'Scott', @A_MATERNO = 'Mitchell', @NOMBRE = 'Chloeadmin', @USUARIO = 'chloe.scott.admin', @PASS = 'AdminChloePass123';
EXEC InsertarNuevoManager @A_PATERNO = 'Smith', @A_MATERNO = 'Davis', @NOMBRE = 'Jacobadmin', @USUARIO = 'jacob.smith.admin', @PASS = 'AdminJacobSecure123'
EXEC InsertarNuevoManager @A_PATERNO = 'Taylor', @A_MATERNO = 'Johnson', @NOMBRE = 'Johnadmin', @USUARIO = 'john.smith.admin', @PASS = 'AdminPassword123';
-- Crear OPE_RECOLECTORES
EXEC InsertarNuevoRecolector @USUARIO = 'claraRecolector', @PASS = 'clara123', @A_PATERNO = 'Lopez', @A_MATERNO = 'Lopez', @NOMBRE = 'Clara', @ZONA = 'Guadalupe', @ID_MANAGER = 1;
EXEC InsertarNuevoRecolector @USUARIO = '1234', @PASS = '1234', @A_PATERNO = 'Lopez', @A_MATERNO = 'Lopez', @NOMBRE = 'Clara', @ZONA = 'Guadalupe', @ID_MANAGER = 1;
EXEC InsertarNuevoRecolector @USUARIO = 'gustavoRecolector', @PASS = '12345', @A_PATERNO = 'Tellez', @A_MATERNO = 'Mireles', @NOMBRE = 'Gustavo', @ZONA = 'Guadalupe', @ID_MANAGER = 3;
EXEC InsertarNuevoRecolector @USUARIO = 'aferRecolector', @PASS = 'PawPatr0l13+', @A_PATERNO = 'Argueta', @A_MATERNO = 'Wolke', @NOMBRE = 'Maria Fernanda', @ZONA = 'Central', @ID_MANAGER = 1;
EXEC InsertarNuevoRecolector @USUARIO = 'laloRecolector', @PASS = 'PawPatr0l13+', @A_PATERNO = 'Lugo', @A_MATERNO = 'Quintana', @NOMBRE = 'Eduardo Francisco', @ZONA = 'Escobedo', @ID_MANAGER = 2;
EXEC InsertarNuevoRecolector @USUARIO = 'abiRecolector', @PASS = 'PawPatr0l13+', @A_PATERNO = 'Curiel', @A_MATERNO = 'Lopez', @NOMBRE = 'Noemí Abigail', @ZONA = 'Santa Catarina', @ID_MANAGER = 4;
EXEC InsertarNuevoRecolector @USUARIO = 'ramonRecolector', @PASS = 'PawPatr0l13+', @A_PATERNO = 'Danzos', @A_MATERNO = 'Garcia', @NOMBRE = 'Ramón Yuri', @ZONA = 'San Jeronimo', @ID_MANAGER = 5;
EXEC InsertarNuevoRecolector @USUARIO = 'johndoe', @PASS = 'RecolectorPassword123', @A_PATERNO = 'Doe', @A_MATERNO = 'Johnson', @NOMBRE = 'John', @ZONA = 'Central', @ID_MANAGER = 1;
EXEC InsertarNuevoRecolector @USUARIO = 'michael', @PASS = 'RecolectorSecure123', @A_PATERNO = 'Smith', @A_MATERNO = 'Brown', @NOMBRE = 'Michael', @ZONA = 'Apodaca', @ID_MANAGER = 1;
EXEC InsertarNuevoRecolector @USUARIO = 'emily', @PASS = 'RecolectorPass123', @A_PATERNO = 'Johnson', @A_MATERNO = 'Clark', @NOMBRE = 'Emily', @ZONA = 'San Pedro', @ID_MANAGER = 2;
EXEC InsertarNuevoRecolector @USUARIO = 'sophia', @PASS = 'RecolectorSecurePass123', @A_PATERNO = 'Martinez', @A_MATERNO = 'Davis', @NOMBRE = 'Sophie', @ZONA = 'Guadalupe', @ID_MANAGER = 3;
EXEC InsertarNuevoRecolector @USUARIO = 'james', @PASS = 'RecolectorAdminPass123', @A_PATERNO = 'Taylor', @A_MATERNO = 'Martin', @NOMBRE = 'James', @ZONA = 'Santa Catarina', @ID_MANAGER = 4;
EXEC InsertarNuevoRecolector @USUARIO = 'ava', @PASS = 'RecolectorSecureAdmin123', @A_PATERNO = 'Jones', @A_MATERNO = 'Lopez', @NOMBRE = 'Ava', @ZONA = 'Garcia', @ID_MANAGER = 5;
EXEC InsertarNuevoRecolector @USUARIO = 'nathan', @PASS = 'RecolectorAdminSecure123', @A_PATERNO = 'Hill', @A_MATERNO = 'Gonzalez', @NOMBRE = 'Nathan', @ZONA = 'San Jeronimo', @ID_MANAGER = 1;
EXEC InsertarNuevoRecolector @USUARIO = 'emma', @PASS = 'RecolectorPassSecure123', @A_PATERNO = 'Bake', @A_MATERNO = 'Collins', @NOMBRE = 'Emma', @ZONA = 'Escobedo', @ID_MANAGER = 2;
EXEC InsertarNuevoRecolector @USUARIO = 'alexander', @PASS = 'RecolectorAdmin123', @A_PATERNO = 'Turner', @A_MATERNO = 'Diaz', @NOMBRE = 'Alexander', @ZONA = 'Apodaca', @ID_MANAGER = 3;
EXEC InsertarNuevoRecolector @USUARIO = 'grace', @PASS = 'RecolectorPass123Secure', @A_PATERNO = 'Morrison', @A_MATERNO = 'Smith', @NOMBRE = 'Grace', @ZONA = 'San Pedro', @ID_MANAGER = 4;
EXEC InsertarNuevoRecolector @USUARIO = 'ethan', @PASS = 'RecolectorPassAdmin123', @A_PATERNO = 'James', @A_MATERNO = 'Walker', @NOMBRE = 'Ethan', @ZONA = 'Guadalupe', @ID_MANAGER = 5;
EXEC InsertarNuevoRecolector @USUARIO = 'mia', @PASS = 'RecolectorAdminSecurePass123', @A_PATERNO = 'Harrison', @A_MATERNO = 'Lopez', @NOMBRE = 'Mia', @ZONA = 'Santa Catarina', @ID_MANAGER = 1;
EXEC InsertarNuevoRecolector @USUARIO = 'liam', @PASS = 'RecolectorSecureAdmin123', @A_PATERNO = 'Carter', @A_MATERNO = 'Hernandez', @NOMBRE = 'Liam', @ZONA = 'Garcia', @ID_MANAGER = 2;
EXEC InsertarNuevoRecolector @USUARIO = 'chloe', @PASS = 'RecolectorAdminPass123', @A_PATERNO = 'Phillips', @A_MATERNO = 'Gutierrez', @NOMBRE = 'Chloe', @ZONA = 'San Jeronimo', @ID_MANAGER = 3;
EXEC InsertarNuevoRecolector @USUARIO = 'jacob', @PASS = 'RecolectorPassSecure123', @A_PATERNO = 'Clark', @A_MATERNO = 'Rodriguez', @NOMBRE = 'Jacob', @ZONA = 'Escobedo', @ID_MANAGER = 4;
EXEC InsertarNuevoRecolector @USUARIO = 'olivia', @PASS = 'RecolectorAdmin123Secure', @A_PATERNO = 'Young', @A_MATERNO = 'Mendoza', @NOMBRE = 'Olivia', @ZONA = 'Apodaca', @ID_MANAGER = 5;
EXEC InsertarNuevoRecolector @USUARIO = 'william', @PASS = 'RecolectorPassSecureAdmin123', @A_PATERNO = 'Bake', @A_MATERNO = 'Lopez', @NOMBRE = 'William', @ZONA = 'San Pedro', @ID_MANAGER = 1;
EXEC InsertarNuevoRecolector @USUARIO = 'ava', @PASS = 'RecolectorAdminPassSecure123', @A_PATERNO = 'Diaz', @A_MATERNO = 'Collins', @NOMBRE = 'Ava', @ZONA = 'Guadalupe', @ID_MANAGER = 2;
EXEC InsertarNuevoRecolector @USUARIO = 'liam', @PASS = 'RecolectorSecurePass123Admin', @A_PATERNO = 'Turner', @A_MATERNO = 'Smith', @NOMBRE = 'Liam', @ZONA = 'Santa Catarina', @ID_MANAGER = 3;
-- Crear OPE_DIRECCIONES
EXEC InsertarNuevaDireccion @Direccion = 'Monterrey, Calle A, Ext: 123, Int: Apt 101', @ReferenciaDomicilio = 'Edificio al lado del parque';
EXEC InsertarNuevaDireccion @Direccion = 'Apodaca, Avenida B, Ext: 456, Int: 2B', @ReferenciaDomicilio = 'Cerca del centro comercial';
EXEC InsertarNuevaDireccion @Direccion = 'Guadalupe, Calle C, Ext: 789, Int: 3C', @ReferenciaDomicilio = 'Frente a la escuela';
EXEC InsertarNuevaDireccion @Direccion = 'Apodaca, Avenida D, Ext: 1011, Int: 5D', @ReferenciaDomicilio = 'Al lado del supermercado';
EXEC InsertarNuevaDireccion @Direccion = 'San Pedro, Calle E, Ext: 1314, Int: 4E', @ReferenciaDomicilio = 'Cerca del parque industrial';
EXEC InsertarNuevaDireccion @Direccion = 'Apodaca, Altavista, Ext: Apt 101, Int: 5B', @ReferenciaDomicilio = 'Edificio al lado de tec';
EXEC InsertarNuevaDireccion @Direccion = 'Santa Catarina, Buenos Aires, Ext: 235, Int: A2', @ReferenciaDomicilio = 'Casa roja';
EXEC InsertarNuevaDireccion @Direccion = 'San Pedro, Ingenieros, Ext: 283, Int: BB', @ReferenciaDomicilio = 'A un lado de parque tec';
EXEC InsertarNuevaDireccion @Direccion = 'Guadalupe, Arquitectos, Ext: 69, Int: C', @ReferenciaDomicilio = 'Cerca del edificio azul';
EXEC InsertarNuevaDireccion @Direccion = 'Guadalupe, Primavera, Ext: 999, Int: Bb', @ReferenciaDomicilio = 'A un costado de Toshi Tiger';
EXEC InsertarNuevaDireccion @Direccion = 'Santiago, Buenos Aires, Ext: 11, Int: 15', @ReferenciaDomicilio = 'Frente la iglesia';
EXEC InsertarNuevaDireccion @Direccion = 'Santiago, Altavista, Ext: Apartamento 532, Int: X9', @ReferenciaDomicilio = 'Por CEDES';
EXEC InsertarNuevaDireccion @Direccion = 'Apodaca, Altavista, Ext: Apt 102, Int: 6C', @ReferenciaDomicilio = 'Cerca de Aulas 1';
EXEC InsertarNuevaDireccion @Direccion = 'Santa Catarina, Ingenieros, Ext: 235, Int: B3', @ReferenciaDomicilio = 'Cerca de Aulas 2';
EXEC InsertarNuevaDireccion @Direccion = 'San Pedro, Arquitectos, Ext: 284, Int: CC', @ReferenciaDomicilio = 'Cerca de Aulas 3';
EXEC InsertarNuevaDireccion @Direccion = 'Guadalupe, Primavera, Ext: 6969, Int: D', @ReferenciaDomicilio = 'Cerca de Aulas 4';
EXEC InsertarNuevaDireccion @Direccion = 'Guadalupe, Altavista, Ext: 9999, Int: Ee', @ReferenciaDomicilio = 'Cerca de Aulas 5';
EXEC InsertarNuevaDireccion @Direccion = 'Santiago, Ingenieros, Ext: 2, Int: 2', @ReferenciaDomicilio = 'Cerca de Aulas 6';
EXEC InsertarNuevaDireccion @Direccion = 'Santiago, Arquitectos, Ext: Apartamento 533, Int:6X', @ReferenciaDomicilio = 'Por tec';
-- Crear OPE_DONANTES
EXEC InsertarNuevoDonante @A_PATERNO = 'Mireles', @A_MATERNO = 'Tellez', @NOMBRE = 'Gustavo', @FECHA_NAC = '1992-07-10', @EMAIL = 'gustavo.mireles.donante@tec.mx', @ID_DIRECCION_COBRO = 3, @TEL_CASA = '+52 81 20680688', @TEL_MOVIL = '+52 998 55021790', @GENERO = 'M';
EXEC InsertarNuevoDonante @A_PATERNO = 'Argueta', @A_MATERNO = 'Wolke', @NOMBRE = 'Maria Fernanda', @FECHA_NAC = '1985-11-20', @EMAIL = 'maferargueta@tec.mx', @ID_DIRECCION_COBRO = 1, @TEL_CASA = '+52 951 91661830', @TEL_MOVIL = '+52 443 45565954', @GENERO = 'M';
EXEC InsertarNuevoDonante @A_PATERNO = 'Lugo', @A_MATERNO = 'Quintana', @NOMBRE = 'Eduardo Francisco', @FECHA_NAC = '1980-03-15', @EMAIL = 'eduardo.lugo.donante@tec.mx', @ID_DIRECCION_COBRO = 2, @TEL_CASA = '+52 81 14654265', @TEL_MOVIL = '+52 312 50020972', @GENERO = 'Otro';
EXEC InsertarNuevoDonante @A_PATERNO = 'Curiel', @A_MATERNO = 'Lopez', @NOMBRE = 'Noemí Abigail', @FECHA_NAC = '1988-05-03', @EMAIL = 'noemi.curiel.donante@tec.mx', @ID_DIRECCION_COBRO = 4, @TEL_CASA = '+52 998 50122159', @TEL_MOVIL = '+52 443 29110482', @GENERO = 'F';
EXEC InsertarNuevoDonante @A_PATERNO = 'Danzos', @A_MATERNO = 'Garcia', @NOMBRE = 'Ramón Yuri', @FECHA_NAC = '1987-12-28', @EMAIL = 'ramon.danzos.donante@tec.mx', @ID_DIRECCION_COBRO = 5, @TEL_CASA = '+52 844 09316998', @TEL_MOVIL = '+52 961 07725552', @GENERO = 'M';
EXEC InsertarNuevoDonante @A_PATERNO = 'Lopez', @A_MATERNO = 'Hernandez', @NOMBRE = 'Carla', @FECHA_NAC = '1985-11-20', @EMAIL = 'carla.lopez.donante@tec.mx', @ID_DIRECCION_COBRO = 6, @TEL_CASA = '+52 777 43740513', @TEL_MOVIL = '+52 667 56265068', @GENERO = 'M';
EXEC InsertarNuevoDonante @A_PATERNO = 'Garza', @A_MATERNO = 'Martinez', @NOMBRE = 'Jose', @FECHA_NAC = '1977-08-18', @EMAIL = 'jose.gonzalez.donante@tec.mx', @ID_DIRECCION_COBRO = 7, @TEL_CASA = '+52 777 03537865', @TEL_MOVIL = '+52 612 13745429', @GENERO = 'M';
EXEC InsertarNuevoDonante @A_PATERNO = 'Perez', @A_MATERNO = 'Ramirez', @NOMBRE = 'Adrian', @FECHA_NAC = '1990-03-05', @EMAIL = 'adrian.perez.donante@tec.mx', @ID_DIRECCION_COBRO = 8, @TEL_CASA = '+52 771 53130014', @TEL_MOVIL = '+52 492 49451830', @GENERO = 'M';
EXEC InsertarNuevoDonante @A_PATERNO = 'Suarez', @A_MATERNO = 'Diaz', @NOMBRE = 'Rocio', @FECHA_NAC = '1984-06-27', @EMAIL = 'rocio.suarez.donante@tec.mx', @ID_DIRECCION_COBRO = 9, @TEL_CASA = '+52 444 26912308', @TEL_MOVIL = '+52 993 53466647' , @GENERO = 'F';
EXEC InsertarNuevoDonante @A_PATERNO = 'Herrera', @A_MATERNO = 'Gomez', @NOMBRE = 'Maria', @FECHA_NAC = '1983-09-08', @EMAIL = 'maria.herrera.donante@tec.mx', @ID_DIRECCION_COBRO = 10, @TEL_CASA = '+52 614 28783164', @TEL_MOVIL = '+52 662 62043723', @GENERO = 'F';
EXEC InsertarNuevoDonante @A_PATERNO = 'Maldonado', @A_MATERNO = 'Herrera', @NOMBRE = 'Francis', @FECHA_NAC = '1979-12-12', @EMAIL = 'francisco.maldonado.donante@tec.mx', @ID_DIRECCION_COBRO = 11, @TEL_CASA = '+52 981 18994076', @TEL_MOVIL = '+52 844 78627840', @GENERO = 'F';
EXEC InsertarNuevoDonante @A_PATERNO = 'Gomez', @A_MATERNO = 'Fernandez', @NOMBRE = 'Paula', @FECHA_NAC = '1987-07-10', @EMAIL = 'paula.gomez.donante@tec.mx', @ID_DIRECCION_COBRO = 12, @TEL_CASA = '+52 951 67911586', @TEL_MOVIL = '+52 444 63266892', @GENERO = 'M';
EXEC InsertarNuevoDonante @A_PATERNO = 'Fernandez', @A_MATERNO = 'Torres', @NOMBRE = 'Pedro', @FECHA_NAC = '1986-09-18', @EMAIL = 'pedro.fernandez.donante@tec.mx', @ID_DIRECCION_COBRO = 13, @TEL_CASA = '+52 993 30782823', @TEL_MOVIL = '+52 614 90154505', @GENERO = 'Otro';
EXEC InsertarNuevoDonante @A_PATERNO = 'Garcia', @A_MATERNO = 'Ruiz', @NOMBRE = 'Lucia', @FECHA_NAC = '1989-04-25', @EMAIL = 'lucia.garcia.donante@tec.mx', @ID_DIRECCION_COBRO = 14, @TEL_CASA = '+52 33 37139007', @TEL_MOVIL = '+52 664 79279752', @GENERO = 'M';
EXEC InsertarNuevoDonante @A_PATERNO = 'Smith', @A_MATERNO = 'Johnson', @NOMBRE = 'John', @FECHA_NAC = '1980-01-01', @EMAIL = 'john.smith.donante@tec.mx', @ID_DIRECCION_COBRO = 15, @TEL_CASA = '+52 951 80601793', @TEL_MOVIL = '+52 612 42999658', @GENERO = 'F';
EXEC InsertarNuevoDonante @A_PATERNO = 'Johnson', @A_MATERNO = 'Smith', @NOMBRE = 'Mary', @FECHA_NAC = '1975-05-15', @EMAIL = 'mary.johnson.donante@tec.mx', @ID_DIRECCION_COBRO = 16, @TEL_CASA = '+52 229 66789854', @TEL_MOVIL = '+52 614 25118564', @GENERO = 'M';
EXEC InsertarNuevoDonante @A_PATERNO = 'Rodriguez', @A_MATERNO = 'Garcia', @NOMBRE = 'Pedro', @FECHA_NAC = '1988-09-25', @EMAIL = 'pedro.rodriguez.donante@tec.mx', @ID_DIRECCION_COBRO = 17, @TEL_CASA = '+52 993 20554740', @TEL_MOVIL = '+52 473 39998368', @GENERO = 'Otro';
EXEC InsertarNuevoDonante @A_PATERNO = 'Martinez', @A_MATERNO = 'Lopez', @NOMBRE = 'Ana', @FECHA_NAC = '1992-07-12', @EMAIL = 'ana.martinez.donante@tec.mx', @ID_DIRECCION_COBRO = 18, @TEL_CASA = '+52 999 20560065', @TEL_MOVIL = '+52 667 44490655', @GENERO = 'F';
EXEC InsertarNuevoDonante @A_PATERNO = 'Santos', @A_MATERNO = 'Gutierrez', @NOMBRE = 'Luis', @FECHA_NAC = '1982-04-03', @EMAIL = 'luis.santos.donante@tec.mx', @ID_DIRECCION_COBRO = 19, @TEL_CASA = '+52 981 91160505', @TEL_MOVIL = '+52 961 65689764', @GENERO = 'F';
-- Crear OPE_BITACORA_PAGOS_DONATIVOS
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 2000, @ID_RECOLECTOR = 1, @ID_RECIBO = 123456, @FECHA_COBRO = '2023-10-18', @IMPORTE = 7187.50, @ESTATUS_PAGO = 0, @COMENTARIOS = '';
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 2069, @ID_RECOLECTOR = 2, @ID_RECIBO = 654321, @FECHA_COBRO = '2023-10-18', @IMPORTE = 7764.00, @ESTATUS_PAGO = 1, @COMENTARIOS = 'BLABLABLA';
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 2138, @ID_RECOLECTOR = 3, @ID_RECIBO = 987654, @FECHA_COBRO = '2023-10-18', @IMPORTE = 9247.00, @ESTATUS_PAGO = 0, @COMENTARIOS = '';
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 2207, @ID_RECOLECTOR = 4, @ID_RECIBO = 246813, @FECHA_COBRO = '2023-10-18', @IMPORTE = 6207.00, @ESTATUS_PAGO = 0, @COMENTARIOS = '';
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 2276, @ID_RECOLECTOR = 5, @ID_RECIBO = 135792, @FECHA_COBRO = '2023-10-18', @IMPORTE = 8334.00, @ESTATUS_PAGO = 0, @COMENTARIOS = '';
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 2345, @ID_RECOLECTOR = 4, @ID_RECIBO = 864209, @FECHA_COBRO = '2023-10-18', @IMPORTE = 1023.50, @ESTATUS_PAGO = 0, @COMENTARIOS = '';
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 2414, @ID_RECOLECTOR = 1, @ID_RECIBO = 128128, @FECHA_COBRO = '2023-10-18', @IMPORTE = 2824.00, @ESTATUS_PAGO = 1, @COMENTARIOS = 'Entregado';
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 2483, @ID_RECOLECTOR = 2, @ID_RECIBO = 112233, @FECHA_COBRO = '2023-10-18', @IMPORTE = 6806.00, @ESTATUS_PAGO = 0, @COMENTARIOS = '';
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 2552, @ID_RECOLECTOR = 3, @ID_RECIBO = 445566, @FECHA_COBRO = '2023-10-18', @IMPORTE = 3254.00, @ESTATUS_PAGO = 0, @COMENTARIOS = '';
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 2621, @ID_RECOLECTOR = 1, @ID_RECIBO = 778899, @FECHA_COBRO = '2023-10-18', @IMPORTE = 9970.00, @ESTATUS_PAGO = 0, @COMENTARIOS = '';
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 2690, @ID_RECOLECTOR = 2, @ID_RECIBO = 789123, @FECHA_COBRO = '2023-10-18', @IMPORTE = 948.50, @ESTATUS_PAGO = 0, @COMENTARIOS = '';
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 2759, @ID_RECOLECTOR = 1, @ID_RECIBO = 256016, @FECHA_COBRO = '2023-10-18', @IMPORTE = 5919.00, @ESTATUS_PAGO = 0, @COMENTARIOS = '';
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 2828, @ID_RECOLECTOR = 5, @ID_RECIBO = 987123, @FECHA_COBRO = '2023-10-18', @IMPORTE = 2356.00, @ESTATUS_PAGO = 0, @COMENTARIOS = '';
EXEC InsertarNuevaBitacoraPagoDonativos @ID_DONANTE = 2897, @ID_RECOLECTOR = 4, @ID_RECIBO = 456321, @FECHA_COBRO = '2023-10-18', @IMPORTE = 5797.00, @ESTATUS_PAGO = 0, @COMENTARIOS = '';
