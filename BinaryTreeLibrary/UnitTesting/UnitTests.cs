using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using DvD_Library_n10234756;
using System.Linq;

namespace UnitTesting
{
    [TestClass]
    public class LibraryUnitTests {
        Movie testMovie1 = new Movie("Movie 1", "Actor 1, Actress 1", 
            "Director 1", "97", "Action", "Mature (M15+", "2019", 4);
        Movie testMovie2 = new Movie("Movie 2", "Actor 1, Actor 2",
            "Director 1", "37", "Animated", "Parental Guidance (PG)", "2019", 8);
        Movie testMovie3 = new Movie("Movie 3", "Actress 1, Actress 2",
            "Director 5", "109", "Action", "General (G)", "2019", 1);
        Movie testMovie4 = new Movie("Movie 4", "Jackie Chan, Chris Tucker",
            "Brett Ratner", "98", "Action", "Mature (M15+)", "1998", 2);
        
        [TestMethod]
        public void AddBSTNode() {
            MovieCollection TestTree = new MovieCollection();
            TestTree.Add(testMovie1);
            Assert.IsNotNull(TestTree);
        }

        [TestMethod]
        public void DeleteBSTNode() {
            MovieCollection TestTree = new MovieCollection();
            TestTree.Add(testMovie1);
            TestTree.DeleteNode(testMovie1);
            Assert.IsNull(TestTree.root);
        }

        [TestMethod]
        public void ClearAllBSTNodes() {
            MovieCollection TestTree = new MovieCollection();
            TestTree.Add(testMovie1);
            TestTree.Add(testMovie2);
            TestTree.Add(testMovie3);
            TestTree.Add(testMovie4);
            TestTree.Clear();
            Assert.AreEqual(TestTree.root, null);
        }

        [TestMethod]
        public void CheckMemberData() {
            Member newMember1 = new Member("Mike", "Chen", "1 Alice St, Brisbane", "12345678");
            newMember1.setCredentials("1111");

            Assert.AreEqual(newMember1.getAddress(), "1 Alice St, Brisbane");
            Assert.AreEqual(newMember1.getName(), "Mike Chen");
            Assert.AreEqual(newMember1.getPhoneNumber(), "12345678");
            Assert.AreEqual(newMember1.getCustomerCredentials()[0], "ChenMike");
            Assert.AreEqual(newMember1.getRentedMovies().Count(), 0);
        }
        [TestMethod]
        public void CheckMovieData() {
            MovieCollection TestTree = new MovieCollection();
            TestTree.Add(testMovie1);
            TestTree.Add(testMovie2);
            TestTree.Add(testMovie3);

            Assert.AreEqual(testMovie1.getCopiesAvailable(), 4);
            Assert.AreEqual(testMovie1.getTitle(), "Movie 1");
            Assert.AreEqual(testMovie3.getTotalRented(), 0);
            Assert.AreEqual(testMovie2.getGenre(), "Animated");
            Assert.AreEqual(testMovie2.getClassification(), "Parental Guidance (PG)");
            Assert.AreEqual(testMovie1.getDuration(), "97");
            Assert.AreNotEqual(testMovie3.getGenre(), "Animated");
        }


        [TestMethod]
        public void returnNode() {
            MovieCollection TestTree = new MovieCollection();
            TestTree.Add(testMovie1);

            Assert.IsNotNull(TestTree.ReturnNode("Movie 1"));
            Assert.IsTrue(TestTree.FindNodeID("Movie 1"));
            Assert.IsFalse(TestTree.FindNodeID("Movie 2"));

        }

        [TestMethod]
        public void ShowAllMovies() {
            MovieCollection TestTree = new MovieCollection();
            TestTree.Add(testMovie1);
            TestTree.Add(testMovie2);
            TestTree.Add(testMovie3);
            TestTree.Add(testMovie4);

            TestTree.displayAllMovies(TestTree);

        }

        [TestMethod]
        public void testRent() {
            MovieCollection TestTree = new MovieCollection();
            TestTree.Add(testMovie1);

            int preRent = TestTree.ReturnNode("Movie 1").getTotalRented();
            TestTree.ReturnNode("Movie 1").rentMovie();
            int postRent1 = TestTree.ReturnNode("Movie 1").getTotalRented();
            TestTree.ReturnNode("Movie 1").rentMovie();
            Assert.AreNotEqual(preRent, postRent1);
            Assert.AreEqual(TestTree.ReturnNode("Movie 1").getTotalRented(), postRent1 + 1);
        }

        [TestMethod]
        public void ShowTop10() {
            MovieCollection TestTree = new MovieCollection();
            TestTree.Add(testMovie1);
            TestTree.Add(testMovie2);
            TestTree.Add(testMovie3);
            TestTree.Add(testMovie4);

            testMovie2.rentMovie();

            testMovie3.rentMovie();
            testMovie3.rentMovie();

            TestTree.displayTop10Movies(TestTree.collectTop10Movies(TestTree.root));
            Assert.IsNotNull(TestTree.collectTop10Movies(TestTree.root));
            Assert.AreEqual(TestTree.ReturnNode(testMovie3.getTitle()).getTotalRented(), TestTree.collectTop10Movies(TestTree.root)[1].getTotalRented());
            Assert.AreEqual(TestTree.ReturnNode(testMovie2.getTitle()).getTotalRented(), TestTree.collectTop10Movies(TestTree.root)[2].getTotalRented());
            Assert.AreNotEqual(TestTree.ReturnNode(testMovie1.getTitle()).getTotalRented(), TestTree.collectTop10Movies(TestTree.root)[2].getTotalRented());
            Assert.AreEqual(0, TestTree.collectTop10Movies(TestTree.root)[0].getTotalRented());
        }

        
    }
}