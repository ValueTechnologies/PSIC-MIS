using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class POSSupplierRegistration : System.Web.UI.Page
    {
        public static MyClassPOS Fn = new MyClassPOS();
        protected void Page_Load(object sender, EventArgs e)
        {

        }



        [WebMethod]
        public static string SaveSupplier(string Vals)
        {
            string[] d = Vals.Split('§');
            return Fn.Exec("INSERT INTO tbl_POSSupplier (CompanyId,TypeOfSupplier, Name, CellNo, AlternateContact, EmailID, NTN,CNIC, GST, Address, Remaks) VALUES ('" + d[0] + "','" + d[1] + "','" + d[2] + "','" + d[3] + "','" + d[4] + "','" + d[5] + "','" + d[6] + "','" + d[7] + "','" + d[8] + "','" + d[9] + "','" + d[10] + "')");
        }


        [WebMethod]
        public static string GetSuppliersFromCompany(string CompanyID)
        {
            return Fn.Data2Json("SELECT   ROW_NUMBER() over(order by Name) as Srno, SupplierID,ISNULL(TypeOfSupplier, '') as TypeOfSupplier,  Name, CellNo, AlternateContact, EmailID, Address, NTN, CNIC, GST, Remaks FROM tbl_POSSupplier where CompanyId = " + CompanyID);
        }



        [WebMethod]
        public static string GetSuppliers()
        {
            return Fn.Data2Json("SELECT   ROW_NUMBER() over(order by Name) as Srno, ISNULL(TypeOfSupplier, '') as TypeOfSupplier, SupplierID,  Name, CellNo, AlternateContact, EmailID, Address, NTN, CNIC, GST, Remaks FROM tbl_POSSupplier");
        }

        [WebMethod]
        public static string GetSupplierCompanyList()
        {
            return Fn.Data2Json("SELECT SupplierCompanyID, SupplierCompanyName FROM tbl_SupplierCompany Order by SupplierCompanyName");
        }

        [WebMethod]
        public static string SaveCompany(string CompanyName)
        {
            return Fn.ExenID("INSERT INTO tbl_SupplierCompany (SupplierCompanyName) VALUES ('"+ CompanyName + "'); Select SCOPE_IDENTITY();");
        }
    }
}