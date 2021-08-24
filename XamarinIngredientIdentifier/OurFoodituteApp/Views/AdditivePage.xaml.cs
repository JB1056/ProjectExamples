using System;
using System.ComponentModel;
using System.Linq;
using Xamarin.Forms;
using OurFoodituteApp.Models;
using OurFoodituteApp.ViewModels;
using System.Threading.Tasks;

// All methods use calls reliant on xaml elements, thus should not be within a viewmodel, elements should not be referenced from a VM
namespace OurFoodituteApp.Views
{
    [DesignTimeVisible(false)]
    public partial class AdditivePage : ContentPage
    {
        readonly AdditiveViewModel viewModel;

        public AdditivePage() {
            InitializeComponent();
            BindingContext = viewModel = new AdditiveViewModel();
            SuggestionsListView.IsVisible = false;
        }

        async void OnItemSelected(object sender, SelectedItemChangedEventArgs args) {

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

        protected override void OnAppearing() {
            base.OnAppearing();
            if (viewModel.Items.Count == 0)
                viewModel.LoadItemsCommand.Execute(null);
        }

        async void Handle_SearchButtonPressed(object sender, System.EventArgs e) {
            // get additive
            string AdditiveCode = AdditiveSearchBar.Text;

            //hide suggestion 
            await Task.Delay(1);
            SuggestionsListView.IsVisible = false;
                        

            // determine if input contains characters
            if (!Int32.TryParse(AdditiveCode, out var result)) {
                string decodedAdditive = AdditiveViewModel.NameToCode(AdditiveCode);
                if (decodedAdditive != null)
                {
                    AdditiveCode = decodedAdditive;
                }
            }

            try {
                AdditiveModel Item = new AdditiveModel();
                // read json
                AdditiveViewModel.ReadJson(Item, AdditiveCode);
                // load page
                await Navigation.PushAsync(new AdditiveDetailPage(new AdditiveDetailViewModel(Item)));
            } catch (ArgumentNullException ex) {
                Console.WriteLine("Exception" + ex);
                await DisplayAlert("Error: Not Found", "Could not find additive: " + AdditiveCode, "Ok");
            }
            // manually deselect item
            ItemsListView.SelectedItem = null;
        }

        private void Handle_ItemTapped(object sender, ItemTappedEventArgs e) {
            AdditiveSearchBar.Text = ((Suggestions)e.Item).Suggestion;
            SuggestionsListView.IsVisible = false;
            Handle_SearchButtonPressed(sender, e);
        }

        private void Handle_TextChanged(object sender, TextChangedEventArgs e) {
            var keyword = AdditiveSearchBar.Text;
            if (keyword?.Length >= 1) {
                viewModel.Suggestions.Clear();
                var suggList = AdditiveViewModel.GetList().Where(c => c.ToLower().Contains(keyword.ToLower()));
                foreach (var item in suggList) {
                    viewModel.Suggestions.Add(new Suggestions(item));
                }
                SuggestionsListView.IsVisible = true;
            } else {
                SuggestionsListView.IsVisible = false;
            }
        }
    }

   
}