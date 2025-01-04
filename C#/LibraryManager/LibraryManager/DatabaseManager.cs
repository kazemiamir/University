using System;
using System.Data;
using System.Data.OleDb;

namespace UniSys
{
    public static class DatabaseManager
    {
        private static OleDbConnection connection = null; // اتصال Singleton به پایگاه داده

        /// <summary>
        /// متد برای دسترسی به اتصال Singleton
        /// </summary>
        /// <returns>شیء اتصال OleDbConnection</returns>
        public static OleDbConnection GetConnection()
        {
            if (connection == null)
            {
                connection = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=LibraryManager.accdb");
            }
            return connection;
        }

        /// <summary>
        /// باز کردن اتصال به پایگاه داده
        /// </summary>
        public static void OpenConnection()
        {
            try
            {
                if (connection == null)
                {
                    connection = GetConnection();
                }

                if (connection.State == ConnectionState.Closed)
                {
                    connection.Open();
                }
            }
            catch (Exception ex)
            {
                throw new Exception("خطا در باز کردن اتصال به دیتابیس: " + ex.Message);
            }
        }

        /// <summary>
        /// بستن اتصال به پایگاه داده و آزادسازی منابع
        /// </summary>
        public static void CloseConnection()
        {
            if (connection != null && connection.State == ConnectionState.Open)
            {
                connection.Dispose(); // آزاد کردن منابع
                connection = null; // حذف ارجاع به اتصال
            }
        }

        /// <summary>
        /// اجرای یک دستور SQL بدون بازگشت نتیجه (مثل INSERT, UPDATE, DELETE)
        /// </summary>
        /// <param name="query">دستور SQL</param>
        public static void ExecuteQuery(string query)
        {
            try
            {
                OpenConnection();

                using (OleDbCommand command = new OleDbCommand(query, connection))
                {
                    command.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                throw new Exception("خطا در اجرای دستور SQL: " + ex.Message);
            }
            finally
            {
                CloseConnection();
            }
        }

        /// <summary>
        /// اجرای یک دستور SQL و بازگشت نتیجه به صورت DataTable (مثل SELECT)
        /// </summary>
        /// <param name="query">دستور SQL</param>
        /// <returns>نتایج کوئری به صورت DataTable</returns>
        public static DataTable GetDataTable(string query)
        {
            try
            {
                OpenConnection();

                using (OleDbDataAdapter adapter = new OleDbDataAdapter(query, connection))
                {
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);
                    return dataTable;
                }
            }
            catch (Exception ex)
            {
                throw new Exception("خطا در اجرای کوئری SELECT: " + ex.Message);
            }
            finally
            {
                CloseConnection();
            }
        }
    }
}
