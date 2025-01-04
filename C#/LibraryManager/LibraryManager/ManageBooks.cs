using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.OleDb;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace LibraryManager
{
    public partial class ManageBooksForm : Form
    {
        public ManageBooksForm()
        {
            // مقداردهی اولیه فرم
            InitializeComponent();
        }

        private void ManageBooksForm_Load(object sender, EventArgs e)
        {
            // بارگذاری لیست کتاب‌ها هنگام لود فرم
            LoadBooks();
        }

        private void LoadBooks()
        {
            try
            {
                // دریافت اتصال از مدیریت پایگاه داده
                var connection = UniSys.DatabaseManager.GetConnection();

                // باز کردن اتصال
                UniSys.DatabaseManager.OpenConnection();

                // دستور SQL برای دریافت داده‌های کتاب‌ها
                string query = "SELECT BookID, Title, Author, Genre, PublicationYear, Language, Publisher FROM Books";

                using (var adapter = new OleDbDataAdapter(query, connection))
                {
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);

                    // نمایش داده‌ها در DataGridView
                    dgvBooks.DataSource = dataTable;
                }
            }
            catch (Exception ex)
            {
                // نمایش پیام خطا در صورت وجود مشکل
                MessageBox.Show("خطا در بارگذاری کتاب‌ها: " + ex.Message);
            }
            finally
            {
                // بستن اتصال به پایگاه داده
                UniSys.DatabaseManager.CloseConnection();
            }
        }

        private bool IsBookTitleExists(string title)
        {
            try
            {
                // دریافت اتصال از مدیریت پایگاه داده
                var connection = UniSys.DatabaseManager.GetConnection();

                // باز کردن اتصال
                UniSys.DatabaseManager.OpenConnection();

                // دستور SQL برای بررسی وجود کتاب با عنوان مشخص
                string query = "SELECT COUNT(*) FROM Books WHERE Title = ?";

                using (var command = new OleDbCommand(query, connection))
                {
                    // افزودن پارامتر برای عنوان کتاب
                    command.Parameters.AddWithValue("?", title);

                    // اجرای دستور و دریافت تعداد کتاب‌ها
                    int count = (int)command.ExecuteScalar();

                    // بررسی اگر تعداد بیشتر از صفر باشد، کتاب وجود دارد
                    return count > 0;
                }
            }
            catch (Exception ex)
            {
                // نمایش پیام خطا در صورت وجود مشکل
                MessageBox.Show("خطا در بررسی وجود کتاب: " + ex.Message);
                return false;
            }
            finally
            {
                // بستن اتصال به پایگاه داده
                UniSys.DatabaseManager.CloseConnection();
            }
        }

        private void btnAddBook_Click(object sender, EventArgs e)
        {
            // بررسی اینکه همه تکست‌باکس‌ها پر شده باشند
            if (string.IsNullOrWhiteSpace(txtBookTitle.Text) ||
                string.IsNullOrWhiteSpace(txtAuthor.Text) ||
                string.IsNullOrWhiteSpace(txtGenre.Text) ||
                string.IsNullOrWhiteSpace(txtYear.Text) ||
                string.IsNullOrWhiteSpace(txtLanguage.Text) ||
                string.IsNullOrWhiteSpace(txtPublisher.Text))
            {
                MessageBox.Show("لطفاً همه فیلدها را پر کنید.", "خطا", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return; // خروج از متد اگر فیلدی خالی باشد
            }

            // بررسی وجود کتاب با همان عنوان قبل از اضافه کردن
            if (IsBookTitleExists(txtBookTitle.Text))
            {
                MessageBox.Show("کتاب با این عنوان قبلاً ثبت شده است.", "خطا", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            // بررسی سال انتشار
            if (!int.TryParse(txtYear.Text, out int year) || txtYear.Text.Length != 4)
            {
                MessageBox.Show("سال انتشار باید یک عدد چهاررقمی باشد.", "خطا", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            try
            {
                // دریافت اتصال از مدیریت پایگاه داده
                var connection = UniSys.DatabaseManager.GetConnection();

                // باز کردن اتصال
                UniSys.DatabaseManager.OpenConnection();

                // دستور SQL برای افزودن کتاب جدید
                string query = "INSERT INTO Books ([Title], [Author], [Genre], [PublicationYear], [Language], [Publisher]) VALUES (@Title, @Author, @Genre, @PublicationYear, @Language, @Publisher)";

                using (var command = new OleDbCommand(query, connection))
                {
                    // افزودن مقادیر به پارامترهای دستور SQL
                    command.Parameters.AddWithValue("@Title", txtBookTitle.Text);
                    command.Parameters.AddWithValue("@Author", txtAuthor.Text);
                    command.Parameters.AddWithValue("@Genre", txtGenre.Text);
                    command.Parameters.AddWithValue("@PublicationYear", year);
                    command.Parameters.AddWithValue("@Language", txtLanguage.Text);
                    command.Parameters.AddWithValue("@Publisher", txtPublisher.Text);

                    // اجرای دستور SQL
                    command.ExecuteNonQuery();

                    MessageBox.Show("کتاب با موفقیت اضافه شد!");

                    // به‌روزرسانی لیست کتاب‌ها
                    LoadBooks();
                }
            }
            catch (Exception ex)
            {
                // نمایش پیام خطا در صورت وجود مشکل
                MessageBox.Show("خطا: " + ex.Message);
            }
            finally
            {
                // بستن اتصال به پایگاه داده
                UniSys.DatabaseManager.CloseConnection();
            }
        }


        private void btnDeleteBook_Click(object sender, EventArgs e)
        {
            // بررسی اینکه حداقل یک سطر انتخاب شده باشد
            if (dgvBooks.SelectedRows.Count == 0)
            {
                MessageBox.Show("لطفاً یک سطر را انتخاب کنید.", "خطا", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            // دریافت شناسه کتاب از سطر انتخاب شده
            var selectedRow = dgvBooks.SelectedRows[0];
            int bookId = Convert.ToInt32(selectedRow.Cells["BookID"].Value);

            try
            {
                // دریافت اتصال از مدیریت پایگاه داده
                var connection = UniSys.DatabaseManager.GetConnection();

                // باز کردن اتصال
                UniSys.DatabaseManager.OpenConnection();

                // دستور SQL برای حذف کتاب با شناسه مشخص
                string query = "DELETE FROM Books WHERE BookID = ?";

                using (var command = new OleDbCommand(query, connection))
                {
                    // افزودن پارامتر برای شناسه کتاب
                    command.Parameters.AddWithValue("?", bookId);

                    // اجرای دستور SQL
                    command.ExecuteNonQuery();
                }

                MessageBox.Show("کتاب با موفقیت حذف شد!");

                // به‌روزرسانی لیست کتاب‌ها
                LoadBooks();
            }
            catch (Exception ex)
            {
                // نمایش پیام خطا در صورت وجود مشکل
                MessageBox.Show("خطا در حذف کتاب: " + ex.Message);
            }
            finally
            {
                // بستن اتصال به پایگاه داده
                UniSys.DatabaseManager.CloseConnection();
            }
        }

        private void btnEditBook_Click(object sender, EventArgs e)
        {
            // بررسی اینکه حداقل یک سطر انتخاب شده باشد
            if (dgvBooks.SelectedRows.Count == 0)
            {
                MessageBox.Show("لطفاً یک سطر را انتخاب کنید.", "خطا", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            // دریافت شناسه کتاب از سطر انتخاب شده
            var selectedRow = dgvBooks.SelectedRows[0];
            int bookId = Convert.ToInt32(selectedRow.Cells["BookID"].Value);

            try
            {
                // دریافت اتصال از مدیریت پایگاه داده
                var connection = UniSys.DatabaseManager.GetConnection();

                // باز کردن اتصال
                UniSys.DatabaseManager.OpenConnection();

                // دستور SQL برای ویرایش اطلاعات کتاب
                string query = "UPDATE Books SET [Title] = ?, [Author] = ?, [Genre] = ?, [PublicationYear] = ?, [Language] = ?, [Publisher] = ? WHERE [BookID] = ?";

                using (var command = new OleDbCommand(query, connection))
                {
                    // افزودن مقادیر به پارامترهای دستور SQL
                    command.Parameters.AddWithValue("?", txtBookTitle.Text);
                    command.Parameters.AddWithValue("?", txtAuthor.Text);
                    command.Parameters.AddWithValue("?", txtGenre.Text);

                    int year;
                    // بررسی و افزودن مقدار معتبر برای سال انتشار
                    if (int.TryParse(txtYear.Text, out year))
                    {
                        command.Parameters.AddWithValue("?", year);
                    }
                    else
                    {
                        MessageBox.Show("سال انتشار باید یک عدد معتبر باشد.");
                        return;
                    }

                    command.Parameters.AddWithValue("?", txtLanguage.Text);
                    command.Parameters.AddWithValue("?", txtPublisher.Text);
                    command.Parameters.AddWithValue("?", bookId);

                    // اجرای دستور SQL
                    command.ExecuteNonQuery();
                }

                MessageBox.Show("کتاب با موفقیت ویرایش شد!");

                // به‌روزرسانی لیست کتاب‌ها
                LoadBooks();
            }
            catch (Exception ex)
            {
                // نمایش پیام خطا در صورت وجود مشکل
                MessageBox.Show("خطا در ویرایش کتاب: " + ex.Message);
            }
            finally
            {
                // بستن اتصال به پایگاه داده
                UniSys.DatabaseManager.CloseConnection();
            }
        }

        private void btnExit_Click(object sender, EventArgs e)
        {
            // نمایش پیام تأیید خروج از برنامه
            DialogResult result = MessageBox.Show("آیا مطمئن هستید که می‌خواهید از برنامه خارج شوید؟", "خروج", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

            if (result == DialogResult.Yes) // اگر کاربر گزینه "بله" را انتخاب کند
            {
                Application.Exit(); // خروج از برنامه
            }
            // اگر کاربر گزینه "خیر" را انتخاب کند، هیچ عملی انجام نمی‌شود
        }

        private void btnMainPage_Click(object sender, EventArgs e)
        {
            // مخفی کردن فرم فعلی و نمایش صفحه اصلی
            this.Hide();
            MainForm mainForm = new MainForm();
            mainForm.Show();
        }

        private void dgvBooks_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            // بررسی اینکه آیا سطر معتبر انتخاب شده است
            if (e.RowIndex >= 0)
            {
                // دریافت سطر انتخاب شده
                DataGridViewRow row = dgvBooks.Rows[e.RowIndex];

                // پر کردن فیلدهای ورودی با داده‌های سطر انتخاب شده
                txtBookTitle.Text = row.Cells["Title"].Value.ToString();
                txtAuthor.Text = row.Cells["Author"].Value.ToString();
                txtGenre.Text = row.Cells["Genre"].Value.ToString();
                txtYear.Text = row.Cells["PublicationYear"].Value.ToString();
                txtLanguage.Text = row.Cells["Language"].Value.ToString();
                txtPublisher.Text = row.Cells["Publisher"].Value.ToString();
            }
        }

        private void txtBookTitle_KeyDown(object sender, KeyEventArgs e)
        {

            {
                if (e.KeyCode == Keys.Enter)
                {
                    e.SuppressKeyPress = true; // جلوگیری از صدای "دینگ"
                    this.SelectNextControl((Control)sender, true, true, true, true); // جابه‌جایی فوکوس به کنترل بعدی
                }
            }
        }

        private void txtAuthor_KeyDown(object sender, KeyEventArgs e)
        {

            {
                if (e.KeyCode == Keys.Enter)
                {
                    e.SuppressKeyPress = true; // جلوگیری از صدای "دینگ"
                    this.SelectNextControl((Control)sender, true, true, true, true); // جابه‌جایی فوکوس به کنترل بعدی
                }
            }
        }

        private void txtPublisher_KeyDown(object sender, KeyEventArgs e)
        {

            {
                if (e.KeyCode == Keys.Enter)
                {
                    e.SuppressKeyPress = true; // جلوگیری از صدای "دینگ"
                    this.SelectNextControl((Control)sender, true, true, true, true); // جابه‌جایی فوکوس به کنترل بعدی
                }
            }
        }

        private void txtYear_KeyDown(object sender, KeyEventArgs e)
        {

            {
                if (e.KeyCode == Keys.Enter)
                {
                    e.SuppressKeyPress = true; // جلوگیری از صدای "دینگ"
                    this.SelectNextControl((Control)sender, true, true, true, true); // جابه‌جایی فوکوس به کنترل بعدی
                }
            }
        }

        private void txtLanguage_KeyDown(object sender, KeyEventArgs e)
        {

            {
                if (e.KeyCode == Keys.Enter)
                {
                    e.SuppressKeyPress = true; // جلوگیری از صدای "دینگ"
                    this.SelectNextControl((Control)sender, true, true, true, true); // جابه‌جایی فوکوس به کنترل بعدی
                }
            }
        }

        private void txtGenre_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                e.SuppressKeyPress = true; // جلوگیری از صدای "دینگ"
                btnAddBook.Focus(); // انتقال فوکوس به دکمه افزودن کتاب
            }
        }


        private void btnAddBook_KeyDown(object sender, KeyEventArgs e)
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
