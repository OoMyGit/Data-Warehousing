using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using MySql.Data.MySqlClient;
using OxyPlot.Wpf;

namespace DW_ETL_Example
{
    public partial class FormAnalysis : Form
    {
        MySqlConnection myConnOLAP;
        MySqlCommand myCmdOLAP = new MySqlCommand();
        MySqlDataAdapter myAdapter;
        DataTable dt;

        public FormAnalysis()
        {
            InitializeComponent();
        }

        private void FormAnalysis_Load(object sender, EventArgs e)
        {
            cbReport1.SelectedIndex = -1;
            disconnectedOLAPComponent();
        }

        private void btnConnectOLAP_Click(object sender, EventArgs e)
        {
            connToOLAPDB(tbHostOLAP.Text, tbUserOLAP.Text, tbPassOLAP.Text, tbDBNameOLAP.Text);
            connectedOLAPComponent();
        }

        private void btnDiscOLAP_Click(object sender, EventArgs e)
        {
            disconnectedOLAPComponent();
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

        private void FormAnalysis_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (myConnOLAP != null)
                if (myConnOLAP.State == ConnectionState.Open) myConnOLAP.Close();
        }

        private void btnReport1_Click(object sender, EventArgs e)
        {
            try
            {
                string cmdText = "CALL GetBestSellingProductsByOrigin('" + cbReport1.Text  + "');";

                myAdapter = new MySqlDataAdapter(cmdText, myConnOLAP);
                dt = new DataTable();
                myAdapter.Fill(dt);
                dgvResult.DataSource = dt;
                dgvResult.Refresh();

                chart1.DataSource = dt;
                chart1.Series[0].Name = "Best Selling Product";
                chart1.Series[0].XValueMember = "nama_product";
                chart1.Series[0].YValueMembers = "TotalRevenue";
                chart1.DataBind();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        private void btnReport2_Click(object sender, EventArgs e)
        {
            try
            {
                string cmdText = "CALL GetTotalRevenueByOrigin();";

                myAdapter = new MySqlDataAdapter(cmdText, myConnOLAP);
                dt = new DataTable();
                myAdapter.Fill(dt);
                dgvResult.DataSource = dt;
                dgvResult.Refresh();

                chart1.DataSource = dt;
                chart1.Series[0].Name = "Total Penjualan";
                chart1.Series[0].XValueMember = "OrderOrigin";
                chart1.Series[0].YValueMembers = "TotalRevenue";
                chart1.DataBind();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                string cmdText = "CALL GetAverageTransactionValueByOrigin();";

                myAdapter = new MySqlDataAdapter(cmdText, myConnOLAP);
                dt = new DataTable();
                myAdapter.Fill(dt);
                dgvResult.DataSource = dt;
                dgvResult.Refresh();

                chart1.DataSource = dt;
                chart1.Series[0].Name = "Average Transaction Value";
                chart1.Series[0].XValueMember = "OrderOrigin";
                chart1.Series[0].YValueMembers = "AverageTransactionValue";
                chart1.DataBind();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            try
            {
                string cmdText = "CALL GetTotalUsersByOrigin();";

                myAdapter = new MySqlDataAdapter(cmdText, myConnOLAP);
                dt = new DataTable();
                myAdapter.Fill(dt);
                dgvResult.DataSource = dt;
                dgvResult.Refresh();

                chart1.DataSource = dt;
                chart1.Series[0].Name = "Total Users";
                chart1.Series[0].XValueMember = "CustOrigin";
                chart1.Series[0].YValueMembers = "TotalUsers";
                chart1.DataBind();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            try
            {
                string cmdText = "CALL GetTransactionCountOverTimeByOrigin('" + cbReport2.Text + "');";

                myAdapter = new MySqlDataAdapter(cmdText, myConnOLAP);
                dt = new DataTable();
                myAdapter.Fill(dt);
                dgvResult.DataSource = dt;
                dgvResult.Refresh();

                chart1.DataSource = dt;
                chart1.Series[0].Name = "Transaction Count Over Time";
                chart1.Series[0].XValueMember = "TransactionDate";
                chart1.Series[0].YValueMembers = "TransactionCount";
                chart1.DataBind();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }
    }
}
