using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;

namespace DvD_Library_n10234756
{
    class MemberMenu
    {
        public static void MemberMenuControls(int menuID, int userInputOutput, MovieCollection movieTree, Member retrievedMember) {
            if (menuID == 3) {
                // check user inputs are within limit
                if (userInputOutput >= 0 && userInputOutput <= 5) 
                {
                    
                    // return to main menu
                    if (userInputOutput == 0) 
                    { 
                        LibraryMenus.GenerateMainMenu();
                    }

                    // display all movies
                    else if (userInputOutput == 1) { 
                        movieTree.displayAllMovies(movieTree);
                    }

                    // borrow a movie
                    else if (userInputOutput == 2) {
                        string movieTitle = HelperFunctions.InputNotEmpty("movie", "title");
                        MemberCollection.rentMovieToMember(movieTree, retrievedMember, movieTitle);
                    }

                    // return a movie
                    else if (userInputOutput == 3) { 
                        string movieTitle = HelperFunctions.InputNotEmpty("movie", "title");
                        MemberCollection.returnRentedMovie(movieTree, retrievedMember, movieTitle);
                    }

                    // list borrowed movies
                    else if (userInputOutput == 4) { 
                        if (retrievedMember.getRentedMovies().Count() == 0) { Console.WriteLine("You have borrowed nothing"); } 
                        else 
                        {
                            Console.WriteLine("You are currently borrowing:");
                            foreach (string movie in retrievedMember.getRentedMovies()) 
                            {
                                Console.WriteLine(movie);
                            }
                        }
                    }

                    // display top 10 movies
                    else if (userInputOutput == 5) 
                    { 
                        movieTree.displayTop10Movies(movieTree.collectTop10Movies(movieTree.root));
                    }

                    // return to member menu
                    LibraryMenus.GenerateMemberMenu(retrievedMember);
                }
                
                // user input was out of limit
                else 
                {
                    Console.Write("Please enter a listed value: ");
                    ControlMenu.MenuOptions(menuID);
                }
            }
        }
    }
}
