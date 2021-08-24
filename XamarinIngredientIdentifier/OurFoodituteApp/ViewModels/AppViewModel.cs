using Newtonsoft.Json;
using OurFoodituteApp.Models;
using RestSharp;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

// This ViewModel is purely used to check updates on the api
namespace OurFoodituteApp.ViewModels
{
    class AppViewModel
    {
        public AppViewModel() { }
        public static void CheckApiUpdate()
        {
            var client = new RestClient("https://vx-e-additives.p.rapidapi.com/additives?order=desc&locale=en&sort=last_update");
            var request = new RestRequest(Method.GET);
            request.AddHeader("x-rapidapi-host", "vx-e-additives.p.rapidapi.com");
            request.AddHeader("x-rapidapi-key", "241e991d0dmsh62f42d2c0341101p1df60cjsn77e07f49f8f2");
            IRestResponse response = client.Execute(request);
            var update = JsonConvert.DeserializeObject<List<AdditiveModel>>(response.Content);

            AdditiveModel MostRecent = new AdditiveModel { Id = Guid.NewGuid().ToString(), Last_Update = update[0].Last_Update };

            if (MostRecent.Last_Update != "2013-10-07T19:42:59+0300")
            {
                AdditiveModel[] additives = JsonConvert.DeserializeObject<AdditiveModel[]>(response.Content);
                for (int i = 0; i < additives.Length; i++)
                {
                    File.WriteAllText(@"OurFoodituteApp.DataBase.Additives" + additives[i].Code + ".json", GetData(additives[i].Code));
                }
            }
        }

        public static string GetData(string code)
        {
            try
            {
                var client = new RestClient("https://vx-e-additives.p.rapidapi.com/additives/" + code);
                var request = new RestRequest(Method.GET);
                request.AddHeader("x-rapidapi-host", "vx-e-additives.p.rapidapi.com");
                request.AddHeader("x-rapidapi-key", "241e991d0dmsh62f42d2c0341101p1df60cjsn77e07f49f8f2");
                IRestResponse response = client.Execute(request);

                return response.Content;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
                Console.WriteLine("Api Request failed");
                return null;

            }
        }

    }


}
