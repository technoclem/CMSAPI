using CustomerManagementSystemAPI.Models;
using CustomerManagementSystemAPI.Services.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace CustomerManagementSystemAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CMSAPIController : ControllerBase
    {
        private ICustomerService _customerService;
        public CMSAPIController(ICustomerService customerService) 
        { 
            _customerService = customerService;
        }


        // Get Customers
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Customer>>> GetCustomers()
        {
            var customers = await _customerService.GetCustomers();
            return Ok(customers);
        }

        // Get Customers By Id
        [HttpGet("{id:int}")]
        public async Task<ActionResult<Customer>> GetCustomer(int id)
        {
            if (ModelState.IsValid)
            {
                var customer = await _customerService.GetCustomer(id);

                if (customer == null) return NotFound();
                else
                    return customer;
            }
            return BadRequest();
        }

        // Add Customer
        [HttpPost("add")]
        public async Task<ActionResult<int>> AddCustomer(Customer customer)
        {
            if (ModelState.IsValid)
            {   
                
                int response = await _customerService.AddCustomer(customer);

                return Ok(response);
            }
            return BadRequest();
        }

        // Update Customer
        [HttpPost("Update")]
        public async Task<ActionResult<int>> UpdateCustomer(Customer customer)
        {
            if (ModelState.IsValid)
            {
                int response = await _customerService.UpdateCustomer(customer);

                return Ok(response);
            }
            return BadRequest();
        }

        // Delete Customer
        [HttpDelete("{Id:int}")]
        public async Task<ActionResult<int>> DeleteCustomer(int Id)
        {
            if (ModelState.IsValid)
            {
                int response = await _customerService.DeleteCustomer(Id);

                return Ok(response);
            }
            return BadRequest();
        }

    }
}
