using CustomerManagementSystemAPI.Models;
using CustomerManagementSystemAPI.Services.Interfaces;
using Microsoft.Data.SqlClient;
using System.Data;
using Dapper;
namespace CustomerManagementSystemAPI.Services
{
    public class CustomerService : ICustomerService 
    {
        private readonly IConfiguration _config;
        private readonly ILogger<CustomerService> _logger;
        public CustomerService(IConfiguration config, ILogger<CustomerService> logger) 
        { 
            _config = config;
            _logger = logger;
        }
        public async Task<int> AddCustomer(Customer CustModel)
        {
            try
            {
                using (IDbConnection db = new SqlConnection(_config.GetConnectionString("CMSConnection")))
                {
                    return await db.QueryFirstOrDefaultAsync<int>("AddCustomer", new
                    {
                        CustName = CustModel.CustName.Trim(),
                        Email = CustModel.Email.Trim()                        
                    });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"An error occurred while Adding customer. Email: {CustModel.Email.Trim()}");

            }
            return -1;
        }

        public async Task<int> UpdateCustomer(Customer CustModel)
        {
            try
            {
                using (IDbConnection db = new SqlConnection(_config.GetConnectionString("CMSConnection")))
                {
                    return await db.QueryFirstOrDefaultAsync<int>("UpdateCustomer", new
                    {   Id=CustModel.Id,
                        CustName = CustModel.CustName.Trim(),
                        Email = CustModel.Email.Trim()
                    });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"An error occurred while updating customer. Email: {CustModel.Email.Trim()}, Id: {CustModel.Id}");

            }
            return -1;
        }

        public async Task<int> DeleteCustomer(int Id)
        {
            try
            {
                using (IDbConnection db = new SqlConnection(_config.GetConnectionString("CMSConnection")))
                {
                    return await db.QueryFirstOrDefaultAsync<int>("DeleteCustomer", new
                    {
                        Id = Id
                    });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"An error occurred while Removing Customer Account. Id: {Id}");

            }
            return -1;
        }

        public async Task<Customer?> GetCustomer(int Id)
        {
            try
            {
                using (IDbConnection db = new SqlConnection(_config.GetConnectionString("CMSConnection")))
                {
                    return await db.QueryFirstOrDefaultAsync<Customer>("GetCustomerById", new { Id = Id });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"An error occurred while Retrieving the Customer Account. Id: {Id}");
                return null;
            }
           
        }
        public async Task<IEnumerable<Customer>?> GetCustomers()
        {
            try
            {
                using (IDbConnection db = new SqlConnection(_config.GetConnectionString("CMSConnection")))
                {
                    return await db.QueryAsync<Customer>("GetCustomers");
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"An error occurred while Removing Customer Account.");
                return null;
            }

        }
    }
}
