using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Text;
using System.Linq;
using System.Globalization;

namespace DvD_Library_n10234756
{
    // building nodes of Binary Tree
    public class Node
    {
        public Movie item;
        public Node left;
        public Node right;

        public Node(Movie item) {
            this.item = item;
            left = null;
            right = null;
        }

        public Movie Item {
            get { return item; }
            set { item = value; }
        }
    }

    // main Binary Tree movie collection
    public class MovieCollection
    {
        // initiates an array to store specific node values for user prompts
        private Movie[] movieStore = null;
        private Movie[] movieTop10 = { };
        public Node root;

        // Constructors for making a MovieCollection
        public MovieCollection() {
            root = null;
        }
        public MovieCollection(Movie initialValue) {
            root = new Node(initialValue);
        }



        // add individual nodes
        public void Add(Movie item) {
                Add(item, root);
        }
        private void Add(Movie item, Node node) {
            
            // check if tree is empty
            if (root == null) 
            {
                root = new Node(item);
                return;
            }

            // check value
            bool addComplete = false;

            // creates a node to handle
            Node currentNode = node;

            // begin traversing tree
            do {
                // check if value fits left
                if (string.Compare(item.getTitle(), currentNode.Item.getTitle()) == -1) 
                    {
                    if (currentNode.left == null) 
                    {
                        currentNode.left = new Node(item);
                        addComplete = true;
                    } 
                    
                    else 
                    {
                        currentNode = currentNode.left;
                    }
                }

                // check if value fits right
                else if (string.Compare(item.getTitle(), currentNode.Item.getTitle()) == 1) 
                {
                    if (currentNode.right == null) 
                    {
                        currentNode.right = new Node(item);
                        addComplete = true;
                    } 
                    
                    else 
                    {
                        currentNode = currentNode.right;
                    }
                }
            } while (!addComplete); // end loop, node added to tree
        }


        // attempts to find if the ID (Title) of a specific node exists, returns true of false
        public bool FindNodeID(string item) {
            return FindNodeID(item, root);
        }

        private bool FindNodeID(string item, Node node) {
            // check if node is not empty
            if (node != null) 
            {
                if (string.Compare(item, node.Item.getTitle()) == 0) { return true; } 
                else if (string.Compare(item, node.Item.getTitle()) < 0) { return FindNodeID(item, node.left); } 
                else { return FindNodeID(item, node.right); }
            } 
            
            else { return false; }
        }

        

        // returns the movie for interaction
        public Movie ReturnNode(string item) {
            return ReturnNode(item, root);
        }

        private Movie ReturnNode(string item, Node node) {
            // check if node is not empty
            if (node != null) 
            {
                if (string.Compare(item, node.Item.getTitle()) == 0) { return node.Item; } 
                else if (string.Compare(item, node.Item.getTitle()) < 0) { return ReturnNode(item, node.left); } 
                else { return ReturnNode(item, node.right); }
            } 
            
            else { return null; }
        }

        

        // remove a node from Binary Tree
        public void DeleteNode(Movie item) {
            // search for item and its parent
            Node pointer = root; // search reference
            Node parent = null; // parent of pointer

            // find node to be deleted
            while ((pointer != null) && (string.Compare(item.getTitle(), pointer.Item.getTitle()) != 0)) 
            {
                parent = pointer;
                if (string.Compare(item.getTitle(),pointer.Item.getTitle()) == -1) { pointer = pointer.left; } 
                else { pointer = pointer.right; }
            }

            // check if node is exists
            if (pointer != null) 
            {
                // check if node is parent to both left and right nodes (2 children)
                if ((pointer.left != null) && (pointer.right != null)) 
                {
                    // attempt to find replacement for deleted node
                    if (pointer.left.right == null) // anternate replacement value if initial replacement value is not available
                    { 
                        pointer.Item = pointer.left.Item;
                        pointer.left = pointer.left.left;
                    } 
                    
                    else // initial replacement value
                    { 
                        Node pointerParent = pointer;
                        Node pointerLeft = pointer.left;
                        
                        // find values to replace with
                        while (pointerLeft.right != null) 
                        {
                            pointerParent = pointerLeft;
                            pointerLeft = pointerLeft.right;
                        }
                        
                        // replace element
                        pointer.Item = pointerLeft.Item;
                        pointerParent.right = pointerLeft.right;
                    }
                } 
                
                // replaced deleted node if parent of single child, else simply removes leaf node
                else 
                {
                    Node alternatePointer;

                    if (pointer.left != null) { alternatePointer = pointer.left; } 
                    else { alternatePointer = pointer.right; }

                    if (pointer == root) { root = alternatePointer; } 
                    else 
                    {
                        if (pointer == parent.left) { parent.left = alternatePointer; } 
                        else { parent.right = alternatePointer; }
                    }
                }

            }
        }

        // add default movie objects to the movie collection each with a random value for number of times rented
        // populate movie list
        public void assignDefaultMovies(MovieCollection targetCollection, Movie[] defaultMovieArray) {
            // initiate a random 
            Random rnd = new Random();
            for (int i = 0; i < defaultMovieArray.Length; i++) 
            {
                // create next random number less than 25
                int num = rnd.Next(25);

                // assigns number of times rented based on random value
                defaultMovieArray[i].setInitialRent(num);

                // Add movies to MemberCollection binary tree
                targetCollection.Add(defaultMovieArray[i]);
            }
        }


        // Template for displaying all movie information
        public void displayAllMovies(MovieCollection BinaryMovieCollection) {
            for (int i = 0; i < BinaryMovieCollection.displayAllMovies().Length; i++) 
            {
                Console.Write("Title: " + BinaryMovieCollection.displayAllMovies()[i].getTitle());
                Console.Write("Starring: " + BinaryMovieCollection.displayAllMovies()[i].getStarring());
                Console.Write("Director: " + BinaryMovieCollection.displayAllMovies()[i].getDirector());
                Console.Write("Genre: " + BinaryMovieCollection.displayAllMovies()[i].getGenre());
                Console.Write("Classification: " + BinaryMovieCollection.displayAllMovies()[i].getClassification());
                Console.Write("Duration: " + BinaryMovieCollection.displayAllMovies()[i].getDuration());
                Console.Write("Release Date: " + BinaryMovieCollection.displayAllMovies()[i].getReleaseDate());
                Console.Write("Copies Available: " + BinaryMovieCollection.displayAllMovies()[i].getCopiesAvailable());
                Console.Write("Times Rented: " + BinaryMovieCollection.displayAllMovies()[i].getTotalRented());
            }
        }

        // constructors for retrieving information to display all movies, used by previous template
        private Movie[] displayAllMovies() {
            movieStore = new Movie[] { };
            displayAllMovies(root);
            Console.WriteLine();
            return movieStore;
        }
        private void displayAllMovies(Node root) {
            if (root != null) {
                displayAllMovies(root.left);
                movieStore = movieStore.Concat(new Movie[] { root.Item }).ToArray();
                displayAllMovies(root.right);
            }
        }

        // collects movies to be used in top 10 function
        public Movie[] collectTop10Movies(Node root) {
            if (root != null) {
                collectTop10Movies(root.left);
                collectTop10Movies(root.right);
                Array.Resize(ref movieTop10, movieTop10.Length + 1);
                movieTop10[movieTop10.Length - 1] = new Movie (root.Item.getTitle(), root.Item.getTotalRented()); 
            }
            return movieTop10;
        }

        // displays top 10 movies
        public void displayTop10Movies(Movie[] top10) {
            Movie temp;

            // itterate over entire array, sorting based on largest number of times rented
            for (int i = 0; i < top10.Length; i++) 
            {
                for (int j = i + 1; j < top10.Length; j++) 
                {
                    // checks if next value in array is larger, swaps if is
                    if (top10[i].getTotalRented() < top10[j].getTotalRented()) 
                    {
                        temp = top10[i];
                        top10[i] = top10[j];
                        top10[j] = temp;
                    }
                }
            }

            // print up to the first 10 movies based on the number of times rented, descending 
            for (int i = 0; i < top10.Length && i < 10; i++) 
            {
                Console.WriteLine("{0} borrowed {1} times", top10[i].getTitle(), top10[i].getTotalRented());
            }

            // resets used array to prevent values later duplicating
            movieTop10 = new Movie[] { };
        }
        
        // clears tree
        public void Clear() {
            root = null;
        } 

    }
}
