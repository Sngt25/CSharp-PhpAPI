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
    public partial class AddProduct : Form
    {
        private static readonly HttpClient client = new HttpClient();
        private List<Category> categories; // Store categories here

        public AddProduct()
        {
            InitializeComponent();
            LoadCategories();
        }

        private async void LoadCategories()
        {
            try
            {
                HttpResponseMessage response = await client.GetAsync(
                    "http://localhost/api/Category.php"
                );
                response.EnsureSuccessStatusCode();

                string jsonResponse = await response.Content.ReadAsStringAsync();
                categories = JsonConvert.DeserializeObject<List<Category>>(jsonResponse); // Deserialize to categories

                List<string> items = new List<string>();
                foreach (var category in categories)
                {
                    items.Add(category.category_name);
                }

                category.DataSource = items;
            }
            catch (Exception e)
            {
                MessageBox.Show(e.Message);
            }
        }

        private async void btnAdd_Click(object sender, EventArgs e)
        {
            int selectedIndex = category.SelectedIndex;
            if (selectedIndex >= 0)
            {
                Category selectedCategory = categories[selectedIndex];

                // Validate input fields
                if (
                    string.IsNullOrWhiteSpace(tbName.Text)
                    || string.IsNullOrWhiteSpace(tbDescription.Text)
                    || string.IsNullOrWhiteSpace(tbQuantity.Text)
                    || string.IsNullOrWhiteSpace(tbPrice.Text)
                )
                {
                    MessageBox.Show("Please fill in all fields.");
                    return;
                }

                // Ensure tbQuantity is an integer and tbPrice is a decimal
                if (
                    !int.TryParse(tbQuantity.Text, out int quantity)
                    || !decimal.TryParse(tbPrice.Text, out decimal price)
                )
                {
                    MessageBox.Show("Please enter valid numeric values for Quantity and Price.");
                    return;
                }

                var productData = new
                {
                    name = tbName.Text,
                    description = tbDescription.Text,
                    quantity_in_stock = quantity,
                    price = price,
                    category_id = selectedCategory.category_id
                };

                string json = JsonConvert.SerializeObject(productData);
                HttpContent content = new StringContent(json, Encoding.UTF8, "application/json");

                try
                {
                    HttpResponseMessage response = await client.PostAsync(
                        "http://localhost/api/Product.php",
                        content
                    );
                    response.EnsureSuccessStatusCode();

                    string responseContent = await response.Content.ReadAsStringAsync();
                    MessageBox.Show("Product added successfully!");
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Error: " + ex.Message);
                }
            }
            else
            {
                MessageBox.Show("Please select a category.");
            }
        }

        private void tbQuantity_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar))
            {
                e.Handled = true;
            }
        }

        private void tbPrice_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar) && (e.KeyChar != '.'))
            {
                e.Handled = true;
            }

            // Allow only one decimal point
            if ((e.KeyChar == '.') && ((sender as TextBox).Text.IndexOf('.') > -1))
            {
                e.Handled = true;
            }
        }
    }

    public class Category
    {
        public int category_id { get; set; }
        public string category_name { get; set; }
    }
}
