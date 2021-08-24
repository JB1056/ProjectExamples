using OurFoodituteApp.ViewModels;
using System;
using System.Collections.Generic;
using System.Text;

namespace OurFoodituteApp.Models
{
    public class Suggestions : BaseViewModel
    {
        public Suggestions(string sugg)
        {
            Suggestion = sugg;
        }
        private string suggestion;
        public string Suggestion { 
            get { return suggestion; }
            set
            {
                SetProperty(ref suggestion, value);
            }
        }

    }
}
