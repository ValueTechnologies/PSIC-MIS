using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.UI.WebControls;
//using Microsoft.Reporting.WebForms;
using System.Web.Script.Serialization;

namespace PSIC
{


    public class MyClass
    {    
        
        public SqlConnection CN = new SqlConnection();
        public string SQL_Str = System.Configuration.ConfigurationManager.ConnectionStrings["PSIC_DBConnectionString"].ToString();
       


        public void CnStr()
        {
            if (CN.State == ConnectionState.Open)

                CN.Close();
            CN.ConnectionString = SQL_Str;
        }


 //------------------------------------------------------------------
//Execute Non Query on SQL or Procedures retrun number of row effected.
        public string Exec(string str)
        {
            string Out;
            try
            {
                CnStr();
                CN.Open();
                SqlCommand cmd = new SqlCommand(str, CN);
                Out=cmd.ExecuteNonQuery().ToString();

                CN.Close();
            }
            catch (System.Exception ex)
            {
                Out = ex.Message;
            }
            return Out;
        }
//-------------------------------------------------------------
        public string Data2Json(string str)
        {
            DataTable dt = FillDSet(str).Tables[0];
            JavaScriptSerializer serializer = new JavaScriptSerializer();

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            Dictionary<string, object> row;
            foreach (DataRow dr in dt.Rows)
            {
                row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    row.Add(col.ColumnName, dr[col]);
                }
                rows.Add(row);
            }
            return serializer.Serialize(rows);
        }

        public string ExeR(string str)
        {
            string Out;
            try
            {
                CnStr();
                CN.Open();
                SqlCommand cmd = new SqlCommand(str, CN);
                SqlParameter returnValue = new SqlParameter("returnVal", SqlDbType.Int);
                returnValue.Direction = ParameterDirection.ReturnValue;
                cmd.Parameters.Add(returnValue);

                cmd.ExecuteNonQuery().ToString();
                Out = returnValue.Value.ToString();
                CN.Close();
            }
            catch (System.Exception ex)
            {
                Out = ex.Message;
            }
            return Out;
        }
        public string ExenID(string str)
        {
            string ID;
            try
            {
                
                CnStr();
                CN.Open();
                SqlCommand cmd = new SqlCommand(str, CN);
                ID = cmd.ExecuteScalar().ToString();
                CN.Close();
            }
            
            catch (System.Exception ex)
            {
                ID = ex.Message;
            }
            return ID;
        }




        





      
        public void fillGrid(GridView Grd, string cmd)
        {
            try
            {
                DataSet MyDataSet = new DataSet();
                MyDataSet.Clear();
                System.Data.SqlClient.SqlDataAdapter MyDataAdapter = new System.Data.SqlClient.SqlDataAdapter(cmd, SQL_Str);
                MyDataAdapter.Fill(MyDataSet);
                Grd.DataSource = MyDataSet.Tables[0];
                Grd.DataBind();
                MyDataSet.Dispose();
            }
            catch
            {

            }
        }
        public string CmdExe(SqlCommand Cmd)
        {
            string msg = "OK";
            try
            {
                CnStr();
                CN.Open();
                Cmd.Connection = CN;
                Cmd.CommandType = CommandType.Text;
                Cmd.ExecuteNonQuery();
                CN.Close();
                
            }
            catch (Exception ex)
            {
                msg = ex.Message;
                CN.Close();
            }
            return msg;
        }
       
        public string[] GetRecords(string cmd)
        {
            string[] R_Data = { "a", "b", "c", "d", "e", "f", "g", "h" };

            try
            {
                DataSet MyDataSet = new DataSet();
                MyDataSet.Clear();
                System.Data.SqlClient.SqlDataAdapter MyDataAdapter = new System.Data.SqlClient.SqlDataAdapter(cmd, SQL_Str);
                MyDataAdapter.Fill(MyDataSet);
                int i1 = MyDataSet.Tables[0].Rows.Count - 1;
                int j1 = MyDataSet.Tables[0].Columns.Count - 1;
                int ss = 0;
                for (int i = 0; i <= i1; i++)
                {

                    for (int j = 0; j <= j1; j++)
                    {
                        ss = ss + 1;
                        R_Data[ss - 1] = MyDataSet.Tables[0].Rows[i][j].ToString();
                    }

                }
            }
            catch
            {
            }
            return R_Data;
        }
        public void SendEmail(string txtTo, string txtSubject, string txtBody, string txtFrom)
        {
            try
            {
                MailMessage mailMsg = new MailMessage();
                SmtpClient smtp = new SmtpClient("mail.valuesoft.org", 25);
                smtp.Credentials = new NetworkCredential("mail@valuesoft.org", "Value@123");
                mailMsg.From = new MailAddress(txtFrom);
                mailMsg.To.Add(txtTo);
                mailMsg.Subject = txtSubject;
                mailMsg.Body = txtBody;
                mailMsg.IsBodyHtml = true;
                smtp.Send(mailMsg);
            }
            catch { }
        }
        public DateTime FirstDayOfMonthFromDateTime(DateTime dateTime)
        {
            return new DateTime(dateTime.Year, dateTime.Month, 1);
        }
        public DateTime LastDayOfMonthFromDateTime(DateTime dateTime)
        {
            DateTime firstDayOfTheMonth = new DateTime(dateTime.Year, dateTime.Month, 1);
            return firstDayOfTheMonth.AddMonths(1).AddDays(-1);
        }
        public string CleanSQL(string Txt)
        {
            return Txt.Replace("'", "''");
        }
        public DataSet FillDSet(string cmd)
        {
            DataSet MyDataSet = new DataSet();
            try
            {
                System.Data.SqlClient.SqlDataAdapter MyDataAdapter = new System.Data.SqlClient.SqlDataAdapter(cmd, SQL_Str);
                MyDataAdapter.Fill(MyDataSet);


            }
            catch (Exception ex)
            {
               
            }
            return MyDataSet;
        }
        public SqlDataReader FillReader(string sql)
        {
            SqlDataReader xReader = null;
            try
            {
                CnStr();
                CN.Open();
                SqlCommand cmd = new SqlCommand(sql, CN);
                xReader = cmd.ExecuteReader();
                //CN.Close();
            }
            catch
            {
            }
            return xReader;
        }
        public bool[] UserRolls(string Pg,string UGrp)
        {
            bool[] Ac = { false, false, false};
            try
            {
                Ac[0] =
                Convert.ToBoolean(GetRecords("sp_WR_Chk '" + Pg + "'," + UGrp)[0]);
                Ac[1] = Convert.ToBoolean(GetRecords("sp_Edt_Chk '" + Pg + "'," + UGrp)[0]);
                if (Ac[1])
                {
                    Ac[0] = true;
                }
            }
            catch {
                Ac[2] = true;
            }
            return Ac;
        }
        public string TruncateLongString(string str, int maxLength)
        {
            return str.Length <= maxLength ? str : str.Remove(maxLength);
        }
        //====================================================================================
        public SqlConnection CN0 = new SqlConnection();
        public string SQL_Str0 = "Data Source=182.180.66.89;Initial Catalog=AccountsDBNew_Recovered;User ID=sa;Password=mzislam";//"Data Source=.\\;Initial Catalog=xxx;User ID=sa;Password=mzislam";
        //public string SQL_Str = "Data Source=localhost;Initial Catalog=MIS_RDP;User ID=arrows;Password=java123";//

        public void CnStr0()
        {
            if (CN0.State == ConnectionState.Open)

                CN0.Close();
            CN0.ConnectionString = SQL_Str0;
        }
        public string ExecFin(string str)
        {
            string Out;
            try
            {
                CnStr0();
                CN0.Open();
                SqlCommand cmd = new SqlCommand(str, CN0);
                Out = cmd.ExecuteNonQuery().ToString();

                CN0.Close();
            }
            catch (System.Exception ex)
            {
                Out = ex.Message;
            }
            return Out;
        }
        public string[] GetRecords0(string cmd)
        {
            string[] R_Data = { "a", "b", "c", "d", "e", "f", "g", "h" };

            try
            {
                DataSet MyDataSet = new DataSet();
                MyDataSet.Clear();
                System.Data.SqlClient.SqlDataAdapter MyDataAdapter = new System.Data.SqlClient.SqlDataAdapter(cmd, SQL_Str0);
                MyDataAdapter.Fill(MyDataSet);
                int i1 = MyDataSet.Tables[0].Rows.Count - 1;
                int j1 = MyDataSet.Tables[0].Columns.Count - 1;
                int ss = 0;
                for (int i = 0; i <= i1; i++)
                {

                    for (int j = 0; j <= j1; j++)
                    {
                        ss = ss + 1;
                        R_Data[ss - 1] = MyDataSet.Tables[0].Rows[i][j].ToString();
                    }

                }
            }
            catch
            {
            }
            return R_Data;
        }
        public SqlDataReader FillReader0(string sql)
        {
            SqlDataReader xReader = null;
            try
            {
                CnStr0();
                CN0.Open();
                SqlCommand cmd = new SqlCommand(sql, CN0);
                xReader = cmd.ExecuteReader();
                //CN.Close();
            }
            catch
            {
            }
            return xReader;
        }
    }
}