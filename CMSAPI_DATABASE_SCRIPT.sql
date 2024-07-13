USE [CustomerDB]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 13/07/2024 10:04:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustName] [varchar](100) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[RegDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ErrorLog]    Script Date: 13/07/2024 10:04:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ErrorLog](
	[eName] [varchar](200) NOT NULL,
	[eMessage] [varchar](max) NOT NULL,
	[eDate] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[AddCustomer]    Script Date: 13/07/2024 10:04:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddCustomer]
    @CustName VARCHAR(100),
    @Email VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON; 
    DECLARE @response INT;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the email already exists
        IF EXISTS (SELECT 1 FROM Customer WHERE Email = @Email)
        BEGIN
            -- Return 0 as the response code
            SET @response = 0;
        END
        ELSE
        BEGIN
            -- Insert the new customer record
            INSERT INTO Customer (Email,CustName, RegDate)
            VALUES (@Email,@CustName, SYSDATETIME()); 

             -- Return 1 as the response code
            SET @response = 1;
        END
        
        -- Commit the transaction
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION;

        -- Log the error
        INSERT INTO ErrorLog (eName, eMessage, eDate)
        VALUES ('AddCustomer', ERROR_MESSAGE(), SYSDATETIME()); 

        -- Return -1 as the response code
        SET @response = -1;
    END CATCH;
    
    -- Return the response
    SELECT @response;
END;
GO
/****** Object:  StoredProcedure [dbo].[DeleteCustomer]    Script Date: 13/07/2024 10:04:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteCustomer]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON; 
    DECLARE @response INT;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the customer exists
        IF NOT EXISTS (SELECT 1 FROM Customer WHERE Id = @Id)
        BEGIN
            -- Return 0 as the response code
            SET @response = 0;
        END
        ELSE
        BEGIN
            -- Delete the customer record
            DELETE FROM Customer WHERE Id = @Id;

            -- Return 1 as the response code
            SET @response = 1;
        END
        
        -- Commit the transaction
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION;

        -- Log the error
        INSERT INTO ErrorLog (eName, eMessage, eDate)
        VALUES ('DeleteCustomer', ERROR_MESSAGE(), SYSDATETIME());

        -- Return -1 as the response code
        SET @response = -1;
    END CATCH;
    
    -- Return the response
    SELECT @response;
END;
GO
/****** Object:  StoredProcedure [dbo].[GetCustomerById]    Script Date: 13/07/2024 10:04:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCustomerById]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON; 
    SELECT Id,custName,Email FROM Customer WHERE Id = @Id  
END;
GO
/****** Object:  StoredProcedure [dbo].[GetCustomers]    Script Date: 13/07/2024 10:04:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCustomers]   
AS
BEGIN
    SET NOCOUNT ON; 
    SELECT Id,custName,Email FROM Customer ORDER BY Id ASC
END;
GO
/****** Object:  StoredProcedure [dbo].[UpdateCustomer]    Script Date: 13/07/2024 10:04:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateCustomer]
    @Id INT,
    @CustName VARCHAR(100),
    @Email VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON; 
    DECLARE @response INT;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the email already exists for another customer
        IF EXISTS (SELECT 1 FROM Customer WHERE Email = @Email AND Id <> @Id)
        BEGIN
		    -- Return 0 as the response code
            SET @response = 0;
        END
        ELSE
        BEGIN
            -- Update the customer record
            UPDATE Customer
            SET Email = @Email,CustName=@CustName WHERE Id = @Id;

			-- Return 1 as the response code
            SET @response = 1;
        END
        
        -- Commit the transaction
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK TRANSACTION;

        -- Log the error
        INSERT INTO ErrorLog (eName, eMessage, eDate)
        VALUES ('UpdateCustomer', ERROR_MESSAGE(), SYSDATETIME()); 

        -- Return -1 as the response code
        SET @response = -1;
    END CATCH;
    
    -- Return the response
    SELECT @response;
END;
GO
