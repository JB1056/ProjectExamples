using System;

namespace DvD_Library_n10234756
{
    class Program {
        static void Main(string[] args) {
            // comment out below line to prevent default objects being created
            ControlMenu.createDefaultObjects(); 

            // Innitiate First Menu, begin program
            LibraryMenus.GenerateMainMenu();
        }
    }
}
