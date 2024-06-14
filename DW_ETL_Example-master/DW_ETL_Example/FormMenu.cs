using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace DW_ETL_Example
{
    public partial class FormMenu : Form
    {
        public FormMenu()
        {
            InitializeComponent();
        }

        private void btnExtract_Click(object sender, EventArgs e)
        {
            FormExtractLoad fEL = new FormExtractLoad();
            fEL.ShowDialog();
        }

        private void btnTransform_Click(object sender, EventArgs e)
        {
            FormTransform fT = new FormTransform();
            fT.ShowDialog();
        }

        private void btnAnalysis_Click(object sender, EventArgs e)
        {
            FormAnalysis fA = new FormAnalysis();
            fA.ShowDialog();
        }
    }
}
