using OurFoodituteApp.Services;
using OurFoodituteApp.ViewModels;
using Plugin.Media;
using Plugin.Media.Abstractions;
using Stormlion.ImageCropper;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace OurFoodituteApp.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class ScannerPage : ContentPage
    {
        ScannerViewModel viewModel;
        public ScannerPage()
        {
            InitializeComponent();
            BindingContext = viewModel = new ScannerViewModel();
            CrossMedia.Current.Initialize();
        }

        private async void Scanner_OnClicked(object sender, EventArgs e)
        {
            await ScannerViewModel.Photo(ImagetoText, Spinner, ImageView, this);
            await Navigation.PushAsync(new ScannedAdditivePage());
        }
    }
}