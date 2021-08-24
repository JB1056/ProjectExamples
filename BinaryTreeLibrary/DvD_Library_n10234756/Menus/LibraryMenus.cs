using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Text;

namespace DvD_Library_n10234756
{
    class LibraryMenus
    {
        public static string GetGenre(int index) {
            string[] genreOptions = new string[] { "Drama", "Adventure", "Family", "Action", "Sci-Fi", "Comedy", "Animated", "Thriller", "Other" };
            return genreOptions[index];
        }

        public static string[] GenreArray() {
            string[] genreOptions = { "Drama", "Adventure", "Family", "Action", "Sci-Fi", "Comedy", "Animated", "Thriller", "Other" };
            return genreOptions;
        }

        public static string GetClassification(int index) {
            string[] classificationOptions = new string[] { "General (G)", "Parental Guidance (PG)", "Mature (M15+)", "Mature Accompanied (MA15+)" };
            return classificationOptions[index];
        }

        public static string[] ClassificationArray() {
            string[] classificationOptions = { "General (G)", "Parental Guidance (PG)", "Mature (M15+)", "Mature Accompanied (MA15+)" };
            return classificationOptions;
        }

        public static void GenerateMainMenu() {
            Console.WriteLine("\nWelcome to the Community Library");
            Console.WriteLine("============Main Menu============");
            Console.WriteLine("1. Staff Login");
            Console.WriteLine("2. Member Login");
            Console.WriteLine("0. Exit");
            Console.WriteLine("=================================\n");

            Console.Write("Please make a selection (1-2 or 0 to exit): ");
            ControlMenu.MenuOptions(1);
        }

        public static void GenerateStaffMenu() {
            Console.WriteLine("\n============Staff Menu============");
            Console.WriteLine("1. Add a new movie DVD");
            Console.WriteLine("2. Remove a movie DVD");
            Console.WriteLine("3. Register a new Member");
            Console.WriteLine("4. Find a registered member's phone number");
            Console.WriteLine("0. Return to main menu");
            Console.WriteLine("=================================");

            Console.Write("Please make a selection (1-4 or 0 to return to the main menu): ");
            ControlMenu.MenuOptions(2);
        }

        public static void GenerateMemberMenu(Member loggedMember) {
            Console.WriteLine("\n===========Member Menu============");
            Console.WriteLine("1. Display all movies");
            Console.WriteLine("2. Borrow a movie DVD");
            Console.WriteLine("3. Return a movie DVD");
            Console.WriteLine("4. List current borrowed movie DVDs");
            Console.WriteLine("5. Display top 10 most popular movies");
            Console.WriteLine("0. Return to main menu");
            Console.WriteLine("==================================");

            Console.Write("Please make a selection (1-5 or 0 to return to the main menu): ");
            ControlMenu.MenuOptions(3, loggedMember);
        }

        public static void GenerateGenreMenu() {
            Console.WriteLine("\nSelect the genre:");
            for (int i = 0; i < GenreArray().Length; i++)     {
                Console.WriteLine("{0}. {1}", i + 1, GetGenre(i));
            }
            Console.Write("Make Selection (1-{0}): ", GenreArray().Length);
        }

        public static void GenerateClassificationMenu() {
            Console.WriteLine("\nSelect the classification:");
            for (int i = 0; i < ClassificationArray().Length; i++) {
                Console.WriteLine("{0}. {1}", i + 1, GetClassification(i));
            }
            Console.Write("Make Selection (1-{0}): ", ClassificationArray().Length);
        }
    }
}
