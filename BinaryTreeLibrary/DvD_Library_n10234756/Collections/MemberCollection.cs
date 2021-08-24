using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DvD_Library_n10234756
{
    class MemberCollection
    {
        public static Member[] MemberArray = new Member[] { };

        // checks if user exists
        public static bool UserExists(string userID) {
            
            for (int i = 0; i < MemberArray.Length; i++) 
            {
                if (MemberArray[i].getCustomerCredentials()[0] == userID) 
                {
                    return true;
                }
            }
            return false;
        }

        // returns user object
        public static Member returnMember(string userID) {

            for (int i = 0; i < MemberArray.Length; i++) 
            {
                if (MemberArray[i].getCustomerCredentials()[0] == userID) 
                {
                    return MemberArray[i];
                }
            }
            return null;
        }

        // adds a user to the member array
        public static void addMember(Member newMember) {
            MemberArray = MemberArray.Concat(new Member[] { newMember }).ToArray();
        }

        // assigns a copy of a movie to logged in user
        public static void rentMovieToMember(MovieCollection moviesAvailable, Member focusedMember, string movieTitle) {
            // check if movie exists
            if (moviesAvailable.FindNodeID(movieTitle)) 
            {
                // check if atleast 1 copy of the movie is available to borrow
                if (moviesAvailable.ReturnNode(movieTitle).getCopiesAvailable() >= 1) 
                {
                    // check user does not already have 10 movies borrowed
                    if (focusedMember.getRentedMovies().Count() == 10) 
                    {
                        Console.WriteLine("You have borrowed the maximum limit, please return a movie first"); 
                    }

                    // check if user has already borrowed movie
                    else if (focusedMember.getRentedMovies().Contains(movieTitle)) 
                    {
                        Console.WriteLine("You have already borrowed {0}", movieTitle);
                    }

                    // borrow a copy of movie
                    else 
                    {
                        focusedMember.getRentedMovies().Add(movieTitle);
                        moviesAvailable.ReturnNode(movieTitle).rentMovie();
                        Console.WriteLine("You borrowed {0}", movieTitle);
                    }
                } 
                
                // no copies of the movie are available to borrow
                else 
                {
                    Console.WriteLine("{0} does not have any available copies to borrow", movieTitle);
                }
            } 
            
            // movie does not exist, cannot borrow
            else {
                Console.WriteLine("{0} does not exist", movieTitle);
            }

            // return to member menu, ensuring user remains logged in the same account
            LibraryMenus.GenerateMemberMenu(returnMember(focusedMember.getCustomerCredentials()[0]));
        }

        public static void returnRentedMovie(MovieCollection moviesAvailable, Member focusedMember, string movieTitle) {
            // check if movie exists
            if (moviesAvailable.FindNodeID(movieTitle)) 
            {
                // check if user has movie borrowed
                if (focusedMember.getRentedMovies().Contains(movieTitle)) 
                {
                    focusedMember.getRentedMovies().Remove(movieTitle);
                    moviesAvailable.ReturnNode(movieTitle).returnMovie();
                    Console.WriteLine("You have returned {0}", movieTitle);
                } 
                
                // user has not borrowed the movie
                else 
                {
                    Console.WriteLine("You do not have a copy of {0} to return", movieTitle);
                }
            }

            // movie does not exist, cannot return, user keeps deleted movies
            else 
            {
                Console.WriteLine("{0} does not exist", movieTitle);
            }

            // return to member menu, ensuring user remains logged in the same account
            LibraryMenus.GenerateMemberMenu(returnMember(focusedMember.getCustomerCredentials()[0]));
        }
    }
}
