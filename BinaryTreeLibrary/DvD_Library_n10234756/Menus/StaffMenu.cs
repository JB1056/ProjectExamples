using System;
using System.Collections.Generic;
using System.Text;
using System.Linq;

namespace DvD_Library_n10234756
{
    class StaffMenu
    {
        public static void StaffMenuControls(int menuID, int userInputOutput, MovieCollection movieTree, Movie newMovie, Member newMember) {
            if (menuID == 2) 
            {
                // check user inputs are within limit
                if (userInputOutput >= 0 && userInputOutput <= 4) 
                {
                    // return to main menu
                    if (userInputOutput == 0) 
                    { 
                        LibraryMenus.GenerateMainMenu();

                    }

                    // add new movie
                    else if (userInputOutput == 1) 
                    {
                        string movieTitle = HelperFunctions.InputNotEmpty("the", "movie title"); 
                        int movieCopies;

                        // check if the movies exists within the binary tree
                        if (movieTree.FindNodeID(movieTitle)) 
                        {

                            // acquire number of copies to be added
                            string movieCopiesTemp = HelperFunctions.InputNotEmpty("the", "number of copies you would like to add");

                            // checks that input is both greater than 0 and is an integer
                            while (!int.TryParse(movieCopiesTemp, out movieCopies) || movieCopies <= 0) 
                            {
                                Console.Write("Please enter a positive numerical value: ");
                                movieCopiesTemp = Console.ReadLine();
                            }

                            Console.WriteLine("Added {0} new copies of {1}\n", movieCopies, movieTitle);

                            // updates number of copies of movies
                            movieTree.ReturnNode(movieTitle).changeMovieCopies(movieCopies);
                        } 
                        
                        // add a new movie
                        else {
                            // user inputs for starring actor(s) and director(s)
                            string movieStarring = HelperFunctions.InputNotEmpty("the", "starring actor(s)");
                            string movieDirector = HelperFunctions.InputNotEmpty("the", "director(s)"); 

                            // generates genre menu and validates if user input is acceptable 
                            LibraryMenus.GenerateGenreMenu();
                            string movieGenre = Console.ReadLine();

                            while (true) 
                            {
                                int.TryParse(movieGenre, out int ID);
                                if (ID >= 1 && ID <= LibraryMenus.GenreArray().Length) 
                                {
                                    movieGenre = LibraryMenus.GetGenre(ID - 1);
                                    break;
                                } 

                                else 
                                {
                                    Console.Write("Please enter a listed value: ");
                                    movieGenre = Console.ReadLine();
                                }
                            }

                            // generates classification menu and validates user input is acceptable 
                            LibraryMenus.GenerateClassificationMenu();
                            string movieClassification = Console.ReadLine();

                            while (true) 
                            {
                                int.TryParse(movieClassification, out int ID);
                                if (ID >= 1 && ID <= LibraryMenus.ClassificationArray().Length) {
                                    movieClassification = LibraryMenus.GetClassification(ID - 1);
                                    break;
                                } 
                                
                                else 
                                {
                                    Console.Write("Please enter a listed value: ");
                                    movieClassification = Console.ReadLine();
                                }
                            }

                            // user inputs for movie duration, date and number of copies
                            string movieDuration = HelperFunctions.InputNotEmpty("the", "duration (minutes)") + " minutes"; 
                            string movieDate = HelperFunctions.InputNotEmpty("the", "release date (year)"); 
                            string movieCopiesTemp = HelperFunctions.InputNotEmpty("the", "number of copies available"); 

                            // ensures that the number of copies a user is trying to add is 1 or more
                            while (!int.TryParse(movieCopiesTemp, out movieCopies) || movieCopies <= 0) 
                            {
                                Console.Write("Please enter a numerical value above 0: ");
                                movieCopiesTemp = Console.ReadLine();
                            }

                            // Assign the objects based on collected user inputs
                            newMovie = new Movie(movieTitle, movieStarring,
                                movieDirector, movieDuration, movieGenre,
                                movieClassification, movieDate, movieCopies);

                            // Add created movie to BST
                            movieTree.Add(newMovie);
                        }

                        // re-open staff menu
                        LibraryMenus.GenerateStaffMenu();

                    } 
                    
                    // remove a movie
                    else if (userInputOutput == 2) 
                    { 
                        string movieTitle = HelperFunctions.InputNotEmpty("movie", "title");

                        // check if the movie exists, perform appropriate action
                        if (movieTree.FindNodeID(movieTitle)) 
                        {
                            movieTree.DeleteNode(movieTree.ReturnNode(movieTitle));
                            Console.WriteLine("{0} was deleted", movieTitle);
                        } 
                        
                        else 
                        {
                            Console.WriteLine("{0} does not exist", movieTitle);
                        }

                        // re-open staff menu
                        LibraryMenus.GenerateStaffMenu();
                    } 
                    
                    // register a new member
                    else if (userInputOutput == 3) 
                    { 
                        // get first and last name of user
                        string firstName = HelperFunctions.InputNotEmpty("members", "first name");
                        string lastName = HelperFunctions.InputNotEmpty("members", "last name");

                        // check if user is already registered
                        if (MemberCollection.UserExists(lastName + firstName)) 
                        {
                            Console.WriteLine(firstName + " " + lastName + " has already registered");
                        } 
                        
                        else 
                        {
                            // get remainder of required user input; address, phone number and password
                            string address = HelperFunctions.InputNotEmpty("members", "address");
                            string phoneNumber = HelperFunctions.InputNotEmpty("members", "phone number");
                            string password = HelperFunctions.InputNotEmpty("members", "password (4 digits)");

                            // ensure entered password is 4 numerical digits long
                            while (password.Length != 4 || !int.TryParse(password, out int passwordTrigger)) 
                            {
                                Console.Write("Please enter a password of 4 digits: ");
                                password = Console.ReadLine();
                            }

                            // create member and set password
                            newMember = new Member(firstName, lastName, address, phoneNumber);
                            newMember.setCredentials(password);

                            // Add member to member array
                            MemberCollection.addMember(newMember);

                            // Write confirmation to console
                            Console.WriteLine(firstName + " " + lastName + " has successfully registered");
                        }

                        // re-open staff menu
                        LibraryMenus.GenerateStaffMenu();
                    }

                    // find a users phone number
                    else if (userInputOutput == 4) 
                    { 
                        // retrieve users first and last names
                        string firstName = HelperFunctions.InputNotEmpty("member's", "first name");
                        string lastName = HelperFunctions.InputNotEmpty("member's", "last name");

                        // check if user exists, return phone number if they do
                        if (MemberCollection.UserExists(lastName + firstName)) 
                        {
                            // Write users Phone Number
                            Console.WriteLine("{0} {1}'s phone number is: " +
                                    MemberCollection.returnMember(lastName + firstName).getPhoneNumber(), 
                                    firstName, lastName);
                        } 
                        
                        else 
                        {
                            // perform no action if no matching user found, exit
                            Console.WriteLine("User not found");
                        }

                        // re-open staff menu
                        LibraryMenus.GenerateStaffMenu();
                    }
                }

                // user input out of limit
                else 
                {
                    Console.Write("Please enter a listed value: ");
                    ControlMenu.MenuOptions(menuID);
                }
            }
        }
    }
}
