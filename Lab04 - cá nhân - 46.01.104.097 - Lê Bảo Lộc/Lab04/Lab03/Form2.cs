using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QLSV
{
    public partial class Form2 : Form
    {
        public Form2()
        {
            InitializeComponent();
        }

        SqlConnection con = new SqlConnection();
        SqlCommand cmd = new SqlCommand();
        SqlDataAdapter adapter = new SqlDataAdapter();
        DataTable table = new DataTable();
        private void button6_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void button5_Click(object sender, EventArgs e)
        {
            textBox1.ReadOnly = false;
            textBox1.ResetText();
            textBox2.ResetText();
            textBox3.ResetText();
            textBox4.ResetText();
            textBox5.ResetText();
            textBox6.ResetText();
        }

        void loaddata()
        {
            cmd = con.CreateCommand();
            cmd.CommandText = "EXEC SP_SEL_ENCRYPT_NHANVIEN";
            adapter.SelectCommand = cmd;
            table.Clear();
            adapter.Fill(table);
            dataGridView1.DataSource = table;
        }

        public void Form2_Load(object sender, EventArgs e)
        {
            //SqlConnection con = new SqlConnection();
            con.ConnectionString = "Data Source=DESKTOP-JMUMHFV\\SQLEXPRESS;Initial Catalog=QLSV;Integrated Security=True";
            con.Open();
            string sql = "EXEC SP_SEL_ENCRYPT_NHANVIEN";
            DataSet ds = new DataSet();
            SqlDataAdapter dap = new SqlDataAdapter(sql, con);
            dap.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
            dataGridView1.Refresh();
        }

        public void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            textBox1.ReadOnly = true;
            int i;
            i = dataGridView1.CurrentRow.Index;
            textBox1.Text = dataGridView1.Rows[i].Cells[0].Value.ToString();
            textBox2.Text = dataGridView1.Rows[i].Cells[1].Value.ToString();
            textBox3.Text = dataGridView1.Rows[i].Cells[2].Value.ToString();
            textBox4.Text = dataGridView1.Rows[i].Cells[3].Value.ToString();
            /*textBox5.Text = dataGridView1.Rows[i].Cells[4].Value.ToString();
            textBox6.Text = dataGridView1.Rows[i].Cells[5].Value.ToString();*/
        }

        private void button1_Click(object sender, EventArgs e)
        {
            textBox1.ReadOnly = false;
            textBox1.ResetText();
            textBox2.ResetText();
            textBox3.ResetText();
            textBox4.ResetText();
            textBox5.ResetText();
            textBox6.ResetText();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if(con.State == ConnectionState.Closed)
            {
                con.ConnectionString = "Data Source=DESKTOP-JMUMHFV\\SQLEXPRESS;Initial Catalog=QLSV;Integrated Security=True";
                con.Open();
            }
            // tiếp tục thực hiện các lệnh xử lý sự kiện
            cmd = con.CreateCommand();
            cmd.CommandText = "DELETE FROM dbo.NHANVIEN WHERE MANV = '" + textBox1.Text +"'";
            cmd.ExecuteNonQuery();
            loaddata();
            textBox1.ResetText();
            textBox2.ResetText();
            textBox3.ResetText();
            textBox4.ResetText();
            textBox5.ResetText();
            textBox6.ResetText();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            if (con.State == ConnectionState.Closed)
            {
                con.ConnectionString = "Data Source=DESKTOP-JMUMHFV\\SQLEXPRESS;Initial Catalog=QLSV;Integrated Security=True";
                con.Open();
            }
            // tiếp tục thực hiện các lệnh xử lý sự kiện
            cmd = con.CreateCommand();
            cmd.CommandText = "UPDATE NHANVIEN SET HOTEN = N'" + textBox2.Text +"', EMAIL='" + textBox3.Text + "',LUONG = '" + textBox4.Text + "',TENDN = '" + textBox5.Text + "',MATKHAU = '" + textBox6.Text + "'";
            cmd.ExecuteNonQuery();
            loaddata();
            textBox1.ResetText();
            textBox2.ResetText();
            textBox3.ResetText();
            textBox4.ResetText();
            textBox5.ResetText();
            textBox6.ResetText();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            if (con.State == ConnectionState.Closed)
            {
                con.ConnectionString = "Data Source=DESKTOP-JMUMHFV\\SQLEXPRESS;Initial Catalog=QLSV;Integrated Security=True";
                con.Open();
            }
            // tiếp tục thực hiện các lệnh xử lý sự kiện
            cmd = con.CreateCommand();
            cmd.CommandText = "EXEC SP_INS_NHANVIEN '" + textBox1.Text + "', N'" + textBox2.Text + "', '" + textBox3.Text + "', '" + textBox4.Text + "', '" + textBox5.Text + "', '" + textBox6.Text + "'";
            cmd.ExecuteNonQuery();
            loaddata();
            textBox1.ResetText();
            textBox2.ResetText();
            textBox3.ResetText();
            textBox4.ResetText();
            textBox5.ResetText();
            textBox6.ResetText();
        }
    }
}
