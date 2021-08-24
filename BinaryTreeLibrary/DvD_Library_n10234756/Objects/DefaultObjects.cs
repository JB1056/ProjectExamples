using System;
using System.Collections.Generic;
using System.Text;

namespace DvD_Library_n10234756
{
    class DefaultObjects
    {
        // create and assign 15 default movies
        public static Movie[] defaultMovies() {
            // Japanese Animation
            Movie defaultMovie1 = new Movie("My Neighbor Totoro", "Shigesato Itoi, Noriko Hidaka, Chika Sakamoto",           
                "Hayao Miyazaki", "88", "Animated", "Parental Guidance (PG)", "1988", 3);                                   
            Movie defaultMovie2 = new Movie("Spirited Away", "Miyu Irino, Yasuko Sawaguchi",
                "Hayao Miyazaki", "125", "Animated", "Parental Guidance (PG)", "2001", 3);
            Movie defaultMovie3 = new Movie("Your Name", "Mone Kamishiraishi, Ryunosuke Kamiki",
                "Makoto Shinkai", "118", "Animated", "Mature (M15+)", "2016", 2);

            // Rush Hour Franschise
            Movie defaultMovie4 = new Movie("Rush Hour", "Jackie Chan, Chris Tucker",
                "Brett Ratner", "98", "Action", "Mature (M15+)", "1998", 4);
            Movie defaultMovie5 = new Movie("Rush Hour 2", "Jackie Chan, Chris Tucker",
                "Brett Ratner", "94", "Action", "Mature (M15+)", "2001", 4);
            Movie defaultMovie6 = new Movie("Rush Hour 3", "Jackie Chan, Chris Tucker",
                "Brett Ratner", "91", "Action", "Mature (M15+)", "2007", 4);

            // Terminator Franchise
            Movie defaultMovie7 = new Movie("The Terminator", "Arnold Schwarzenegger, Linda Hamilton",
                    "James Camron", "108", "Action", "Mature (M15+)", "1984", 2);
            Movie defaultMovie8 = new Movie("Terminator 2: Judgement Day", "Arnold Schwarzenegger, Linda Hamilton",
                    "James Cameron", "156", "Action", "Mature (M15+)", "1991", 2);
            Movie defaultMovie9 = new Movie("Terminator 3: Rise Of The Machines", "Arnold Schwarzenegger, Claire Danes",
                "Jonathan Mostow", "109", "Action", "Mature (M15+)", "2003", 3);
            Movie defaultMovie10 = new Movie("Terminator Salvation", "Arnold Schwarzenegger, Bryce Dallas Howard",
                "Joseph McGinty", "118", "Action", "Mature (M15+)", "2009", 1);
            Movie defaultMovie11 = new Movie("Terminator Genisys", "Arnold Schwarzenegger, Emilia Clarke",
                    "James Cameron", "126", "Action", "Mature (M15+)", "1984", 4);
            Movie defaultMovie12 = new Movie("Terminator: Dark Fate", "Arnold Schwarzenegger,  Linda Hamilton",
                "Hayao Miyazaki", "128", "Action", "Mature (M15+)", "2019", 2);
            

            // Johnny English Franchise
            Movie defaultMovie13 = new Movie("Johnny English", "Rowan Atkinson",
                    "Peter Howitt", "89", "Comedy", "Parental Guidance (PG)", "2003", 1);
            Movie defaultMovie14 = new Movie("Johnny English Reborn", "Rowan Atkinson",
                    "Oliver Parker", "102", "Comedy", "Parental Guidance (PG)", "2011", 4);
            Movie defaultMovie15 = new Movie("Johnny English Strikes Again", "Rowan Atkinson",
                "David Kerr", "88", "Comedy", "Parental Guidance (PG)", "2018", 2);

            // Movie array
            Movie[] defaultMovieArray = { defaultMovie1, defaultMovie2, defaultMovie3, defaultMovie4,
                                          defaultMovie5, defaultMovie6, defaultMovie7, defaultMovie8,
                                          defaultMovie9, defaultMovie10, defaultMovie11, defaultMovie12,
                                          defaultMovie13, defaultMovie14, defaultMovie15 };

            return defaultMovieArray;
        }

        public static void assignDefaultMembers() {
            // create member and set password
            Member newMember1 = new Member("Mike", "Chen", "1 Alice St, Brisbane", "12345678");
            Member newMember2 = new Member("David", "Zhang", "2 George St, Brisbane", "87654321");

            // set default password "1111"
            newMember1.setCredentials("1111");
            newMember2.setCredentials("1111");

            // Add members to member array
            MemberCollection.addMember(newMember1);
            MemberCollection.addMember(newMember2);
        }
    }
}
