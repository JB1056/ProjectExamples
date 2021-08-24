using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Newtonsoft.Json;
using OurFoodituteApp.Models;
using OurFoodituteApp.ViewModels;
using OurFoodituteApp.Views;

namespace OurFoodituteApp.Services
{
    public class AdditiveDataStore : IDataStore<AdditiveModel>
    {
        List<AdditiveModel> items;
        public AdditiveDataStore()
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
                AdditiveModel item = new AdditiveModel { Id = Guid.NewGuid().ToString(), Code = additives[i].Code, Name = additives[i].Name};
                mockItems.Add(item);
            }

            foreach (var item in mockItems)
            {
                items.Add(item);
            }
        }

        public async Task<bool> AddItemAsync(AdditiveModel item)
        {
            items.Add(item);

            return await Task.FromResult(true);
        }

        public async Task<bool> UpdateItemAsync(AdditiveModel item)
        {
            var oldItem = items.Where((AdditiveModel arg) => arg.Id == item.Id).FirstOrDefault();
            items.Remove(oldItem);
            items.Add(item);

            return await Task.FromResult(true);
        }

        public async Task<bool> DeleteItemAsync(string id)
        {
            var oldItem = items.Where((AdditiveModel arg) => arg.Id == id).FirstOrDefault();
            items.Remove(oldItem);

            return await Task.FromResult(true);
        }

        public async Task<AdditiveModel> GetItemAsync(string id)
        {
            return await Task.FromResult(items.FirstOrDefault(s => s.Id == id));
        }

        public async Task<IEnumerable<AdditiveModel>> GetItemsAsync(bool forceRefresh = false)
        {
            return await Task.FromResult(items);
        }
    }
}