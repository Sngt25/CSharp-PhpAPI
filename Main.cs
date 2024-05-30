using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace phpAPI
{
    public partial class Main : Form
    {
        public Main()
        {
            InitializeComponent();

            Product product = new Product()
            {
                Dock = DockStyle.Fill,
                TopLevel = false,
                TopMost = true
            };
            product.FormBorderStyle = FormBorderStyle.None;
            this.panelMain.Controls.Add(product);
            product.Show();
        }

        private void btnProduct_Click(object sender, EventArgs e)
        {
            this.panelMain.Controls.Clear();

            Product product = new Product()
            {
                Dock = DockStyle.Fill,
                TopLevel = false,
                TopMost = true
            };
            product.FormBorderStyle = FormBorderStyle.None;
            this.panelMain.Controls.Add(product);
            product.Show();
        }

        private void btnUser_Click(object sender, EventArgs e)
        {
            this.panelMain.Controls.Clear();

            User user = new User()
            {
                Dock = DockStyle.Fill,
                TopLevel = false,
                TopMost = true
            };

            user.FormBorderStyle = FormBorderStyle.None;
            this.panelMain.Controls.Add(user);
            user.Show();
        }
    }
}
