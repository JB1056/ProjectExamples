using Microsoft.VisualStudio.TestTools.UnitTesting;
using OurFoodituteApp.ViewModels;
using System;
using System.IO;
using OurFoodituteApp.Services;
using System.Threading.Tasks;

namespace UnitTestProject1
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public void TestApiSearch() {

            var yellowToCode = AdditiveViewModel.NameToCode("Yellow 2G");
            var specialChar = AdditiveViewModel.NameToCode("Ponceau 4R; Cochineal Red A, Brilliant Scarlet 4R");
            var dummy = AdditiveViewModel.NameToCode("I don't exist");

            Assert.AreEqual(yellowToCode, "107");
            Assert.AreEqual(specialChar, "124");
            Assert.AreEqual(dummy, null);

        }

        [TestMethod]
        public async Task TestOCR()
        {
            string imagePath = AppDomain.CurrentDomain.BaseDirectory;
            string imageName = string.Format("{0}Resources\\testImage.png", Path.GetFullPath(Path.Combine(imagePath, @"..\..\..\")));
            Console.WriteLine(imageName);
            
            // API key endpoint & key exipiry < 30 days
            string response = await ComputerVisionService.ExtractTextLocal(ComputerVisionService.Authenticate("https://additiveapp.cognitiveservices.azure.com/", "163fcfd513d94d7aae274adb873e4666"), imageName);
            string formattedResponse = ScannerViewModel.Compare(response);

            Assert.AreEqual(formattedResponse, "200,302,Plain caramel,Vegetable carbon,Brown HT,");
            Assert.AreNotEqual(response, "200,302,Plain caramel,Vegetable carbon,Brown HT,", "API key has most likely expired");

        }

        
    }
}
