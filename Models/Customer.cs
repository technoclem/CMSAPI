using System.ComponentModel.DataAnnotations;

namespace CustomerManagementSystemAPI.Models
{
    public class Customer
    {   
        public int Id { get; set; }

        [MaxLength(100)]
        public required string CustName { get; set; }

        [DataType(DataType.EmailAddress)]
        [MaxLength(100)]
        public required string Email { get; set; }

        
    }
}
