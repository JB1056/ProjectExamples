using System;
using System.Collections.Generic;
using System.ComponentModel;
using Xamarin.Forms;
using OurFoodituteApp.Models;
using OurFoodituteApp.ViewModels;



namespace OurFoodituteApp.Views
{
    [DesignTimeVisible(false)]
    public partial class ScannedAdditivePage : ContentPage
    {

        ScannedAdditiveViewModel viewModel;

        public ScannedAdditivePage()
        {
            InitializeComponent();
            BindingContext = viewModel = new ScannedAdditiveViewModel();
        }

        async void OnItemSelected(object sender, SelectedItemChangedEventArgs args)
        {

            // get additive
            var item = args.SelectedItem as AdditiveModel;
            if (item == null)
                return;
            string AdditiveCode = item.Code;
            string AdditiveName = item.Name;
            // read json
            AdditiveViewModel.ReadJson(item, AdditiveCode);
            // load selected additive
            await Navigation.PushAsync(new AdditiveDetailPage(new AdditiveDetailViewModel(item)));
            // manually deslect item
            ItemsListView.SelectedItem = null;
            item.Code = AdditiveCode;
            item.Name = AdditiveName;
        }

        protected override void OnAppearing()
        {
            base.OnAppearing();
            if (viewModel.Items.Count == 0)
                viewModel.LoadItemsCommand.Execute(null);
        }
    }
}