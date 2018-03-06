using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class BankVoucher : System.Web.UI.Page
    {
        private static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        [WebMethod]
        public static string BPVVNo()
        {
            return Fn.Data2Json("Select 'BPV/' + Convert(varchar(50), ISNULL(Count(TblVoucherHDR.VoucherID) + 1 , 1 )) AS Voch FROM TblVoucherHDR WHERE  (Replace(Str(CONVERT(varchar, MONTH(EntryDate)), 2), ' ' , '0') + CONVERT(varchar, YEAR(EntryDate)) = '" + HttpContext.Current.Session["Amonth"] + "') AND (VoucherNo LIKE N'BPV/%')");
        }

        [WebMethod]
        public static string BRVVNo()
        {
            return Fn.Data2Json("Select 'BRV/' + Convert(varchar(50), ISNULL(Count(TblVoucherHDR.VoucherID) + 1 , 1 )) AS Voch FROM TblVoucherHDR WHERE  (Replace(Str(CONVERT(varchar, MONTH(EntryDate)), 2), ' ' , '0') + CONVERT(varchar, YEAR(EntryDate)) = '" + HttpContext.Current.Session["Amonth"] + "') AND (VoucherNo LIKE N'BRV/%')");
        }



        [WebMethod]
        public static string BankAccountHead()
        {
            return Fn.Data2Json("SELECT AccountID,   HeadName + ' - ' + Replace(Str(AccountCode, Leavel + 1), ' ' , '0') as HeadName FROM tbl_ChartOfAccount where  ISEntryLevel = 1 and HeadName like '%Bank%' and HeadName not like '%charges%'");
        }



        [WebMethod]
        public static string LoadAccountHeadBPV()
        {
            return Fn.Data2Json("; with cte as (select  AccountID, HeadName , ISEntryLevel , Leavel, AccountCode from    tbl_ChartOfAccount where ParentID is null and HeadName <> 'Revenue' union all select  child.AccountID,  child.HeadName , child.ISEntryLevel, child.Leavel, child.AccountCode from    tbl_ChartOfAccount as child inner join    cte as parent on      parent.AccountID = child.ParentID ) select distinct AccountID, HeadName + ' - ' + Replace(Str(AccountCode, Leavel + 1), ' ' , '0') as HeadName, Leavel from    cte where ISEntryLevel = 1");
        }

        [WebMethod]
        public static string LoadAccountHeadBRV()
        {
            return Fn.Data2Json("; with cte as (select  AccountID, HeadName , ISEntryLevel , Leavel, AccountCode from    tbl_ChartOfAccount where ParentID is null and HeadName <> 'Expenditure' union all select  child.AccountID,  child.HeadName , child.ISEntryLevel, child.Leavel, child.AccountCode from    tbl_ChartOfAccount as child inner join    cte as parent on      parent.AccountID = child.ParentID ) select distinct AccountID, HeadName + ' - ' + Replace(Str(AccountCode, Leavel + 1), ' ' , '0') as HeadName, Leavel from    cte where ISEntryLevel = 1 ");
        }


        [WebMethod]
        public static string SaveHead(string VNo, string EntryDate, string chqNo, string chqDate, string chqAmount)
        {
            return Fn.ExenID("INSERT INTO TblVoucherHDR (VoucherNo, EntryDate, CheqNo, DrawingDate ) VALUES ( '" + VNo + "', '" + EntryDate + "', '" + chqNo + "', '" + chqDate + "'); Select SCOPE_IDENTITY();");
        }


        [WebMethod]
        public static string SaveDetail(string vID, string Head, string Narration, string Dr, string Cr)
        {
            return Fn.Exec("INSERT INTO TblVoucherDTL (VoucherID, AccEntryID, Description, AmountDeb, AmountCre, Repli) VALUES ('" + vID + "', '" + Head + "', '" + Narration + "', '" + Dr + "', '" + Cr + "', 0)");
        }




    }
}