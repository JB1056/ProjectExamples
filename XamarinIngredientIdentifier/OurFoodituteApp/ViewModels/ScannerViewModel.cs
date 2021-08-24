using System.Collections.Generic;
using Plugin.Media;
using Xamarin.Forms;
using Plugin.Media.Abstractions;
using OurFoodituteApp.Services;
using System.Threading.Tasks;
using Stormlion.ImageCropper;
using OurFoodituteApp.Views;

namespace OurFoodituteApp.ViewModels
{
    public class ScannerViewModel : BaseViewModel
    {
        public ScannerViewModel()
        {

        }

        public static void spinnerFunc(ActivityIndicator spinner, bool active) {
            spinner.IsRunning = active;
            spinner.IsVisible = active;
        }


        public static string match = "";

        static DataBase.AutocompleteReference codeList = new DataBase.AutocompleteReference();
        public static List<string> GetList()
        {
            List<string> EcodeList = codeList.ReturnList();
            return EcodeList;
        }

        public static string Compare(string ImageToText)
        {
            match = "";
            
            foreach (string x in GetList()) {
                if (ImageToText.ToLower().Contains(x.ToLower())) {
                    match += x + ",";
                }
            }
            return match;
        }

        public static async Task Photo(Label text, ActivityIndicator spinner, Image imageView, Page thisPage)
        {
            // crop photo
            string CroppedImage = null;
            new ImageCropper()
            {
                PageTitle = "Crop Ingredients",
                Success = (imageFile) =>
                {
                    Device.BeginInvokeOnMainThread(() =>
                    {
                        imageView.Source = ImageSource.FromFile(imageFile);
                        CroppedImage = imageFile;
                    });
                }
            }.Show(thisPage);

            while (CroppedImage == null)
            {
                await Task.Delay(25);
            }

            // extract text from image
            spinnerFunc(spinner, true);
            text.Text = "Analysing...";
            string ImageToText = await ComputerVisionService.ExtractTextLocal(ComputerVisionService.Authenticate("https://computervisionapi11.cognitiveservices.azure.com/", "ef876e3b0c534494b506c4ca42fa10ce"), CroppedImage);
            Compare(ImageToText);
            text.Text = "";
            spinnerFunc(spinner, false);
            imageView.Source = null;
        }
    }
}
