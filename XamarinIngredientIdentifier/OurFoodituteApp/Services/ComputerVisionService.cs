using Microsoft.Azure.CognitiveServices.Vision.ComputerVision;
using Microsoft.Azure.CognitiveServices.Vision.ComputerVision.Models;
using Plugin.Media;
using Plugin.Media.Abstractions;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;
using static System.Net.Mime.MediaTypeNames;

namespace OurFoodituteApp.Services
{
    public class ComputerVisionService
    {
        public static ComputerVisionClient Authenticate(string endpoint, string key)
        {
            ComputerVisionClient client =
                new ComputerVisionClient(new ApiKeyServiceClientCredentials(key))
                { Endpoint = endpoint };
            return client;
        }

        public static async Task<string> ExtractTextLocal(ComputerVisionClient client, string localImage)
        {
            //new MemoryStream(File.ReadAllBytes(localImage))

            string scan = "";
            try
            {
                Console.WriteLine("----------------------------------------------------------");
                Console.WriteLine("EXTRACT TEXT - LOCAL IMAGE");
                Console.WriteLine();

                // Helps calucalte starting index to retrieve operation ID
                const int numberOfCharsInOperationId = 36;

                using (Stream imageStream = new MemoryStream(File.ReadAllBytes(localImage)))
                {
                    // Read the text from the local image
                    BatchReadFileInStreamHeaders localFileTextHeaders = await client.BatchReadFileInStreamAsync(imageStream);
                    // Get the operation location (operation ID)
                    string operationLocation = localFileTextHeaders.OperationLocation;

                    // Retrieve the URI where the recognized text will be stored from the Operation-Location header.
                    string operationId = operationLocation.Substring(operationLocation.Length - numberOfCharsInOperationId);

                    // Extract text, wait for it to complete.
                    int i = 0;
                    int maxRetries = 10;
                    ReadOperationResult results;
                    do
                    {
                        results = await client.GetReadOperationResultAsync(operationId);
                        Console.WriteLine("Server status: {0}, waiting {1} seconds...", results.Status, i);
                        await Task.Delay(1000);
                        if (maxRetries == 9)
                        {
                            Console.WriteLine("Server timed out.");
                        }
                    }
                    while ((results.Status == TextOperationStatusCodes.Running ||
                            results.Status == TextOperationStatusCodes.NotStarted) && i++ < maxRetries);

                    // Display the found text.
                    Console.WriteLine();
                    var textRecognitionLocalFileResults = results.RecognitionResults;
                    foreach (TextRecognitionResult recResult in textRecognitionLocalFileResults)
                    {
                        foreach (Line line in recResult.Lines)
                        {
                            Console.WriteLine(line.Text);
                            scan += line.Text + " ";
                        }
                    }
                    Console.WriteLine();
                }
            }
            catch
            {
                scan = "An error has occured please try again, or contact the developers";
            }

            return scan;
        }
    }
}
