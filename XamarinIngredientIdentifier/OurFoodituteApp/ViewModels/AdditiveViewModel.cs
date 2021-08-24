using System;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Collections.Generic;
using System.Threading.Tasks;
using Xamarin.Forms;

using OurFoodituteApp.Models;
using OurFoodituteApp.Views;
using Newtonsoft.Json;
using RestSharp;
using System.Reflection;
using System.IO;


namespace OurFoodituteApp.ViewModels
{
    public class AdditiveViewModel : BaseViewModel
    {
        public ObservableCollection<Suggestions> Suggestions { get; set; }
        public ObservableCollection<AdditiveModel> Items { get; set; }
        public Command LoadItemsCommand { get; set; }

        public AdditiveViewModel()
        {
            Items = new ObservableCollection<AdditiveModel>();
            Suggestions = new ObservableCollection<Suggestions>();
            LoadItemsCommand = new Command(async () => await ExecuteLoadItemsCommand());
        }

        async Task ExecuteLoadItemsCommand()
        {
            if (IsBusy)
                return;

            IsBusy = true;

            try
            {
                Items.Clear();
                var items = await DataStore.GetItemsAsync(true);
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
        public static void ReadJson(AdditiveModel item, string AdditiveCode)
        {
            // read json
            var assembly = IntrospectionExtensions.GetTypeInfo(typeof(AdditivePage)).Assembly;
            Stream stream = assembly.GetManifestResourceStream("OurFoodituteApp.DataBase.Additives." + AdditiveCode + ".json");
            string text = "";
            using (var reader = new System.IO.StreamReader(stream))
            {
                text = reader.ReadToEnd();
            }

            //json to class
            AdditiveModel additive = JsonConvert.DeserializeObject<AdditiveModel>(text);
            
            // navigate
            item.Code = AdditiveCode + " - " + additive.Name;
            item.Info = additive.Info;
            item.Function = additive.Function;
            item.Foods = additive.Foods;
            item.Notice = additive.Notice;
      
        }

        public static List<string> GetList()
        {
            DataBase.AutocompleteReference codeList = new DataBase.AutocompleteReference();
            List<string> EcodeList = codeList.ReturnList();
            return EcodeList;
        }

        public static string NameToCode(string userInput)
        {
            AdditiveModel Item = new AdditiveModel();
            string responseCode = "";
            // request to API search to determine corresponding additive code
            var client = new RestClient("https://vx-e-additives.p.rapidapi.com/additives/search?sort=name&q=" + userInput);
            var request = new RestRequest(Method.GET);
            request.AddHeader("x-rapidapi-host", "vx-e-additives.p.rapidapi.com");
            request.AddHeader("x-rapidapi-key", "241e991d0dmsh62f42d2c0341101p1df60cjsn77e07f49f8f2");
            IRestResponse response = client.Execute(request);
            var filter = JsonConvert.DeserializeObject<List<AdditiveModel>>(response.Content);

            // API does not implement status codes
            if (response.Content.Length == 3)
            {
                return null;
            }
            else
            {
                foreach (var id in filter)
                {
                    responseCode = id.Code;
                }
                return responseCode;
            }

        }
    }
}
