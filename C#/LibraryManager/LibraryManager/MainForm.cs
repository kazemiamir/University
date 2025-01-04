using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace LibraryManager
{
    public partial class MainForm : Form
    {
        // سازنده فرم اصلی
        public MainForm()
        {
            InitializeComponent();
        }

        // رویداد بارگذاری فرم اصلی
        private void MainForm_Load(object sender, EventArgs e)
        {
            // اینجا می‌توانید کدهای مورد نیاز هنگام بارگذاری فرم را قرار دهید
        }

        // رویداد کلیک برای دکمه ثبت امانت
        private void BtnRegisterLoan_Click(object sender, EventArgs e)
        {
            // باز کردن فرم ثبت امانت
            RegisterLoanForm registerLoanForm = new RegisterLoanForm();
            registerLoanForm.ShowDialog();
        }

        // رویداد کلیک برای دکمه مدیریت کتاب‌ها
        private void BtnManageBooks_Click(object sender, EventArgs e)
        {
            // باز کردن فرم مدیریت کتاب‌ها
            ManageBooksForm manageBooksForm = new ManageBooksForm();
            manageBooksForm.ShowDialog();
        }

        // رویداد کلیک برای دکمه مدیریت کاربران
        private void BtnManageUsers_Click(object sender, EventArgs e)
        {
            // باز کردن فرم مدیریت کاربران
            ManageMembersForm ManageMembersForm = new ManageMembersForm();
            ManageMembersForm.ShowDialog();
        }

        // رویداد کلیک برای دکمه خروج از حساب کاربری
        private void BtnLogout_Click(object sender, EventArgs e)
        {
            // نمایش پیغام تایید خروج از برنامه
            DialogResult result = MessageBox.Show("آیا مطمئن هستید که می‌خواهید از برنامه خارج شوید؟", "تایید خروج", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

            if (result == DialogResult.Yes)
            {
                // بستن برنامه در صورت تایید خروج
                Application.Exit();
            }
        }

    }
}
