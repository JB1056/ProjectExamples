using System;
using System.Collections.Generic;
using System.Text;

namespace OurFoodituteApp.Models
{
    public enum MenuItemType
    {
        Browse,
        Scanner
            //,  Favourites
    }
    public class HomeMenuItem
    {
        public MenuItemType Id { get; set; }

        public string Title { get; set; }
    }
}
