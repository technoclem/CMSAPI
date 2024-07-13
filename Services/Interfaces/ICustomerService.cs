using CustomerManagementSystemAPI.Models;

namespace CustomerManagementSystemAPI.Services.Interfaces
{
    public interface ICustomerService
    {
        Task<int> AddCustomer(Customer CustModel);
        Task<int> UpdateCustomer(Customer CustModel);
        Task<int> DeleteCustomer(int Id);

        Task<Customer?> GetCustomer(int Id);
        Task <IEnumerable<Customer>?> GetCustomers();

    }
}
