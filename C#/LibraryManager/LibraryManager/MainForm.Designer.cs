namespace LibraryManager
{
    partial class MainForm
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
            this.label1 = new System.Windows.Forms.Label();
            this.BtnManageBooks = new System.Windows.Forms.Button();
            this.BtnManageUsers = new System.Windows.Forms.Button();
            this.BtnRegisterLoan = new System.Windows.Forms.Button();
            this.BtnLogout = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.BackColor = System.Drawing.Color.Lime;
            this.label1.Dock = System.Windows.Forms.DockStyle.Top;
            this.label1.Font = new System.Drawing.Font("A Iranian Sans", 24F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(178)));
            this.label1.Location = new System.Drawing.Point(0, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(884, 64);
            this.label1.TabIndex = 0;
            this.label1.Text = "سیستم مدیریت کتابخانه";
            this.label1.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // BtnManageBooks
            // 
            this.BtnManageBooks.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.BtnManageBooks.AutoSize = true;
            this.BtnManageBooks.BackColor = System.Drawing.Color.Orange;
            this.BtnManageBooks.Font = new System.Drawing.Font("A Iranian Sans", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(178)));
            this.BtnManageBooks.Location = new System.Drawing.Point(339, 158);
            this.BtnManageBooks.Name = "BtnManageBooks";
            this.BtnManageBooks.Size = new System.Drawing.Size(200, 50);
            this.BtnManageBooks.TabIndex = 0;
            this.BtnManageBooks.Text = "مدیریت کتاب‌ها";
            this.BtnManageBooks.UseVisualStyleBackColor = false;
            this.BtnManageBooks.Click += new System.EventHandler(this.BtnManageBooks_Click);
            // 
            // BtnManageUsers
            // 
            this.BtnManageUsers.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.BtnManageUsers.AutoSize = true;
            this.BtnManageUsers.BackColor = System.Drawing.Color.Orange;
            this.BtnManageUsers.Font = new System.Drawing.Font("A Iranian Sans", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(178)));
            this.BtnManageUsers.Location = new System.Drawing.Point(98, 158);
            this.BtnManageUsers.Name = "BtnManageUsers";
            this.BtnManageUsers.Size = new System.Drawing.Size(200, 50);
            this.BtnManageUsers.TabIndex = 1;
            this.BtnManageUsers.Text = "مدیریت اعضا";
            this.BtnManageUsers.UseVisualStyleBackColor = false;
            this.BtnManageUsers.Click += new System.EventHandler(this.BtnManageUsers_Click);
            // 
            // BtnRegisterLoan
            // 
            this.BtnRegisterLoan.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.BtnRegisterLoan.AutoSize = true;
            this.BtnRegisterLoan.BackColor = System.Drawing.Color.Orange;
            this.BtnRegisterLoan.Font = new System.Drawing.Font("A Iranian Sans", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(178)));
            this.BtnRegisterLoan.Location = new System.Drawing.Point(579, 158);
            this.BtnRegisterLoan.Name = "BtnRegisterLoan";
            this.BtnRegisterLoan.Size = new System.Drawing.Size(200, 50);
            this.BtnRegisterLoan.TabIndex = 2;
            this.BtnRegisterLoan.Text = "ثبت امانت";
            this.BtnRegisterLoan.UseVisualStyleBackColor = false;
            this.BtnRegisterLoan.Click += new System.EventHandler(this.BtnRegisterLoan_Click);
            // 
            // BtnLogout
            // 
            this.BtnLogout.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.BtnLogout.BackColor = System.Drawing.Color.Red;
            this.BtnLogout.Font = new System.Drawing.Font("A Iranian Sans", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(178)));
            this.BtnLogout.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.BtnLogout.Location = new System.Drawing.Point(380, 283);
            this.BtnLogout.Name = "BtnLogout";
            this.BtnLogout.Size = new System.Drawing.Size(115, 42);
            this.BtnLogout.TabIndex = 2;
            this.BtnLogout.Text = "خروج";
            this.BtnLogout.UseVisualStyleBackColor = false;
            this.BtnLogout.Click += new System.EventHandler(this.BtnLogout_Click);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Navy;
            this.ClientSize = new System.Drawing.Size(884, 411);
            this.Controls.Add(this.BtnRegisterLoan);
            this.Controls.Add(this.BtnManageUsers);
            this.Controls.Add(this.BtnManageBooks);
            this.Controls.Add(this.BtnLogout);
            this.Controls.Add(this.label1);
            this.MinimumSize = new System.Drawing.Size(200, 39);
            this.Name = "MainForm";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Load += new System.EventHandler(this.MainForm_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button BtnManageBooks;
        private System.Windows.Forms.Button BtnManageUsers;
        private System.Windows.Forms.Button BtnRegisterLoan;
        private System.Windows.Forms.Button BtnLogout;
    }
}