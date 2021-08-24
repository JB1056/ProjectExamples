using System;
using System.Collections.Generic;
using System.Text;

namespace DvD_Library_n10234756
{
    class HelperFunctions
    {
        // collects user credentials
        public static string[] Credentials(bool loginStaff) 
        {
            // creates an array with 2 null values
            string[] credentials = { null, null };
            
            // check if it is staff or members logging in
            if (loginStaff) 
            { 
                Console.Write("Enter username: "); 
            } 
            
            else 
            {
                Console.Write("Enter your username (LastnameFirstname): ");
            }

            credentials[0] = Console.ReadLine();
            Console.Write("Enter password: ");
            credentials[1] = Console.ReadLine();

            // return username and password as credentials
            return credentials;
        }

        // ensures input fields are not empty or white spaced
        public static string InputNotEmpty(string altVal, string type) 
        {
            string memberAttribute;
            do {
                Console.Write("Enter {0} {1}: ", altVal, type);
                memberAttribute = Console.ReadLine();

                // checks if input has no whitespace
                if (string.IsNullOrWhiteSpace(memberAttribute)) 
                { 
                    Console.WriteLine("Invalid input, please try again"); 
                }

            } while (string.IsNullOrWhiteSpace(memberAttribute));

            // returns user input without leading and following spaces
            return CaseFormatString(memberAttribute.Trim());
        }

        // validates/ensures that user input is an integer value
        public static int ValidateNumberInput(string userInput) 
        {
            int userInputOutput;

            // request user to input a number until they do
            while (!int.TryParse(userInput, out userInputOutput)) 
            {
                Console.Write("Please enter a listed value: ");
                userInput = Console.ReadLine();
            }

            return userInputOutput;
        }

        // Formats words to be all lowercase, then uppercase first letter of each word
        static string CaseFormatString(string value) {
            // copies all characters to an array
            char[] charArray = value.ToCharArray();

            // turn all characters lower case
            for (int i = 1; i < charArray.Length; i++) 
            { 
                charArray[i] = char.ToLower(charArray[i]); 
            }

            // checks there is atleast 1 letter, capitalise very first letter
            if (charArray.Length >= 1) 
            {
                if (char.IsLower(charArray[0])) 
                {
                    charArray[0] = char.ToUpper(charArray[0]);
                }
            }

            // Scan through the letters, upper case first letter of new words (words after spaces)
            for (int i = 1; i < charArray.Length; i++) 
            {
                if (charArray[i - 1] == ' ') 
                {
                    if (char.IsLower(charArray[i])) 
                    {
                        charArray[i] = char.ToUpper(charArray[i]);
                    }
                }
            }

            // return the string now formatted
            return new string(charArray);
        }
    }
}
