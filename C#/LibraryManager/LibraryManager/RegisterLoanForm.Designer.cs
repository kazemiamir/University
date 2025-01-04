namespace LibraryManager
{
    partial class RegisterLoanForm
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
            this.cmbBooks = new System.Windows.Forms.ComboBox();
            this.cmbMembers = new System.Windows.Forms.ComboBox();
            this.dtpLoanDate = new System.Windows.Forms.DateTimePicker();
            this.dtpReturnDate = new System.Windows.Forms.DateTimePicker();
            this.chkIsReturned = new System.Windows.Forms.CheckBox();
            this.btnRegisterLoan = new System.Windows.Forms.Button();
            this.btnCancel = new System.Windows.Forms.Button();
            this.btnExit = new System.Windows.Forms.Button();
            this.btnMainPage = new System.Windows.Forms.Button();
            this.dgvLoans = new System.Windows.Forms.DataGridView();
            this.btnDeleteLoan = new System.Windows.Forms.Button();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.dgvLoans)).BeginInit();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.BackColor = System.Drawing.Color.Lime;
            this.label1.Dock = System.Windows.Forms.DockStyle.Top;
            this.label1.Font = new System.Drawing.Font("A Iranian Sans", 24F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(178)));
            this.label1.Location = new System.Drawing.Point(0, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(884, 64);
            this.label1.TabIndex = 0;
            this.label1.Text = "ثبت امانت";
            this.label1.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // cmbBooks
            // 
            this.cmbBooks.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.cmbBooks.Font = new System.Drawing.Font("A Iranian Sans", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(178)));
            this.cmbBooks.FormattingEnabled = true;
            this.cmbBooks.Location = new System.Drawing.Point(718, 94);
            this.cmbBooks.Name = "cmbBooks";
            this.cmbBooks.Size = new System.Drawing.Size(135, 30);
            this.cmbBooks.TabIndex = 1;
            this.cmbBooks.Text = "انتخاب کتاب";
            this.cmbBooks.SelectedIndexChanged += new System.EventHandler(this.cmbBooks_SelectedIndexChanged);
            // 
            // cmbMembers
            // 
            this.cmbMembers.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.cmbMembers.Font = new System.Drawing.Font("A Iranian Sans", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(178)));
            this.cmbMembers.FormattingEnabled = true;
            this.cmbMembers.Location = new System.Drawing.Point(553, 94);
            this.cmbMembers.Name = "cmbMembers";
            this.cmbMembers.Size = new System.Drawing.Size(136, 30);
            this.cmbMembers.TabIndex = 2;
            this.cmbMembers.Text = "انتخاب عضو";
            // 
            // dtpLoanDate
            // 
            this.dtpLoanDate.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.dtpLoanDate.Font = new System.Drawing.Font("A Iranian Sans", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(178)));
            this.dtpLoanDate.Location = new System.Drawing.Point(12, 165);
            this.dtpLoanDate.Name = "dtpLoanDate";
            this.dtpLoanDate.Size = new System.Drawing.Size(300, 26);
            this.dtpLoanDate.TabIndex = 3;
            // 
            // dtpReturnDate
            // 
            this.dtpReturnDate.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.dtpReturnDate.Font = new System.Drawing.Font("A Iranian Sans", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(178)));
            this.dtpReturnDate.Location = new System.Drawing.Point(12, 98);
            this.dtpReturnDate.Name = "dtpReturnDate";
            this.dtpReturnDate.Size = new System.Drawing.Size(300, 26);
            this.dtpReturnDate.TabIndex = 4;
            // 
            // chkIsReturned
            // 
            this.chkIsReturned.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.chkIsReturned.BackColor = System.Drawing.Color.White;
            this.chkIsReturned.Font = new System.Drawing.Font("A Iranian Sans", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(178)));
            this.chkIsReturned.Location = new System.Drawing.Point(553, 166);
            this.chkIsReturned.Name = "chkIsReturned";
            this.chkIsReturned.Size = new System.Drawing.Size(300, 30);
            this.chkIsReturned.TabIndex = 5;
            this.chkIsReturned.Text = "آیا کتاب بازگشت داده شده است؟";
            this.chkIsReturned.UseVisualStyleBackColor = false;
            // 
            // btnRegisterLoan
            // 
            this.btnRegisterLoan.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.btnRegisterLoan.BackColor = System.Drawing.Color.Orange;
            this.btnRegisterLoan.Font = new System.Drawing.Font("A Iranian Sans", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(178)));
            this.btnRegisterLoan.Location = new System.Drawing.Point(101, 233);
            this.btnRegisterLoan.Name = "btnRegisterLoan";
            this.btnRegisterLoan.Size = new System.Drawing.Size(130, 35);
            this.btnRegisterLoan.TabIndex = 6;
            this.btnRegisterLoan.Text = "ثبت امانت";
            this.btnRegisterLoan.UseVisualStyleBackColor = false;
            this.btnRegisterLoan.Click += new System.EventHandler(this.btnRegisterLoan_Click);
            // 
            // btnCancel
            // 
            this.btnCancel.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.btnCancel.BackColor = System.Drawing.Color.Orange;
            this.btnCancel.Font = new System.Drawing.Font("A Iranian Sans", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(178)));
            this.btnCancel.Location = new System.Drawing.Point(182, 284);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(130, 35);
            this.btnCancel.TabIndex = 7;
            this.btnCancel.Text = "لغو";
            this.btnCancel.UseVisualStyleBackColor = false;
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // btnExit
            // 
            this.btnExit.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.btnExit.BackColor = System.Drawing.Color.Red;
            this.btnExit.Font = new System.Drawing.Font("A Iranian Sans", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(178)));
            this.btnExit.Location = new System.Drawing.Point(182, 342);
            this.btnExit.Name = "btnExit";
            this.btnExit.Size = new System.Drawing.Size(130, 38);
            this.btnExit.TabIndex = 26;
            this.btnExit.Text = "خروج";
            this.btnExit.UseVisualStyleBackColor = false;
            this.btnExit.Click += new System.EventHandler(this.btnExit_Click);
            // 
            // btnMainPage
            // 
            this.btnMainPage.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.btnMainPage.BackColor = System.Drawing.Color.Yellow;
            this.btnMainPage.Font = new System.Drawing.Font("A Iranian Sans", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(178)));
            this.btnMainPage.Location = new System.Drawing.Point(15, 342);
            this.btnMainPage.Name = "btnMainPage";
            this.btnMainPage.Size = new System.Drawing.Size(130, 38);
            this.btnMainPage.TabIndex = 25;
            this.btnMainPage.Text = "صفحه اصلی";
            this.btnMainPage.UseVisualStyleBackColor = false;
            this.btnMainPage.Click += new System.EventHandler(this.btnMainPage_Click);
            // 
            // dgvLoans
            // 
            this.dgvLoans.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.dgvLoans.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvLoans.Location = new System.Drawing.Point(322, 202);
            this.dgvLoans.Name = "dgvLoans";
            this.dgvLoans.RowHeadersWidth = 51;
            this.dgvLoans.Size = new System.Drawing.Size(531, 202);
            this.dgvLoans.TabIndex = 27;
            this.dgvLoans.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dataGridView1_CellContentClick);
            // 
            // btnDeleteLoan
            // 
            this.btnDeleteLoan.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.btnDeleteLoan.BackColor = System.Drawing.Color.Orange;
            this.btnDeleteLoan.Font = new System.Drawing.Font("A Iranian Sans", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(178)));
            this.btnDeleteLoan.Location = new System.Drawing.Point(15, 284);
            this.btnDeleteLoan.Name = "btnDeleteLoan";
            this.btnDeleteLoan.Size = new System.Drawing.Size(130, 35);
            this.btnDeleteLoan.TabIndex = 28;
            this.btnDeleteLoan.Text = "حذف";
            this.btnDeleteLoan.UseVisualStyleBackColor = false;
            this.btnDeleteLoan.Click += new System.EventHandler(this.btnDeleteLoan_Click);
            // 
            // label2
            // 
            this.label2.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.label2.BackColor = System.Drawing.Color.LightGray;
            this.label2.Font = new System.Drawing.Font("A Iranian Sans", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(178)));
            this.label2.Location = new System.Drawing.Point(328, 165);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(162, 26);
            this.label2.TabIndex = 29;
            this.label2.Text = "تاریخ امانت ";
            this.label2.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label3
            // 
            this.label3.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.label3.BackColor = System.Drawing.Color.LightGray;
            this.label3.Font = new System.Drawing.Font("A Iranian Sans", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(178)));
            this.label3.Location = new System.Drawing.Point(328, 96);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(162, 27);
            this.label3.TabIndex = 30;
            this.label3.Text = "تاریخ بازگشت امانت ";
            this.label3.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // RegisterLoanForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 19F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Navy;
            this.ClientSize = new System.Drawing.Size(884, 411);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.btnDeleteLoan);
            this.Controls.Add(this.dgvLoans);
            this.Controls.Add(this.btnExit);
            this.Controls.Add(this.btnMainPage);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.btnRegisterLoan);
            this.Controls.Add(this.chkIsReturned);
            this.Controls.Add(this.dtpReturnDate);
            this.Controls.Add(this.dtpLoanDate);
            this.Controls.Add(this.cmbMembers);
            this.Controls.Add(this.cmbBooks);
            this.Controls.Add(this.label1);
            this.Font = new System.Drawing.Font("A Iranian Sans", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(178)));
            this.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.Name = "RegisterLoanForm";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Load += new System.EventHandler(this.RegisterLoanForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvLoans)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ComboBox cmbBooks;
        private System.Windows.Forms.ComboBox cmbMembers;
        private System.Windows.Forms.DateTimePicker dtpLoanDate;
        private System.Windows.Forms.DateTimePicker dtpReturnDate;
        private System.Windows.Forms.CheckBox chkIsReturned;
        private System.Windows.Forms.Button btnRegisterLoan;
        private System.Windows.Forms.Button btnCancel;
        private System.Windows.Forms.Button btnExit;
        private System.Windows.Forms.Button btnMainPage;
        private System.Windows.Forms.DataGridView dgvLoans;
        private System.Windows.Forms.Button btnDeleteLoan;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
    }
}