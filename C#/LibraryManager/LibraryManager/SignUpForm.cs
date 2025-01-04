using System;
using System.Data.OleDb;
using System.Drawing;
using System.Text.RegularExpressions;
using System.Windows.Forms;

namespace LibraryManager
{
    public partial class SignUpForm : Form
    {
        public SignUpForm()
        {
            InitializeComponent();

            // رویداد بارگذاری فرم را تنظیم می‌کند
            this.Load += new System.EventHandler(this.SignUpForm_Load);

            // رویداد KeyPress برای فعال‌سازی دکمه ثبت‌نام با فشردن کلید Enter
            this.KeyPress += new KeyPressEventHandler(SignUpForm_KeyPress);
        }

        private void SignUpForm_Load(object sender, EventArgs e)
        {
            // تنظیم فوکوس اولیه برای اولین کنترل (نام کامل)
            this.BeginInvoke((MethodInvoker)delegate
            {
                txtFullName.Focus();
            });

            // تنظیم ترتیب TabIndex برای کنترل‌ها
            txtFullName.TabIndex = 0;   // نام کامل
            txtNationalID.TabIndex = 1; // کد ملی
            txtPhoneNumber.TabIndex = 2; // شماره تلفن
            txtUsername.TabIndex = 3;    // نام کاربری
            txtPassword.TabIndex = 4;    // رمز عبور
            txtEmail.TabIndex = 5;       // ایمیل
            btnSignUp.TabIndex = 6;      // دکمه ثبت‌نام
        }

        // بررسی معتبر بودن شماره تلفن با الگوی مشخص
        private bool IsValidPhoneNumber(string phoneNumber)
        {
            string pattern = @"^\d{11}$"; // شماره تلفن باید دقیقاً 10 رقم باشد
            return Regex.IsMatch(phoneNumber, pattern);
        }

        // بررسی معتبر بودن کد ملی با الگوی مشخص
        private bool IsValidNationalID(string nationalID)
        {
            string pattern = @"^\d{10}$"; // کد ملی باید دقیقاً 10 رقم باشد
            return Regex.IsMatch(nationalID, pattern);
        }

        // بررسی معتبر بودن رمز عبور با شرایط امنیتی خاص
        private bool IsValidPassword(string password)
        {
            // رمز عبور باید شامل حداقل یک حرف بزرگ، یک حرف کوچک، یک عدد، یک کاراکتر خاص باشد و حداقل 8 کاراکتر داشته باشد
            string pattern = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$";
            return Regex.IsMatch(password, pattern);
        }

        // بررسی وجود حروف فارسی در متن
        private bool ContainsPersianCharacters(string text)
        {
            string persianPattern = @"[\u0600-\u06FF]"; // محدوده یونیکد حروف فارسی
            return Regex.IsMatch(text, persianPattern);
        }

        // بررسی صحت ورودی‌های فرم
        private bool ValidateInputs()
        {
            // بررسی نام کامل
            if (string.IsNullOrWhiteSpace(txtFullName.Text))
            {
                MessageBox.Show("لطفاً نام کامل خود را وارد کنید.", "خطا", MessageBoxButtons.OK, MessageBoxIcon.Error);
                txtFullName.Focus();
                return false;
            }

            // بررسی کد ملی
            if (string.IsNullOrWhiteSpace(txtNationalID.Text) || !IsValidNationalID(txtNationalID.Text))
            {
                MessageBox.Show("لطفاً یک کد ملی معتبر وارد کنید.", "خطا", MessageBoxButtons.OK, MessageBoxIcon.Error);
                txtNationalID.Focus();
                return false;
            }

            // بررسی شماره تلفن
            if (string.IsNullOrWhiteSpace(txtPhoneNumber.Text) || !IsValidPhoneNumber(txtPhoneNumber.Text))
            {
                MessageBox.Show("لطفاً یک شماره تلفن معتبر وارد کنید.", "خطا", MessageBoxButtons.OK, MessageBoxIcon.Error);
                txtPhoneNumber.Focus();
                return false;
            }

            // بررسی نام کاربری
            if (string.IsNullOrWhiteSpace(txtUsername.Text))
            {
                MessageBox.Show("لطفاً نام کاربری خود را وارد کنید.", "خطا", MessageBoxButtons.OK, MessageBoxIcon.Error);
                txtUsername.Focus();
                return false;
            }

            // بررسی رمز عبور
            if (string.IsNullOrWhiteSpace(txtPassword.Text) || ContainsPersianCharacters(txtPassword.Text) || !IsValidPassword(txtPassword.Text))
            {
                MessageBox.Show("رمز عبور باید حداقل 8 کاراکتر باشد و شامل حروف بزرگ، کوچک، عدد و کاراکتر خاص باشد. همچنین نباید شامل حروف فارسی باشد.", "خطا", MessageBoxButtons.OK, MessageBoxIcon.Error);
                txtPassword.Focus();
                return false;
            }

            return true; // اگر همه ورودی‌ها معتبر باشند
        }

        // رویداد کلیک بر روی دکمه ثبت‌نام
        private void btnSignUp_Click(object sender, EventArgs e)
        {
            if (!ValidateInputs()) return; // اگر ورودی‌ها نامعتبر باشند، متوقف شود

            try
            {
                // ایجاد اتصال به پایگاه داده
                using (OleDbConnection connect = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=LibraryManager.accdb"))
                {
                    connect.Open();

                    // دستور SQL برای درج اطلاعات کاربر جدید
                    using (OleDbCommand com = new OleDbCommand("INSERT INTO [Users] ([FullName], [Username], [NationalID], [Password], [PhoneNumber], [Email]) VALUES (?, ?, ?, ?, ?, ?)", connect))
                    {
                        // افزودن پارامترها به دستور SQL
                        com.Parameters.AddWithValue("@FullName", txtFullName.Text);
                        com.Parameters.AddWithValue("@Username", txtUsername.Text);
                        com.Parameters.AddWithValue("@NationalID", txtNationalID.Text);
                        com.Parameters.AddWithValue("@Password", txtPassword.Text);
                        com.Parameters.AddWithValue("@PhoneNumber", txtPhoneNumber.Text);
                        com.Parameters.AddWithValue("@Email", string.IsNullOrWhiteSpace(txtEmail.Text) ? (object)DBNull.Value : txtEmail.Text);

                        // بررسی نتیجه درج اطلاعات
                        if (com.ExecuteNonQuery() == 1)
                        {
                            MessageBox.Show("ثبت‌نام با موفقیت انجام شد."); // پیام موفقیت
                            LoginForm loginForm = new LoginForm();
                            this.Hide();
                            loginForm.ShowDialog(); // نمایش فرم ورود
                        }
                        else
                        {
                            MessageBox.Show("خطایی رخ داد. لطفاً دوباره تلاش کنید."); // پیام خطا
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // نمایش پیام خطا در صورت بروز استثنا
                MessageBox.Show($"خطا: {ex.Message}", "خطا", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        // رویداد کلیک بر روی لینک ورود
        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            this.Hide(); // فرم ثبت‌نام را مخفی می‌کند
            LoginForm loginForm = new LoginForm();
            loginForm.ShowDialog(); // نمایش فرم ورود
            this.Close(); // فرم ثبت‌نام را می‌بندد
        }

        // رویداد بستن فرم
        private void SignUpForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            this.Hide();
        }

        // تغییر رنگ پس‌زمینه تصویر هنگام ورود ماوس
        private void pictureBox2_MouseEnter(object sender, EventArgs e)
        {
            pictureBox2.BackColor = Color.Red; // تنظیم رنگ قرمز
        }

        // بازگرداندن رنگ پس‌زمینه به حالت اولیه هنگام خروج ماوس
        private void pictureBox2_MouseLeave(object sender, EventArgs e)
        {
            pictureBox2.BackColor = Color.Transparent; // شفاف‌سازی رنگ
        }

        // رویداد کلیک بر روی تصویر خروج
        private void pictureBox2_Click(object sender, EventArgs e)
        {
            // تأیید خروج از برنامه
            var result = MessageBox.Show("آیا مطمئن هستید که می‌خواهید از برنامه خارج شوید؟", "تأیید خروج", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
            if (result == DialogResult.Yes)
            {
                Application.Exit(); // خروج از برنامه
            }
        }

        private void panel1_Paint(object sender, PaintEventArgs e)
        {

        }

        // رویداد KeyPress فرم برای فعال‌سازی دکمه ثبت‌نام با فشردن کلید Enter
        private void SignUpForm_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)Keys.Enter)
            {
                btnSignUp.PerformClick(); // شبیه‌سازی کلیک بر روی دکمه ثبت‌نام
            }
        }

        private void txtFullName_KeyDown(object sender, KeyEventArgs e)

        {
            if (e.KeyCode == Keys.Enter)
            {
                e.SuppressKeyPress = true; // جلوگیری از صدای "دینگ"
                this.SelectNextControl((Control)sender, true, true, true, true); // جابه‌جایی فوکوس به کنترل بعدی
            }
        }

        private void txtNationalID_KeyDown(object sender, KeyEventArgs e)
        {
            {
                if (e.KeyCode == Keys.Enter)
                {
                    e.SuppressKeyPress = true; // جلوگیری از صدای "دینگ"
                    this.SelectNextControl((Control)sender, true, true, true, true); // جابه‌جایی فوکوس به کنترل بعدی
                }
            }
        }

        private void txtPhoneNumber_KeyDown(object sender, KeyEventArgs e)
        {
            {
                if (e.KeyCode == Keys.Enter)
                {
                    e.SuppressKeyPress = true; // جلوگیری از صدای "دینگ"
                    this.SelectNextControl((Control)sender, true, true, true, true); // جابه‌جایی فوکوس به کنترل بعدی
                }
            }
        }

        private void txtUsername_KeyDown(object sender, KeyEventArgs e)
        {
            {
                if (e.KeyCode == Keys.Enter)
                {
                    e.SuppressKeyPress = true; // جلوگیری از صدای "دینگ"
                    this.SelectNextControl((Control)sender, true, true, true, true); // جابه‌جایی فوکوس به کنترل بعدی
                }
            }
        }

        private void txtPassword_KeyDown(object sender, KeyEventArgs e)
        {

            {
                if (e.KeyCode == Keys.Enter)
                {
                    e.SuppressKeyPress = true; // جلوگیری از صدای "دینگ"
                    this.SelectNextControl((Control)sender, true, true, true, true); // جابه‌جایی فوکوس به کنترل بعدی
                }
            }
        }

        private void txtEmail_KeyDown(object sender, KeyEventArgs e)
        {

            {
                if (e.KeyCode == Keys.Enter)
                {
                    e.SuppressKeyPress = true; // جلوگیری از صدای "دینگ"
                    this.SelectNextControl((Control)sender, true, true, true, true); // جابه‌جایی فوکوس به کنترل بعدی
                }
            }
        }
    }
}