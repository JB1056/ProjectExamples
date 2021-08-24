using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Net.Sockets;
using System.Text;

namespace DvD_Library_n10234756
{
    public class Member
    {
        private List<string> rentedMovies = new List<string>();
        private string[] CustomerCredentials { get; set; }
        private string FirstName { get; set; }
        private string LastName { get; set; }
        private string Address { get; set; }
        private string PhoneNumber { get; set; }

        public Member(string firstName, string lastName, string address, string phoneNumber) {
            FirstName = firstName;
            LastName = lastName;
            Address = address;
            PhoneNumber = phoneNumber;
        }

        // functions for getting and setting variables of member objects
        public string getPhoneNumber() {
            return PhoneNumber;
        }

        public string getName() {
            string fullName = FirstName + " " + LastName;
            return fullName;
        }
        
        public string getAddress() {
            return Address;
        }

        public List<string> getRentedMovies() {
            return rentedMovies;
        }

        public string[] getCustomerCredentials() {
            return CustomerCredentials;
        }

        public void setCredentials(string password) {
            CustomerCredentials = new string[] { LastName + FirstName, password };
        }
    }
}
