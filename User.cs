using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Windows.Forms;
using Newtonsoft.Json;

namespace phpAPI
{
    public partial class User : Form
    {
        private static readonly HttpClient client = new HttpClient();

        public User()
        {
            InitializeComponent();
            this.Load += LoadUsers;
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            AddUser addUser = new AddUser();
            addUser.ShowDialog();
        }

        private async void LoadUsers(object sender, EventArgs e)
        {
            try
            {
                HttpResponseMessage response = await client.GetAsync(
                    "http://localhost/api/User.php"
                );
                response.EnsureSuccessStatusCode();

                string jsonResponse = await response.Content.ReadAsStringAsync();
                List<User2> users = JsonConvert.DeserializeObject<List<User2>>(jsonResponse);

                userDataGrid.DataSource = users;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }
    }

    public class User2
    {
        public int user_id { get; set; }
        public string username { get; set; }
        public string email { get; set; }
        public string address { get; set; }
    }
}
