namespace phpAPI
{
    partial class AddProduct
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.panel2 = new System.Windows.Forms.Panel();
            this.panel1 = new System.Windows.Forms.Panel();
            this.panel4 = new System.Windows.Forms.Panel();
            this.category = new System.Windows.Forms.ComboBox();
            this.tbQuantity = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.tbDescription = new System.Windows.Forms.TextBox();
            this.lblDescription = new System.Windows.Forms.Label();
            this.tbPrice = new System.Windows.Forms.TextBox();
            this.tbName = new System.Windows.Forms.TextBox();
            this.email = new System.Windows.Forms.Label();
            this.address = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.panel3 = new System.Windows.Forms.Panel();
            this.btnAdd = new System.Windows.Forms.Button();
            this.panel1.SuspendLayout();
            this.panel4.SuspendLayout();
            this.panel3.SuspendLayout();
            this.SuspendLayout();
            // 
            // panel2
            // 
            this.panel2.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel2.Location = new System.Drawing.Point(0, 0);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(878, 150);
            this.panel2.TabIndex = 0;
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.panel4);
            this.panel1.Controls.Add(this.panel3);
            this.panel1.Controls.Add(this.panel2);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(878, 544);
            this.panel1.TabIndex = 1;
            // 
            // panel4
            // 
            this.panel4.Controls.Add(this.category);
            this.panel4.Controls.Add(this.tbQuantity);
            this.panel4.Controls.Add(this.label3);
            this.panel4.Controls.Add(this.tbDescription);
            this.panel4.Controls.Add(this.lblDescription);
            this.panel4.Controls.Add(this.tbPrice);
            this.panel4.Controls.Add(this.tbName);
            this.panel4.Controls.Add(this.email);
            this.panel4.Controls.Add(this.address);
            this.panel4.Controls.Add(this.label1);
            this.panel4.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel4.Location = new System.Drawing.Point(0, 150);
            this.panel4.Name = "panel4";
            this.panel4.Padding = new System.Windows.Forms.Padding(50);
            this.panel4.Size = new System.Drawing.Size(878, 244);
            this.panel4.TabIndex = 2;
            // 
            // category
            // 
            this.category.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.category.FormattingEnabled = true;
            this.category.Items.AddRange(new object[] {
            "Electoronics"});
            this.category.Location = new System.Drawing.Point(230, 199);
            this.category.Name = "category";
            this.category.Size = new System.Drawing.Size(527, 28);
            this.category.TabIndex = 1;
            // 
            // tbQuantity
            // 
            this.tbQuantity.Location = new System.Drawing.Point(230, 153);
            this.tbQuantity.Name = "tbQuantity";
            this.tbQuantity.Size = new System.Drawing.Size(527, 26);
            this.tbQuantity.TabIndex = 8;
            this.tbQuantity.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.tbQuantity_KeyPress);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.ForeColor = System.Drawing.SystemColors.ButtonHighlight;
            this.label3.Location = new System.Drawing.Point(137, 156);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(72, 20);
            this.label3.TabIndex = 7;
            this.label3.Text = "Quantity:";
            // 
            // tbDescription
            // 
            this.tbDescription.Location = new System.Drawing.Point(230, 62);
            this.tbDescription.Name = "tbDescription";
            this.tbDescription.Size = new System.Drawing.Size(527, 26);
            this.tbDescription.TabIndex = 6;
            // 
            // lblDescription
            // 
            this.lblDescription.AutoSize = true;
            this.lblDescription.ForeColor = System.Drawing.SystemColors.ButtonHighlight;
            this.lblDescription.Location = new System.Drawing.Point(137, 62);
            this.lblDescription.Name = "lblDescription";
            this.lblDescription.Size = new System.Drawing.Size(93, 20);
            this.lblDescription.TabIndex = 5;
            this.lblDescription.Text = "Description:";
            // 
            // tbPrice
            // 
            this.tbPrice.Location = new System.Drawing.Point(230, 105);
            this.tbPrice.Name = "tbPrice";
            this.tbPrice.Size = new System.Drawing.Size(527, 26);
            this.tbPrice.TabIndex = 3;
            this.tbPrice.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.tbPrice_KeyPress);
            // 
            // tbName
            // 
            this.tbName.Location = new System.Drawing.Point(230, 16);
            this.tbName.Name = "tbName";
            this.tbName.Size = new System.Drawing.Size(527, 26);
            this.tbName.TabIndex = 2;
            // 
            // email
            // 
            this.email.AutoSize = true;
            this.email.ForeColor = System.Drawing.SystemColors.ButtonHighlight;
            this.email.Location = new System.Drawing.Point(137, 108);
            this.email.Name = "email";
            this.email.Size = new System.Drawing.Size(48, 20);
            this.email.TabIndex = 1;
            this.email.Text = "Price:";
            // 
            // address
            // 
            this.address.AutoSize = true;
            this.address.ForeColor = System.Drawing.SystemColors.ButtonHighlight;
            this.address.Location = new System.Drawing.Point(137, 199);
            this.address.Name = "address";
            this.address.Size = new System.Drawing.Size(77, 20);
            this.address.TabIndex = 1;
            this.address.Text = "Category:";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.ForeColor = System.Drawing.SystemColors.ButtonHighlight;
            this.label1.Location = new System.Drawing.Point(137, 16);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(55, 20);
            this.label1.TabIndex = 0;
            this.label1.Text = "Name:";
            // 
            // panel3
            // 
            this.panel3.Controls.Add(this.btnAdd);
            this.panel3.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.panel3.Location = new System.Drawing.Point(0, 394);
            this.panel3.Name = "panel3";
            this.panel3.Size = new System.Drawing.Size(878, 150);
            this.panel3.TabIndex = 1;
            // 
            // btnAdd
            // 
            this.btnAdd.BackColor = System.Drawing.Color.White;
            this.btnAdd.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnAdd.Location = new System.Drawing.Point(390, 32);
            this.btnAdd.Name = "btnAdd";
            this.btnAdd.Size = new System.Drawing.Size(120, 60);
            this.btnAdd.TabIndex = 0;
            this.btnAdd.Text = "Add";
            this.btnAdd.UseVisualStyleBackColor = false;
            this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
            // 
            // AddProduct
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(9F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(44)))), ((int)(((byte)(62)))), ((int)(((byte)(80)))));
            this.ClientSize = new System.Drawing.Size(878, 544);
            this.Controls.Add(this.panel1);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "AddProduct";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Add Product";
            this.panel1.ResumeLayout(false);
            this.panel4.ResumeLayout(false);
            this.panel4.PerformLayout();
            this.panel3.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Panel panel4;
        private System.Windows.Forms.TextBox tbPrice;
        private System.Windows.Forms.TextBox tbName;
        private System.Windows.Forms.Label email;
        private System.Windows.Forms.Label address;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Panel panel3;
        private System.Windows.Forms.Button btnAdd;
        private System.Windows.Forms.TextBox tbQuantity;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox tbDescription;
        private System.Windows.Forms.Label lblDescription;
        private System.Windows.Forms.ComboBox category;
    }
}