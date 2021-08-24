using System;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Threading.Tasks;
using Xamarin.Forms;
using OurFoodituteApp.Models;
using System.Collections.Generic;
using System.Reflection;
using OurFoodituteApp.Views;
using System.IO;
using Newtonsoft.Json;

namespace OurFoodituteApp.ViewModels
{
    public class ScannedAdditiveViewModel : BaseViewModel
    {
        public ObservableCollection<AdditiveModel> Items { get; set; }
        public Command LoadItemsCommand { get; set; }

        public ScannedAdditiveViewModel()
        {
            Items = new ObservableCollection<AdditiveModel>();
            LoadItemsCommand = new Command(async () => await ExecuteLoadItemsCommand());
        }

        private async Task ExecuteLoadItemsCommand()
        {
            if (IsBusy)
                return;

            IsBusy = true;

            try
            {
                Items.Clear();
                var items = await GetScannedItems();
                foreach (var item in items)
                {
                    Items.Add(item);
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex);
            }
            finally
            {
                IsBusy = false;
            }
        }

        private Task<List<AdditiveModel>> GetScannedItems()
        {
            List<AdditiveModel> items;

            return Task.Run(() =>
            {
                // read json
                var assembly = IntrospectionExtensions.GetTypeInfo(typeof(AdditivePage)).Assembly;
                Stream stream = assembly.GetManifestResourceStream("OurFoodituteApp.DataBase.AdditiveList.json");
                string text = "";
                using (var reader = new System.IO.StreamReader(stream))
                {
                    text = reader.ReadToEnd();
                }

                // json to class
                AdditiveModel[] additives = JsonConvert.DeserializeObject<AdditiveModel[]>(text);

                // json to list
                items = new List<AdditiveModel>();
                var mockItems = new List<AdditiveModel>();
                for (int i = 0; i < additives.Length; i++)
                {
                    AdditiveModel item = new AdditiveModel { Id = Guid.NewGuid().ToString(), Code = additives[i].Code, Name = additives[i].Name };
                    mockItems.Add(item);
                }

                // compare to scanned additives
                foreach (var additive in ScannerViewModel.match.Split(','))
                {
                    foreach (var item in mockItems)
                    {
                        if (item.Code == additive || item.Name == additive)
                        {
                            items.Add(item);
                        }
                    }
                }

                return items;
            });

        }
    }
}
