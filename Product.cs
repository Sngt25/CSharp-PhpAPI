using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Newtonsoft.Json;

namespace phpAPI
{
    public partial class Product : Form
    {
        private static readonly HttpClient client = new HttpClient();

        public Product()
        {
            InitializeComponent();
            this.Load += LoadProducts;
        }

        private async void LoadProducts(object sender, EventArgs e)
        {
            try
            {
                HttpResponseMessage response = await client.GetAsync(
                    "http://localhost/api/Product.php"
                );
                response.EnsureSuccessStatusCode();

                string jsonResponse = await response.Content.ReadAsStringAsync();
                List<Product2> products = JsonConvert.DeserializeObject<List<Product2>>(
                    jsonResponse
                );

                productDataGrid.DataSource = products;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            AddProduct addProduct = new AddProduct();
            addProduct.ShowDialog();
        }
    }

    public class Product2
    {
        public int product_id { get; set; }
        public string name { get; set; }
        public string description { get; set; }
        public string price { get; set; }
        public string quantity_in_stock { get; set; }
        public string category_name { get; set; }
    }
}
