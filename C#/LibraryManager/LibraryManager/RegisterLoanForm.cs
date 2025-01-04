using System;
using System.Data;
using System.Data.OleDb;
using System.Windows.Forms;

namespace LibraryManager
{
    public partial class RegisterLoanForm : Form
    {
        private OleDbConnection connection;

        public RegisterLoanForm()
        {
            InitializeComponent();
            connection = DatabaseManager.GetConnection();
        }

        private void RegisterLoanForm_Load(object sender, EventArgs e)
        {
            LoadBooks();
            LoadMembers();
            LoadLoans();
        }

        private void LoadBooks()
        {
            try
            {
                cmbBooks.Items.Clear();
                DatabaseManager.OpenConnection();

                string query = "SELECT BookID, Title FROM Books"; // تغییر BookTitle به Title
                using (OleDbCommand command = new OleDbCommand(query, connection))
                using (OleDbDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        cmbBooks.Items.Add(new CustomComboBoxItem
                        {
                            Text = reader["Title"].ToString(), // تغییر BookTitle به Title
                            Value = reader["BookID"].ToString()
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("خطا در بارگذاری کتاب‌ها: " + ex.Message);
            }
            finally
            {
                DatabaseManager.CloseConnection();
            }
        }

        private void LoadMembers()
        {
            try
            {
                cmbMembers.Items.Clear();
                DatabaseManager.OpenConnection();

                string query = "SELECT MemberID, MemberName FROM Members";
                using (OleDbCommand command = new OleDbCommand(query, connection))
                using (OleDbDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        cmbMembers.Items.Add(new CustomComboBoxItem
                        {
                            Text = reader["MemberName"].ToString(),
                            Value = reader["MemberID"].ToString()
                        });
                    }
                }
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

        private void LoadLoans()
        {
            try
            {
                DatabaseManager.OpenConnection();
                string query = "SELECT Loans.LoanID, Books.Title, Members.MemberName, Loans.LoanDate, Loans.ReturnDate, Loans.IsReturned " +
                               "FROM (Loans INNER JOIN Books ON Loans.BookID = Books.BookID) " +
                               "INNER JOIN Members ON Loans.MemberID = Members.MemberID"; // تغییر Books.BookTitle به Books.Title

                OleDbDataAdapter adapter = new OleDbDataAdapter(query, connection);
                DataTable dataTable = new DataTable();
                adapter.Fill(dataTable);
                dgvLoans.DataSource = dataTable;
            }
            catch (Exception ex)
            {
                MessageBox.Show("خطا در بارگذاری امانت‌ها: " + ex.Message);
            }
            finally
            {
                DatabaseManager.CloseConnection();
            }
        }

        private void cmbBooks_SelectedIndexChanged(object sender, EventArgs e)
        {
           
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            
        }
        private bool IsLoanExists(string bookId, string memberId)
        {
            try
            {
                // دریافت اتصال
                var connection = DatabaseManager.GetConnection();

                // باز کردن اتصال
                DatabaseManager.OpenConnection();

                // دستور SQL برای بررسی وجود امانت
                string query = "SELECT COUNT(*) FROM Loans WHERE BookID = ? AND MemberID = ? AND IsReturned = False";

                using (var command = new OleDbCommand(query, connection))
                {
                    // افزودن پارامترها
                    command.Parameters.AddWithValue("?", bookId);
                    command.Parameters.AddWithValue("?", memberId);

                    // اجرای دستور و دریافت تعداد
                    int count = (int)command.ExecuteScalar();

                    // اگر تعداد بیشتر از صفر باشد، امانت وجود دارد
                    return count > 0;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("خطا در بررسی وجود امانت: " + ex.Message);
                return false;
            }
            finally
            {
                // بستن اتصال
                DatabaseManager.CloseConnection();
            }
        }


        private void btnRegisterLoan_Click(object sender, EventArgs e)
        {
            if (cmbBooks.SelectedItem == null || cmbMembers.SelectedItem == null)
            {
                MessageBox.Show("لطفاً یک کتاب و یک عضو را انتخاب کنید.", "خطا", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            if (dtpLoanDate.Value == DateTime.MinValue || dtpReturnDate.Value == DateTime.MinValue)
            {
                MessageBox.Show("لطفاً تاریخ امانت و تاریخ بازگشت را انتخاب کنید.", "خطا", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            var selectedBook = (CustomComboBoxItem)cmbBooks.SelectedItem;
            var selectedMember = (CustomComboBoxItem)cmbMembers.SelectedItem;
            string bookId = selectedBook.Value;
            string memberId = selectedMember.Value;
            DateTime loanDate = dtpLoanDate.Value;
            DateTime returnDate = dtpReturnDate.Value;
            bool isReturned = chkIsReturned.Checked;

            // بررسی وجود امانت با ترکیب کتاب و عضو
            if (IsLoanExists(bookId, memberId))
            {
                MessageBox.Show("این کتاب قبلاً توسط این عضو امانت گرفته شده است و هنوز برگردانده نشده است.", "خطا", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            try
            {
                string query = "INSERT INTO Loans (BookID, MemberID, LoanDate, ReturnDate, IsReturned) VALUES (?, ?, ?, ?, ?)";
                using (OleDbCommand command = new OleDbCommand(query, connection))
                {
                    command.Parameters.AddWithValue("?", bookId);
                    command.Parameters.AddWithValue("?", memberId);
                    command.Parameters.AddWithValue("?", loanDate);
                    command.Parameters.AddWithValue("?", returnDate);
                    command.Parameters.AddWithValue("?", isReturned);

                    DatabaseManager.OpenConnection();
                    command.ExecuteNonQuery();
                }

                MessageBox.Show("امانت با موفقیت ثبت شد.", "موفقیت", MessageBoxButtons.OK, MessageBoxIcon.Information);
                LoadLoans();
            }
            catch (Exception ex)
            {
                MessageBox.Show("خطا در ثبت امانت: " + ex.Message, "خطا", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                DatabaseManager.CloseConnection();
            }
        }




        private void btnCancel_Click(object sender, EventArgs e)
        {
            cmbBooks.SelectedIndex = -1;
            cmbMembers.SelectedIndex = -1;
            dtpLoanDate.Value = DateTime.Now;
            dtpReturnDate.Value = DateTime.Now;
            chkIsReturned.Checked = false;
        }

        private void btnMainPage_Click(object sender, EventArgs e)
        {
            this.Hide();
            MainForm mainForm = new MainForm();
            mainForm.Show();
        }

        private void btnExit_Click(object sender, EventArgs e)
        {
            DialogResult result = MessageBox.Show("آیا مطمئن هستید که می‌خواهید از برنامه خارج شوید؟", "خروج", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

            if (result == DialogResult.Yes)
            {
                Application.Exit();
            }
        }

        private void btnDeleteLoan_Click(object sender, EventArgs e)
        {
            if (dgvLoans.SelectedRows.Count == 0)
            {
                MessageBox.Show("لطفاً یک سطر را انتخاب کنید.", "خطا", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            var selectedRow = dgvLoans.SelectedRows[0];
            int loanId = Convert.ToInt32(selectedRow.Cells["LoanID"].Value);

            try
            {
                DatabaseManager.OpenConnection();
                string query = "DELETE FROM Loans WHERE LoanID = ?";
                using (OleDbCommand command = new OleDbCommand(query, connection))
                {
                    command.Parameters.AddWithValue("?", loanId);
                    command.ExecuteNonQuery();
                }

                MessageBox.Show("امانت با موفقیت حذف شد.", "موفقیت", MessageBoxButtons.OK, MessageBoxIcon.Information);
                LoadLoans();
            }
            catch (Exception ex)
            {
                MessageBox.Show("خطا در حذف امانت: " + ex.Message, "خطا", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                DatabaseManager.CloseConnection();
            }
        }

    }

    public class CustomComboBoxItem
    {
        public string Text { get; set; }
        public string Value { get; set; }

        public override string ToString()
        {
            return Text;
        }
    }
}
