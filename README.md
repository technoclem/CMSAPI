# Customer Management System API

Welcome to the Customer Management System API. This API allows you to perform CRUD operations on customer data.

## Table of Contents

- [Endpoints](#endpoints)
- [Models](#models)
- [Database Setup](#database-setup)
- [Usage](#usage)
- [Setup](#setup)
- [Dependencies](#dependencies)

## Endpoints

### Get Customers

- **URL:** `https://cmsapi.runasp.net/api/CMSAPI`
- **Method:** `GET`
- **Description:** Retrieves all customers.
- **Response:** Returns a list of all customers in JSON format.

### Get Customer By Id

- **URL:** `https://cmsapi.runasp.net/api/CMSAPI/{id}`
- **Method:** `GET`
- **Description:** Retrieves a specific customer by their Id.
- **Parameters:**
  - `id` (integer): Id of the customer to retrieve.
- **Response:** Returns the customer object in JSON format if found, otherwise returns a 404 Not Found status.

### Add Customer

- **URL:** `https://cmsapi.runasp.net/api/CMSAPI/add`
- **Method:** `POST`
- **Description:** Adds a new customer.
- **Request Body:** Requires a JSON object representing the customer to be added.
  ```json
  {
      "Id": 0,
      "CustName": "John Doe",
      "Email": "johndoe@example.com"
  }
- **Response:** Returns 1 if successful, return 0 if the customer email exist, return -1 for error in saving

### Update Customer

- **URL:** https://cmsapi.runasp.net/api/CMSAPI/Update
- **Method:** POST
- **Description:** Updates an existing customer.
- **Request Body:** Requires a JSON object representing the updated customer.
   ```json
   {
    "Id": 1,
    "CustName": "Updated Name",
    "Email": "updated@example.com"
   }
- **Response:** Returns 1 if successful, return 0 if the customer email exist, return -1 for error in updating

### Delete Customer
- **URL:** https://cmsapi.runasp.net/api/CMSAPI/{Id}
- **Method:** DELETE
- **Description:** Deletes a customer by their Id.
- **Parameters:**
  ```
       Id (integer): Id of the customer to delete.
  ``` 
- **Response:** Returns 1 if successful, return 0 if the customer not exist, return -1 for error

## Models
### Customer Model
- Represents a customer entity with the following properties:
- **Id (integer):** Unique identifier for the customer.
- **CustName (string, required):** Customer's name (max length: 100).
- **Email (string, required):** Customer's email address (max length: 100, must be a valid email format)      

## Database Setup
### SQL Server Setup
- Ensure your SQL Server instance is set up with the following database and objects:
```sql
USE [CustomerDB]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 13/07/2024 10:04:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	  NOT NULL,
	  NOT NULL,
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
	  NOT NULL,
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
    SELECT Id, CustName, Email FROM Customer WHERE Id = @Id;  
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
    SELECT Id, CustName, Email FROM Customer ORDER BY Id ASC;  
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
            SET Email = @Email, CustName = @CustName
            WHERE Id = @Id;

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

}
```

## Usage
- To use the API, send HTTP requests to the specified endpoints with appropriate JSON payloads for POST requests. Ensure that the data sent complies with the model validations (e.g., maximum lengths, required fields).

## Setup
- **Environment:** Ensure your environment is set up with .NET 8.
- **Database:** Use SQL Server Management Studio or another SQL client to manage the CustomerDB database. Import the provided SQL script to set up the Customer table and stored procedures.
- **Logging:** Configure Serilog in your application to handle logging as per your requirements.

## Dependencies
- **.NET 8:** Framework for building applications.
- **Dapper:** Micro-ORM used for data access.
- **Serilog:** Logging library for .NET applications.

- The API follows a repository pattern for data access, encapsulating the database operations in a service layer. Also, logging in this API is implemented using Serilog, a flexible logging library for .NET applications. It provides structured logging capabilities and can be configured to write logs to various sinks, including files, databases, and more.
