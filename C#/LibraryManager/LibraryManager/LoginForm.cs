using System;
using System.Data.OleDb;
using System.Drawing;
using System.Windows.Forms;

namespace LibraryManager
{
    public partial class LoginForm : Form
    {
        public LoginForm()
        {
            InitializeComponent();

            // ثبت رویداد برای زمان نمایش فرم
            this.Shown += new EventHandler(LoginForm_Shown);

            // ثبت رویداد KeyDown برای تکست‌باکس‌ها
            txtUsername.KeyDown += new KeyEventHandler(TxtFields_KeyDown);
            txtPassword.KeyDown += new KeyEventHandler(TxtFields_KeyDown);
        }

        // تنظیم فوکوس روی تکست باکس نام کاربری پس از نمایش فرم
        private void LoginForm_Shown(object sender, EventArgs e)
        {
            txtUsername.Focus(); // فوکوس به طور خودکار روی فیلد نام کاربری
        }

        private void LoginForm_Load(object sender, EventArgs e)
        {
            txtUsername.Focus(); // فوکوس به طور خودکار روی فیلد نام کاربری هنگام بارگذاری فرم
        }

        // رویداد KeyDown برای تکست‌باکس‌ها
        private void TxtFields_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                e.SuppressKeyPress = true; // جلوگیری از صدای "دینگ"
                this.SelectNextControl((Control)sender, true, true, true, true); // جابه‌جایی فوکوس به کنترل بعدی
            }
        }

        // سایر متدهای موجود در فرم...
        // رویداد کلیک روی لینک ثبت‌نام
        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            SignUpForm signUpForm = new SignUpForm();

            // مخفی کردن فرم فعلی
            this.Hide();

            // باز کردن فرم ثبت‌نام به صورت مودال (تا بسته شدن فرم)
            signUpForm.ShowDialog();

            // بستن فرم ورود پس از بسته شدن فرم ثبت‌نام
            this.Close();
        }

        // رویداد بستن فرم ورود
        private void LoginForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            this.Hide(); // مخفی کردن فرم به جای بستن آن
        }

        // رویداد ورود موس به تصویر
        private void pictureBox2_MouseEnter(object sender, EventArgs e)
        {
            pictureBox2.BackColor = Color.Red; // تغییر رنگ پس‌زمینه به قرمز هنگام ورود موس
        }

        // رویداد خروج موس از تصویر
        private void pictureBox2_MouseLeave(object sender, EventArgs e)
        {
            pictureBox2.BackColor = Color.Transparent; // بازگشت رنگ پس‌زمینه به حالت اولیه
        }

        // رویداد کلیک بر روی تصویر برای خروج از برنامه
        private void pictureBox2_Click(object sender, EventArgs e)
        {
            var result = MessageBox.Show("آیا مطمئن هستید که می‌خواهید از برنامه خارج شوید؟", "تأیید خروج", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

            if (result == DialogResult.Yes)
            {
                Application.Exit(); // بستن برنامه
            }
        }

        // دریافت رشته اتصال به دیتابیس
        private string GetConnectionString()
        {
            // مسیر دیتابیس در پوشه خروجی پروژه
            string databasePath = System.IO.Path.Combine(Application.StartupPath, "LibraryManager.accdb");
            return $"Provider=Microsoft.ACE.OLEDB.12.0;Data Source={databasePath};"; // بازگشت رشته اتصال
        }

        // رویداد کلیک بر روی دکمه ورود
        private void btnLogin_Click(object sender, EventArgs e)
        {
            // دریافت مقادیر نام کاربری و رمز عبور از تکست باکس‌ها
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            // بررسی اینکه نام کاربری یا رمز عبور خالی نباشد
            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                MessageBox.Show("لطفاً نام کاربری و رمز عبور را وارد کنید", "خطا", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            try
            {
                // اتصال به دیتابیس
                using (OleDbConnection connect = new OleDbConnection(GetConnectionString()))
                {
                    connect.Open(); // باز کردن اتصال

                    // بررسی وجود نام کاربری در دیتابیس
                    string checkUsernameQuery = "SELECT COUNT(*) FROM Users WHERE Username = ?";
                    OleDbCommand usernameCmd = new OleDbCommand(checkUsernameQuery, connect);
                    usernameCmd.Parameters.AddWithValue("@Username", username); // افزودن پارامتر نام کاربری
                    int usernameCount = (int)usernameCmd.ExecuteScalar(); // اجرای دستور و دریافت تعداد

                    if (usernameCount == 0)
                    {
                        MessageBox.Show("نام کاربری وجود ندارد", "خطا", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return;
                    }

                    // بررسی رمز عبور وارد شده
                    string checkPasswordQuery = "SELECT COUNT(*) FROM Users WHERE Username = ? AND Password = ?";
                    OleDbCommand passwordCmd = new OleDbCommand(checkPasswordQuery, connect);
                    passwordCmd.Parameters.AddWithValue("@Username", username); // افزودن پارامتر نام کاربری
                    passwordCmd.Parameters.AddWithValue("@Password", password); // افزودن پارامتر رمز عبور
                    int passwordCount = (int)passwordCmd.ExecuteScalar(); // اجرای دستور و دریافت تعداد

                    if (passwordCount == 0)
                    {
                        MessageBox.Show("رمز عبور اشتباه است", "خطا", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return;
                    }

                    // اگر همه چیز صحیح بود، ورود موفق
                    MessageBox.Show("ورود موفقیت‌آمیز بود", "موفقیت", MessageBoxButtons.OK, MessageBoxIcon.Information);

                    // مخفی کردن فرم ورود و نمایش فرم اصلی
                    this.Hide();
                    MainForm mainForm = new MainForm();
                    mainForm.ShowDialog(); // نمایش فرم اصلی به صورت مودال
                    this.Close(); // بستن فرم ورود
                }
            }
            catch (Exception ex)
            {
                // در صورت بروز خطا در اتصال به دیتابیس
                MessageBox.Show($"خطا در اتصال به دیتابیس: {ex.Message}", "خطا", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
}
