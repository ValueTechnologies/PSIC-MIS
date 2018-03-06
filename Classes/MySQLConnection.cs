using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace PSIC
{
    public class MySQLConnection
    {
        public SqlConnection con = null;

        public MySQLConnection()
        {

        }

        public void open()
        {
            if (con == null)
            {
                con = new SqlConnection(ConfigurationManager.ConnectionStrings["PSIC_DBConnectionString"].ConnectionString);
                con.Open();
            }
            else
            {
                con.Open();
            }
        }






        public void Close()
        {
            if (con.State == ConnectionState.Open)
            {
                con.Close();
            }
        }


    }
}
