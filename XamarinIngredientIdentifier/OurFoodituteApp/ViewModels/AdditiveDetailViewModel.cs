using System;

using OurFoodituteApp.Models;

namespace OurFoodituteApp.ViewModels
{
    public class AdditiveDetailViewModel : BaseViewModel
    {
        public AdditiveModel Item { get; set; }
        public AdditiveDetailViewModel(AdditiveModel item = null)
        {
            Title = item?.Code;
            Item = item;
           
        }
    }
}
