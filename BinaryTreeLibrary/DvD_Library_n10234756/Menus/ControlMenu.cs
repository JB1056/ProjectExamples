using System;
using System.Dynamic;
using System.Linq;

namespace DvD_Library_n10234756
{
    class ControlMenu 
    {
        // initiate Binary Tree and objects
        private static MovieCollection movieTree = new MovieCollection();
        private static Movie newMovie = null;
        private static Member newMember = null;

        public static void MenuOptions(int menuID) {
            MenuOptions(menuID, null);
        }

        // definition to create default movie and member objects
        public static void createDefaultObjects() {
                movieTree.assignDefaultMovies(movieTree, DefaultObjects.defaultMovies());
                DefaultObjects.assignDefaultMembers();
        }

        public static void MenuOptions(int menuID, Member retrievedMember) {

            // initial User Input parsed as an identifier for which menu to access
            int userInputOutput = HelperFunctions.ValidateNumberInput(Console.ReadLine());

            // Main Menu
            MainMenu.MainMenuControls(menuID, userInputOutput);

            // Staff Menu
            StaffMenu.StaffMenuControls(menuID, userInputOutput, movieTree, newMovie, newMember);

            // Member Menu
            MemberMenu.MemberMenuControls(menuID, userInputOutput, movieTree, retrievedMember);
        }
    }
}


