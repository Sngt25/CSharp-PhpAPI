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
    public partial class AddUser : Form
    {
        private static readonly HttpClient client = new HttpClient();

        public AddUser()
        {
            InitializeComponent();
        }

        private async void btnAdd_Click(object sender, EventArgs e)
        {
            // Validate input fields
            if (
                string.IsNullOrWhiteSpace(tbUsername.Text)
                || string.IsNullOrWhiteSpace(tbEmail.Text)
                || string.IsNullOrWhiteSpace(tbAddress.Text)
            )
            {
                MessageBox.Show("Please fill in all fields.");
                return;
            }

            var userData = new
            {
                username = tbUsername.Text,
                email = tbEmail.Text,
                address = tbAddress.Text
            };

            string json = JsonConvert.SerializeObject(userData);
            HttpContent content = new StringContent(json, Encoding.UTF8, "application/json");

            try
            {
                HttpResponseMessage response = await client.PostAsync(
                    "http://localhost/api/User.php",
                    content
                );
                response.EnsureSuccessStatusCode();

                string responseContent = await response.Content.ReadAsStringAsync();
                MessageBox.Show("User added successfully!");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }
    }
}
