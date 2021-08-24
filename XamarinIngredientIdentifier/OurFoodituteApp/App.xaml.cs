using Xamarin.Forms;
using OurFoodituteApp.Services;
using OurFoodituteApp.Views;
using OurFoodituteApp.ViewModels;

namespace OurFoodituteApp
{
    public partial class App : Application
    {

        public App()
        {
            InitializeComponent();
            DependencyService.Register<AdditiveDataStore>();
            MainPage = new MainPage();
            AppViewModel.CheckApiUpdate();
        }

        protected override void OnStart()
        {
            // Handle when your app starts
         
        }

        protected override void OnSleep()
        {
            // Handle when your app sleeps
        }

        protected override void OnResume()
        {
            // Handle when your app resumes
        }
    }
}
