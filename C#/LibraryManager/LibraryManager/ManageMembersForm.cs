using System;
using System.Data;
using System.Data.OleDb;
using System.Windows.Forms;

namespace LibraryManager
{
    public partial class ManageMembersForm : Form
    {
        private OleDbConnection connection;

        // سازنده فرم مدیریت اعضا
        public ManageMembersForm()
        {
            InitializeComponent();
            connection = DatabaseManager.GetConnection();
        }

        // رویداد بارگذاری فرم
        private void ManageMembersForm_Load(object sender, EventArgs e)
        {
            LoadMembers();
        }

        // بارگذاری اعضا از دیتابیس
        private void LoadMembers()
        {
            try
            {
                DatabaseManager.OpenConnection();
                string query = "SELECT MemberID, MemberName, MemberLastName, MemberPhone, MemberNationalID, MembershipDate FROM Members";
                OleDbDataAdapter adapter = new OleDbDataAdapter(query, connection);
                DataTable dataTable = new DataTable();
                adapter.Fill(dataTable);
                dataGridView1.DataSource = dataTable;
            }
            catch (Exception ex)
            {
                MessageBox.Show("خطا در بارگذاری اعضا: " + ex.Message);
            }
            finally
            {
                DatabaseManager.CloseConnection();
            }
        }

        // رویداد کلیک دکمه افزودن عضو
        private void btnAddMember_Click(object sender, EventArgs e)
        {
            try
            {
                string name = txtName.Text.Trim();
                string family = txtFamily.Text.Trim();
                string phone = txtPhone.Text.Trim();
                string nationalCode = txtNationalCode.Text.Trim();
                DateTime joinDate = datePickerJoinDate.Value;

                // بررسی کامل بودن فیلدها
                if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(family) || string.IsNullOrEmpty(phone) || string.IsNullOrEmpty(nationalCode))
                {
                    MessageBox.Show("لطفاً همه موارد را به درستی وارد کنید.", "خطا", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                string query = "INSERT INTO Members (MemberName, MemberLastName, MemberPhone, MemberNationalID, MembershipDate) VALUES (?, ?, ?, ?, ?)";
                using (OleDbCommand command = new OleDbCommand(query, connection))
                {
                    command.Parameters.AddWithValue("?", name);
                    command.Parameters.AddWithValue("?", family);
                    command.Parameters.AddWithValue("?", phone);
                    command.Parameters.AddWithValue("?", nationalCode);
                    command.Parameters.AddWithValue("?", joinDate);

                    DatabaseManager.OpenConnection();
                    command.ExecuteNonQuery();
                    DatabaseManager.CloseConnection();

                    MessageBox.Show("عضو با موفقیت اضافه شد.", "موفقیت", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }

                // پاکسازی فیلدها
                txtName.Clear();
                txtFamily.Clear();
                txtPhone.Clear();
                txtNationalCode.Clear();
                datePickerJoinDate.Value = DateTime.Now;

                LoadMembers();
            }
            catch (Exception ex)
            {
                MessageBox.Show("خطا در افزودن عضو: " + ex.Message, "خطا", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        // رویداد کلیک بر روی سلول‌های دیتاگراید
        private void dataGridView1_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = dataGridView1.Rows[e.RowIndex];
                txtName.Text = row.Cells["MemberName"].Value?.ToString() ?? string.Empty;
                txtFamily.Text = row.Cells["MemberLastName"].Value?.ToString() ?? string.Empty;
                txtPhone.Text = row.Cells["MemberPhone"].Value?.ToString() ?? string.Empty;
                txtNationalCode.Text = row.Cells["MemberNationalID"].Value?.ToString() ?? string.Empty;

                if (row.Cells["MembershipDate"].Value != null && DateTime.TryParse(row.Cells["MembershipDate"].Value.ToString(), out DateTime membershipDate))
                {
                    datePickerJoinDate.Value = membershipDate;
                }
                else
                {
                    datePickerJoinDate.Value = DateTime.Now;
                }
            }
        }

        // رویداد کلیک دکمه ویرایش عضو
        private void btnEditMember_Click(object sender, EventArgs e)
        {
            try
            {
                string memberId = dataGridView1.CurrentRow.Cells["MemberID"].Value.ToString();
                string name = txtName.Text.Trim();
                string family = txtFamily.Text.Trim();
                string phone = txtPhone.Text.Trim();
                string nationalCode = txtNationalCode.Text.Trim();
                string joinDate = datePickerJoinDate.Value.ToString("yyyy-MM-dd");

                // بررسی کامل بودن فیلدها
                if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(family) || string.IsNullOrEmpty(phone) || string.IsNullOrEmpty(nationalCode))
                {
                    MessageBox.Show("لطفاً همه فیلدها را به درستی پر کنید.", "خطا", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                string query = "UPDATE Members SET MemberName = ?, MemberLastName = ?, MemberPhone = ?, MemberNationalID = ?, MembershipDate = ? WHERE MemberID = ?";
                using (OleDbCommand command = new OleDbCommand(query, DatabaseManager.GetConnection()))
                {
                    command.Parameters.AddWithValue("?", name);
                    command.Parameters.AddWithValue("?", family);
                    command.Parameters.AddWithValue("?", phone);
                    command.Parameters.AddWithValue("?", nationalCode);
                    command.Parameters.AddWithValue("?", joinDate);
                    command.Parameters.AddWithValue("?", memberId);

                    DatabaseManager.OpenConnection();
                    command.ExecuteNonQuery();
                    DatabaseManager.CloseConnection();

                    MessageBox.Show("عضو با موفقیت ویرایش شد.", "موفقیت", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }

                LoadMembers();
            }
            catch (Exception ex)
            {
                MessageBox.Show("خطا در ویرایش عضو: " + ex.Message, "خطا", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        // رویداد کلیک دکمه خروج
        private void btnExit_Click(object sender, EventArgs e)
        {
            DialogResult result = MessageBox.Show("آیا مطمئن هستید که می‌خواهید از برنامه خارج شوید؟", "خروج", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

            if (result == DialogResult.Yes)
            {
                Application.Exit();
            }
        }

        // رویداد کلیک دکمه بازگشت به صفحه اصلی
        private void btnMainPage_Click(object sender, EventArgs e)
        {
            this.Hide();
            MainForm mainForm = new MainForm();
            mainForm.Show();
        }

        // رویداد کلیک دکمه حذف عضو
        private void btnDeleteMember_Click(object sender, EventArgs e)
        {
            try
            {
                // بررسی اینکه کاربری انتخاب شده باشد
                if (dataGridView1.CurrentRow == null)
                {
                    MessageBox.Show("لطفاً یک کاربر را انتخاب کنید.", "خطا", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                // دریافت MemberID از سطر انتخاب‌شده
                string memberId = dataGridView1.CurrentRow.Cells["MemberID"].Value.ToString();

                // نمایش پیغام تأیید برای حذف
                DialogResult result = MessageBox.Show("آیا مطمئن هستید که می‌خواهید این عضو را حذف کنید؟",
                                                      "حذف عضو",
                                                      MessageBoxButtons.YesNo,
                                                      MessageBoxIcon.Question);

                if (result == DialogResult.Yes)
                {
                    // حذف کاربر از دیتابیس
                    string query = "DELETE FROM Members WHERE MemberID = ?";
                    using (OleDbCommand command = new OleDbCommand(query, DatabaseManager.GetConnection()))
                    {
                        command.Parameters.AddWithValue("?", memberId);

                        DatabaseManager.OpenConnection();
                        command.ExecuteNonQuery();
                        DatabaseManager.CloseConnection();

                        MessageBox.Show("عضو با موفقیت حذف شد.", "موفقیت", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }

                    // به‌روزرسانی لیست اعضا
                    LoadMembers();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("خطا در حذف عضو: " + ex.Message, "خطا", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void txtName_KeyDown(object sender, KeyEventArgs e)
        {

            {
                if (e.KeyCode == Keys.Enter)
                {
                    e.SuppressKeyPress = true; // جلوگیری از صدای "دینگ"
                    this.SelectNextControl((Control)sender, true, true, true, true); // جابه‌جایی فوکوس به کنترل بعدی
                }
            }
        }

        private void txtFamily_KeyDown(object sender, KeyEventArgs e)
        {

            {
                if (e.KeyCode == Keys.Enter)
                {
                    e.SuppressKeyPress = true; // جلوگیری از صدای "دینگ"
                    this.SelectNextControl((Control)sender, true, true, true, true); // جابه‌جایی فوکوس به کنترل بعدی
                }
            }
        }

        private void txtPhone_KeyDown(object sender, KeyEventArgs e)
        {

            {
                if (e.KeyCode == Keys.Enter)
                {
                    e.SuppressKeyPress = true; // جلوگیری از صدای "دینگ"
                    this.SelectNextControl((Control)sender, true, true, true, true); // جابه‌جایی فوکوس به کنترل بعدی
                }
            }
        }

        private void txtNationalCode_KeyDown(object sender, KeyEventArgs e)
        {

            {
                if (e.KeyCode == Keys.Enter)
                {
                    e.SuppressKeyPress = true; // جلوگیری از صدای "دینگ"
                    this.SelectNextControl((Control)sender, true, true, true, true); // جابه‌جایی فوکوس به کنترل بعدی
                }
            }
        }

        private void btnAddMember_KeyDown(object sender, KeyEventArgs e)
        {

            {
                if (e.KeyCode == Keys.Enter)
                {
                    e.SuppressKeyPress = true; // جلوگیری از صدای "دینگ"
                    this.SelectNextControl((Control)sender, true, true, true, true); // جابه‌جایی فوکوس به کنترل بعدی
                }
            }
        }

        private void datePickerJoinDate_KeyDown(object sender, KeyEventArgs e)
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

    // کلاس مدیریت دیتابیس
    public static class DatabaseManager
    {
        private static OleDbConnection connection;

        // دریافت شیء اتصال به دیتابیس
        public static OleDbConnection GetConnection()
        {
            if (connection == null)
            {
                connection = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=LibraryManager.accdb");
            }
            return connection;
        }

        // باز کردن اتصال به دیتابیس
        public static void OpenConnection()
        {
            if (connection == null)
                connection = GetConnection();

            if (connection.State == ConnectionState.Closed)
                connection.Open();
        }

        // بستن اتصال به دیتابیس
        public static void CloseConnection()
        {
            if (connection != null && connection.State == ConnectionState.Open)
            {
                connection.Close();
            }
        }
    }
}
