using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

namespace PSIC
{
    public class DBManagerPSICMisc
    {
        public string NewAccountEmailBody(string Email, string password)
        {
            DataTable dt = new DataTable();
            string returntxt = string.Empty;
            MySQLConnection con = new MySQLConnection();
            try
            {
                con.open();

                SqlCommand cmd = new SqlCommand("usp_NewAccountEmailBody", con.con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@email", Email);
                cmd.Parameters.AddWithValue("@password", password);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
                if (dt != null && dt.Rows.Count > 0)
                {
                    returntxt = Convert.ToString(dt.Rows[0]["EmailBody"]);
                }
                cmd.Dispose();
            }
            catch (Exception ex)
            {
            }
            finally
            {
                con.Close();
            }
            return returntxt;
        }




        public string UserEmail(string userid)
        {
            DataTable dt = new DataTable();
            string returntxt = string.Empty;
            MySQLConnection con = new MySQLConnection();
            try
            {
                con.open();

                SqlCommand cmd = new SqlCommand("Select Email from TblHResources where User_ID =  " + userid, con.con);
                cmd.CommandType = CommandType.Text;

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
                if (dt != null && dt.Rows.Count > 0)
                {
                    returntxt = Convert.ToString(dt.Rows[0]["Email"]);
                }
                cmd.Dispose();
            }
            catch (Exception ex)
            {
            }
            finally
            {
                con.Close();
            }
            return returntxt;
        }

        public string ForgotPasswordEmailBody(string Email, string NewPassword)
        {
            DataTable dt = new DataTable();
            string returntxt = string.Empty;
            MySQLConnection con = new MySQLConnection();
            try
            {
                con.open();

                SqlCommand cmd = new SqlCommand("usp_ForgotPasswordEmailBody", con.con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@email", Email);
                cmd.Parameters.AddWithValue("@password", NewPassword);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
                if (dt != null && dt.Rows.Count > 0)
                {
                    returntxt = Convert.ToString(dt.Rows[0]["EmailBody"]);
                }
                cmd.Dispose();
            }
            catch (Exception ex)
            {
            }
            finally
            {
                con.Close();
            }
            return returntxt;
        }




        public string GetChartOfAccount()
        {
            DataTable dt = new DataTable();
            string returntxt = string.Empty;
            MySQLConnection con = new MySQLConnection();
            try
            {
                con.open();

                SqlCommand cmd = new SqlCommand("usp_DisplayChartOfAccount", con.con);
                cmd.CommandType = CommandType.StoredProcedure;


                SqlParameter parm = new SqlParameter("@myReturnString", SqlDbType.VarChar, 50000);
                parm.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(parm);

                cmd.ExecuteNonQuery();
                returntxt = Convert.ToString(cmd.Parameters["@myReturnString"].Value);

                cmd.Dispose();
            }
            catch (Exception ex)
            {
            }
            finally
            {
                con.Close();
            }
            return returntxt;
        }



        public string EstatePlotInstallmentsCreate(string fromdate, string todate, string amount, string noOfInstallments)
        {
            DataTable dt = new DataTable();
            string returntxt = string.Empty;
            MySQLConnection con = new MySQLConnection();
            try
            {
                con.open();

                SqlCommand cmd = new SqlCommand("usp_EstatePlotCreateInstallments", con.con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@NoOfInstallments", noOfInstallments);
                cmd.Parameters.AddWithValue("@Amount", amount);
                cmd.Parameters.AddWithValue("@startingDate", fromdate);
                cmd.Parameters.AddWithValue("@endingDate", todate);



                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
                if (dt != null && dt.Rows.Count > 0)
                {
                    returntxt = Convert.ToString(dt.Rows[0]["FinalInstallments"]);
                }
                cmd.Dispose();
            }
            catch (Exception ex)
            {
            }
            finally
            {
                con.Close();
            }
            return returntxt;
        }








    }
}