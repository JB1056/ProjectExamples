using System;
using System.Collections.Generic;
using System.Text;

namespace DvD_Library_n10234756
{
    class MainMenu
    {
        public static void MainMenuControls(int menuID, int userInputOutput) {
            if (menuID == 1) {
                // check user inputs are within limit
                if (userInputOutput >= 0 && userInputOutput <= 2) {
                    // Exit
                    if (userInputOutput == 0) {
                        // Thank user for using library, close library
                        Console.WriteLine("Thank you for visiting the Community Library\nThe Library has now closed");
                        // terminate program
                        Environment.Exit(0);
                    }

                    // Login to staff menu
                    else if (userInputOutput == 1) {
                        // get user input as credentials, staff param set to true
                        string[] credentials = HelperFunctions.Credentials(true);

                        // check username and password are correct, open staff menu if matches
                        if (credentials[0] == "staff" && credentials[1] == "today123") {
                            Console.WriteLine();
                            LibraryMenus.GenerateStaffMenu();
                        }

                        // login failed, return to main menu
                        else {
                            Console.WriteLine("Incorrect Credentials");
                            LibraryMenus.GenerateMainMenu();
                        }

                    }

                    // Login to member menu
                    else if (userInputOutput == 2) {
                        // get user input as credentials, staff param set to false
                        string[] credentials = HelperFunctions.Credentials(false);

                        // check if user exists
                        if (MemberCollection.UserExists(credentials[0])) {
                            // if user exists, check credentials match and login
                            if (credentials[0] == MemberCollection.returnMember(credentials[0]).getCustomerCredentials()[0] &&
                                    credentials[1] == MemberCollection.returnMember(credentials[0]).getCustomerCredentials()[1]) {
                                LibraryMenus.GenerateMemberMenu(MemberCollection.returnMember(credentials[0]));
                                Console.WriteLine();
                            }

                            // login failed, return to main menu
                            else {
                                Console.WriteLine("Incorrect Credentials");
                                LibraryMenus.GenerateMainMenu();
                            }
                        }

                        // user doesnt exist, login failed, return to main menu. 
                        // Use same message as wrong password for security's sake
                        // even though the security of this log in system in general
                        // is extremely questionable, every little bit counts :)
                        else {
                            Console.WriteLine("Incorrect Credentials");
                            LibraryMenus.GenerateMainMenu();
                        }
                    }
                }
                // user input out of limit
                else {
                    Console.Write("Please enter a listed value: ");
                    ControlMenu.MenuOptions(menuID);
                }
            }
        }
    }
}
