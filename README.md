# Customer Management System API

Welcome to the Customer Management System API. This API allows you to perform CRUD operations on customer data.

## Table of Contents

- [Endpoints](#endpoints)
- [Models](#models)
- [Services](#services)
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
