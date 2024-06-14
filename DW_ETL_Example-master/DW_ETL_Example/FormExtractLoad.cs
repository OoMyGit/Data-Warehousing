using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using MySql.Data.MySqlClient;

namespace DW_ETL_Example
{
    public partial class FormExtractLoad : Form
    {
        MySqlConnection myConnOLTP;
        MySqlCommand myCmdOLTP = new MySqlCommand(); 

        MySqlConnection myConnOLAP;
        MySqlCommand myCmdOLAP = new MySqlCommand();
        MySqlDataAdapter myAdapter;
        DataTable dt;
        string originOLTP;
        bool statConnOLTP = false;
        bool statConnOLAP = false;

        public FormExtractLoad()
        {
            InitializeComponent();
        }

        private void FormExtractLoad_Load(object sender, EventArgs e)
        {
            disconnectedOLTPComponent();
            disconnectedOLAPComponent();
        }

        private void btnConnectOLTP_Click(object sender, EventArgs e)
        {
            connToSelectedOLTP(tbUserOLTP.Text, tbPassOLTP.Text, cbDBNameOLTP.Text);
            connectedOLTPComponent();
        }

        private void btnDiscOLTP_Click(object sender, EventArgs e)
        {
            disconnectedOLTPComponent();
            statConnOLTP = false;
            MessageBox.Show("Koneksi DATABASE LOCAL / OLTP DIPUTUS!");
            myConnOLTP.Close();
        }

        private void connectedOLTPComponent()
        {
            cbDBNameOLTP.Enabled = false;
            tbUserOLTP.Enabled = false;
            tbPassOLTP.Enabled = false;
            btnConnectOLTP.Enabled = false;
            btnDiscOLTP.Enabled = true;
            btnExtract.Enabled = true;
            cbTable.Enabled = true;
            dgvExtractedData.DataSource = null;
            dgvExtractedData.Refresh();
            dgvExtractedData.Enabled = true;
            lblStatOLTP.Text = "Status OLTP : Connected";
            if (statConnOLTP && statConnOLAP && cbTable.SelectedIndex != 0)
                btnTL.Enabled = true;
            else
                btnTL.Enabled = false;
        }

        private void disconnectedOLTPComponent()
        {
            cbDBNameOLTP.SelectedIndex = 0;
            cbDBNameOLTP.Enabled = true;
            tbUserOLTP.Enabled = true;
            tbPassOLTP.Enabled = true;
            btnDiscOLTP.Enabled = false;
            btnConnectOLTP.Enabled = true;
            cbTable.SelectedIndex = 0;
            cbTable.Enabled = false;
            btnTL.Enabled = false;
            btnExtract.Enabled = false;
            dgvExtractedData.DataSource = null;
            dgvExtractedData.Refresh();
            dgvExtractedData.Enabled = false;
            lblStatOLTP.Text = "Status OLTP : Disconnected";
            dgvExtractedData.DataSource = null;
            if (statConnOLTP && statConnOLAP && cbTable.SelectedIndex != 0)
                btnTL.Enabled = true;
            else
                btnTL.Enabled = false;
        }

        private void connToSelectedOLTP(string user, string pass, string db_name)
        {
            try
            {
                myConnOLTP = new MySqlConnection("SERVER=127.0.0.1;PORT=3306;UID=" + user + ";PASSWORD=" + pass + ";DATABASE=" + db_name);

                if (myConnOLTP.State == ConnectionState.Closed)
                {
                    myConnOLTP.Open();
                    MessageBox.Show("Berhasil TERKONEKSI ke DATABASE LOCAL / OLTP");
                    statConnOLTP = true;
                    lblStatOLTP.Text = "Status OLTP : Connected";
                }
                else if (myConnOLTP.State == ConnectionState.Open)
                {
                    MessageBox.Show("Koneksi masih TERBUKA");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        private void connToOLAPDB(string host, string user, string pass, string db_name)
        {
            try
            {
                myConnOLAP = new MySqlConnection("SERVER=" + host + ";PORT=3306;UID=" + user + ";PASSWORD=" + pass + ";DATABASE=" + db_name);

                if (myConnOLAP.State == ConnectionState.Closed)
                {
                    myConnOLAP.Open();
                    MessageBox.Show("Berhasil TERKONEKSI ke DATA WAREHOUSE (" + host + ")");
                    statConnOLAP = true;
                    lblStatOLAP.Text = "Status OLAP : Connected";
                }
                else if (myConnOLAP.State == ConnectionState.Open)
                {
                    MessageBox.Show("Koneksi masih TERBUKA");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        private void cbTable_SelectedIndexChanged(object sender, EventArgs e)
        {
            dgvExtractedData.DataSource = null;
            btnTL.Enabled = false;
        }

        private void btnExtract_Click(object sender, EventArgs e)
        {
            extractData(cbTable.Text);
            if (statConnOLTP && statConnOLAP && cbTable.SelectedIndex != 0)
                btnTL.Enabled = true;
            else
                btnTL.Enabled = false;
        }

        private void extractData(string tb_name)
        {
            try
            {
                string cmdText;
                if (tb_name == "User")
                {
                    cmdText = "SELECT id_user, name, email FROM " + tb_name  + " WHERE is_warehouse = 0 ORDER BY 1;";
                    myAdapter = new MySqlDataAdapter(cmdText, myConnOLTP);
                    dt = new DataTable();
                    myAdapter.Fill(dt);
                    dgvExtractedData.DataSource = dt;
                    dgvExtractedData.Refresh();
                }
                else if(tb_name == "Category")
                {
                    cmdText = "SELECT id_category, nama_category FROM " + tb_name ;
                    myAdapter = new MySqlDataAdapter(cmdText, myConnOLTP);
                    dt = new DataTable();
                    myAdapter.Fill(dt);
                    dgvExtractedData.DataSource = dt;
                    dgvExtractedData.Refresh();
                }
                else if(tb_name == "product")
                {
                    cmdText = "SELECT * FROM " + tb_name + " ORDER BY 1;";
                    myAdapter = new MySqlDataAdapter(cmdText, myConnOLTP);
                    dt = new DataTable();
                    myAdapter.Fill(dt);
                    dgvExtractedData.DataSource = dt;
                    dgvExtractedData.Refresh();
                }
                else if (tb_name == "Transaction")
                {
                    cmdText = "SELECT * FROM " + tb_name + " WHERE is_warehouse = 0 ORDER BY 1;";
                    myAdapter = new MySqlDataAdapter(cmdText, myConnOLTP);
                    dt = new DataTable();
                    myAdapter.Fill(dt);
                    dgvExtractedData.DataSource = dt;
                    dgvExtractedData.Refresh();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        private void btnConnectOLAP_Click(object sender, EventArgs e)
        {
            connToOLAPDB(tbHostOLAP.Text, tbUserOLAP.Text, tbPassOLAP.Text, tbDBNameOLAP.Text);
            connectedOLAPComponent();
        }

        private void btnDiscOLAP_Click(object sender, EventArgs e)
        {
            disconnectedOLAPComponent();
            statConnOLAP = false;
            MessageBox.Show("Koneksi DATA WAREHOUSE / OLAP DIPUTUS!");
            myConnOLAP.Close();
        }

        private void connectedOLAPComponent()
        {
            tbHostOLAP.Enabled = false;
            tbDBNameOLAP.Enabled = false;
            tbUserOLAP.Enabled = false;
            tbPassOLAP.Enabled = false;
            btnConnectOLAP.Enabled = false;
            btnDiscOLAP.Enabled = true;
            lblStatOLAP.Text = "Status OLAP : Connected";
            if (statConnOLTP && statConnOLAP && cbTable.SelectedIndex != 0)
                btnTL.Enabled = true;
            else
                btnTL.Enabled = false;
        }

        private void disconnectedOLAPComponent()
        {
            tbHostOLAP.Enabled = true;
            tbDBNameOLAP.Enabled = true;
            tbUserOLAP.Enabled = true;
            tbPassOLAP.Enabled = true;
            btnConnectOLAP.Enabled = true;
            btnDiscOLAP.Enabled = false;
            lblStatOLAP.Text = "Status OLAP : Disconnected";
            dgvExtractedData.DataSource = null;
            if (statConnOLTP && statConnOLAP && cbTable.SelectedIndex != 0)
                btnTL.Enabled = true;
            else
                btnTL.Enabled = false;
        }

        private void btnTL_Click(object sender, EventArgs e)
        {

            if (cbTable.Text.ToUpper() == "USER")
            {
                loadUsers();
            }
            else if (cbTable.Text.ToUpper() == "CATEGORY")
            {
                loadCategories();
            }
            else if(cbTable.Text.ToUpper() == "PRODUCT")
            {
                loadProducts();
            }
            else if (cbTable.Text.ToUpper() == "TRANSACTION")
            {
                loadTransaction();
            }
            btnExtract_Click(sender, e);
        }

        private void loadUsers()
        {
            try
            {
                myCmdOLTP.Connection = myConnOLTP;
                myCmdOLAP.Connection = myConnOLAP;
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    myCmdOLAP.CommandText = $"INSERT INTO user (id_user, name, email) VALUES " +
                        $"('{dt.Rows[i][0].ToString()}','{dt.Rows[i][1].ToString()}', '{dt.Rows[i][2].ToString()}')";
                    
                    myCmdOLAP.ExecuteNonQuery();
                    myCmdOLAP.CommandText = "UPDATE user SET is_fact = 1 WHERE id_user='" + dt.Rows[i][0].ToString() + "';";
                }
                MessageBox.Show("Berhasil LOAD DATA ke DW utk table " + cbTable.Text);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        private void loadCategories()
        {
            try
            {
                
                myCmdOLTP.Connection = myConnOLTP;
                myCmdOLAP.Connection = myConnOLAP;
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                   
                    myCmdOLAP.CommandText = "INSERT INTO category (id_category, nama_category) VALUES " +
                          $"('{dt.Rows[i][0].ToString()}','{dt.Rows[i][1].ToString()}')";

                    myCmdOLAP.ExecuteNonQuery();


                }
                MessageBox.Show("Berhasil LOAD DATA ke DW utk table " + cbTable.Text);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }
       private void loadProducts()
        {
            try
            {
                // Set the connection for OLAP command
                myCmdOLAP.Connection = myConnOLAP;

                // Loop through the DataTable to insert records
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    // Insert into OLAP product table
                    myCmdOLAP.CommandText = "INSERT INTO product (id_product, id_category, nama_product, price_unit, stock, description, sold_count, weight, image) " +
                                            "VALUES (@id_product, @id_category, @nama_product, @price_unit, @stock, @description, @sold_count, @weight, @image)";
                    
                    // Set parameters for the insert query
                    myCmdOLAP.Parameters.Clear();
                    myCmdOLAP.Parameters.AddWithValue("@id_product", dt.Rows[i][0].ToString());
                    myCmdOLAP.Parameters.AddWithValue("@id_category", dt.Rows[i][1].ToString());
                    myCmdOLAP.Parameters.AddWithValue("@nama_product", dt.Rows[i][2].ToString());
                    myCmdOLAP.Parameters.AddWithValue("@price_unit", Convert.ToDecimal(dt.Rows[i][3])); // Assuming price_unit is decimal
                    myCmdOLAP.Parameters.AddWithValue("@stock", Convert.ToInt32(dt.Rows[i][4])); // Assuming stock is integer
                    myCmdOLAP.Parameters.AddWithValue("@description", dt.Rows[i][5].ToString());
                    myCmdOLAP.Parameters.AddWithValue("@sold_count", Convert.ToInt32(dt.Rows[i][6])); // Assuming sold_count is integer
                    myCmdOLAP.Parameters.AddWithValue("@weight", dt.Rows[i][7].ToString());
                    myCmdOLAP.Parameters.AddWithValue("@image", dt.Rows[i][8].ToString());

                    // Execute the insert query
                    myCmdOLAP.ExecuteNonQuery();
                }

                // Show success message
                MessageBox.Show("Successfully loaded data to the data warehouse for table " + cbTable.Text);
            }
            catch (Exception ex)
            {
                // Display the error message
                MessageBox.Show("Error: " + ex.Message);
            }
        }



       private void loadTransaction()
        {
            try
            {
                // Establish connections for OLAP and OLTP commands
                myCmdOLAP.Connection = myConnOLAP;
                myCmdOLTP.Connection = myConnOLTP;

                // Loop through the DataTable to insert and update records
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    // Insert into OLAP transaction table
                    myCmdOLAP.CommandText = "INSERT INTO transaction (id_transaction, id_product, id_user, total_price, transaction_date) " +
                                            "VALUES (@id_transaction, @id_product, @id_user, @total_price, @transaction_date)";
                    
                    // Set parameters for the insert query
                    myCmdOLAP.Parameters.Clear();
                    myCmdOLAP.Parameters.AddWithValue("@id_transaction", dt.Rows[i][0].ToString());
                    myCmdOLAP.Parameters.AddWithValue("@id_product", dt.Rows[i][1].ToString());
                    myCmdOLAP.Parameters.AddWithValue("@id_user", dt.Rows[i][2].ToString());
                    myCmdOLAP.Parameters.AddWithValue("@total_price", Convert.ToDecimal(dt.Rows[i][3])); // Assuming total_price is decimal
                    myCmdOLAP.Parameters.AddWithValue("@transaction_date", Convert.ToDateTime(dt.Rows[i][4])); // Assuming transaction_date is DateTime

                    // Execute the insert query
                    myCmdOLAP.ExecuteNonQuery();

                    // Update is_fact in the OLTP database
                    myCmdOLTP.CommandText = "UPDATE transaction SET is_warehouse = 1 WHERE id_transaction = @id_transaction AND id_product = @id_product";
                    
                    // Set parameters for the update query
                    myCmdOLTP.Parameters.Clear();
                    myCmdOLTP.Parameters.AddWithValue("@id_transaction", dt.Rows[i][0].ToString());
                    myCmdOLTP.Parameters.AddWithValue("@id_product", dt.Rows[i][1].ToString());

                    // Execute the update query
                    myCmdOLTP.ExecuteNonQuery();
                }

                // Show success message
                MessageBox.Show("Berhasil LOAD DATA ke DW untuk table " + cbTable.Text);
            }
            catch (Exception ex)
            {
                // Display the error message
                MessageBox.Show(ex.Message.ToString());
            }
        }




        private void FormExtractLoad_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (myConnOLTP != null)
                if (myConnOLTP.State == ConnectionState.Open) myConnOLTP.Close();
            if (myConnOLAP != null)
                if (myConnOLAP.State == ConnectionState.Open) myConnOLAP.Close();
        }

        private void cbDBNameOLTP_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void tbPassOLAP_TextChanged(object sender, EventArgs e)
        {

        }
    }
}
