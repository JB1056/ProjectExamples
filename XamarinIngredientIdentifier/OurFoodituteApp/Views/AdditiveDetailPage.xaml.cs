using System;
using System.ComponentModel;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

using OurFoodituteApp.Models;
using OurFoodituteApp.ViewModels;

namespace OurFoodituteApp.Views
{
    public partial class AdditiveDetailPage : ContentPage
    {
        AdditiveDetailViewModel viewModel;
        public AdditiveDetailPage(AdditiveDetailViewModel viewModel)
        {
            InitializeComponent();
            BindingContext = this.viewModel = viewModel;
        }
    }
}