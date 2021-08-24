using System;
using System.Collections.Generic;
using System.Text;

namespace DvD_Library_n10234756
{
    public class Movie
    {
        private string Title { get; set; }
        private string Starring { get; set; }
        private string Director { get; set; }
        private string Duration { get; set; }
        private string Genre { get; set; }
        private string Classification { get; set; }
        private string ReleaseDate { get; set; }
        private int MovieCopies { get; set; }
        private int CopiesAvailable { get; set; }
        private int CopiesRented { get; set; }

        public Movie(string title, string starring, string director, string duration, string genre, string classification, string releaseDate, int movieCopies) {
            Title = title;
            Starring = starring;
            Director = director;
            Duration = duration;
            Genre = genre;
            Classification = classification;
            ReleaseDate = releaseDate;
            MovieCopies = movieCopies;
            CopiesAvailable = movieCopies;
            CopiesRented = 0;
        }

        // movie constructor top 10
        public Movie(string title, int copiesRented) {
            Title = title;
            CopiesRented = copiesRented;
        }

        // functions for getting and setting variables of movie objects
        public string getTitle() {
            return Title;
        }

        public string getStarring() {
            return Starring;
        }

        public string getDirector() {
            return Director;
        }

        public string getDuration() {
            return Duration;
        }

        public string getGenre() {
            return Genre;
        }

        public string getClassification() {
            return Classification;
        }

        public string getReleaseDate() {
            return ReleaseDate;
        }

        public int getMovieCopies() {
            return MovieCopies;
        }

        public int getCopiesAvailable() {
            return CopiesAvailable;
        }

        public int getTotalRented() {
            return CopiesRented;
        }
        public void setInitialRent(int initialRent) {
            CopiesRented = initialRent;
        }
        public void changeMovieCopies(int addedCopies) {
            MovieCopies += addedCopies;
            CopiesAvailable += addedCopies;
        }
        
        public void rentMovie() {
            CopiesAvailable--;
            CopiesRented++;
        }

        public void returnMovie() {
            CopiesAvailable++;
        }
    }
}
