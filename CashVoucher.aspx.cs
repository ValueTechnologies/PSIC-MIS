using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class CashVoucher : System.Web.UI.Page
    {
        public static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        
        [WebMethod]
        public static string CPVVNo() 
        {
            return Fn.Data2Json("Select 'CPV/' + Convert(varchar(50), ISNULL(Count(TblVoucherHDR.VoucherID) + 1 , 1 )) AS Voch FROM TblVoucherHDR WHERE  (Replace(Str(CONVERT(varchar, MONTH(EntryDate)), 2), ' ' , '0') + CONVERT(varchar, YEAR(EntryDate)) = '" + HttpContext.Current.Session["Amonth"] + "') AND (VoucherNo LIKE N'CPV/%')");
        }

        [WebMethod]
        public static string CRVVNo()
        {
            return Fn.Data2Json("Select 'CRV/' + Convert(varchar(50), ISNULL(Count(TblVoucherHDR.VoucherID) + 1 , 1 )) AS Voch FROM TblVoucherHDR WHERE  (Replace(Str(CONVERT(varchar, MONTH(EntryDate)), 2), ' ' , '0') + CONVERT(varchar, YEAR(EntryDate)) = '" + HttpContext.Current.Session["Amonth"] + "') AND (VoucherNo LIKE N'CRV/%')");
        }


        [WebMethod]
        public static string CashAccountHead() 
        {
            return Fn.Data2Json("SELECT AccountID,   HeadName + ' - ' + Replace(Str(AccountCode, Leavel + 1), ' ' , '0') as HeadName FROM tbl_ChartOfAccount where  ISEntryLevel = 1 and HeadName like '%Cash%'  order by HeadName");
        }

        [WebMethod]
        public static string Getdate()
        {
            return Fn.Data2Json("select Format(getdate(), 'dd - MMMM - yyyy') as EntryDate");
        }

        [WebMethod]
        public static string LoadAccountHeadCPV()
        {
            return Fn.Data2Json("; with cte as (select  AccountID, HeadName , ISEntryLevel , Leavel, AccountCode from    tbl_ChartOfAccount where ParentID is null and HeadName <> 'Revenue' union all select  child.AccountID,  child.HeadName , child.ISEntryLevel, child.Leavel, child.AccountCode from    tbl_ChartOfAccount as child inner join    cte as parent on      parent.AccountID = child.ParentID ) select distinct AccountID, HeadName + ' - ' + Replace(Str(AccountCode, Leavel + 1), ' ' , '0') as HeadName, Leavel from    cte where ISEntryLevel = 1  order by HeadName");
        }

        [WebMethod]
        public static string LoadAccountHeadCRV()
        {
            return Fn.Data2Json("; with cte as (select  AccountID, HeadName , ISEntryLevel , Leavel, AccountCode from    tbl_ChartOfAccount where ParentID is null and HeadName <> 'Expenditure' union all select  child.AccountID,  child.HeadName , child.ISEntryLevel, child.Leavel, child.AccountCode from    tbl_ChartOfAccount as child inner join    cte as parent on      parent.AccountID = child.ParentID ) select distinct AccountID, HeadName + ' - ' + Replace(Str(AccountCode, Leavel + 1), ' ' , '0') as HeadName, Leavel from    cte where ISEntryLevel = 1  order by HeadName");
        }


        [WebMethod]
        public static string NumericToWord(string Value)
        {
            Words wrd = new Words();
            return wrd.changeNumericToWords(Value) + " Rupees Only";
        }


        [WebMethod]
        public static string SaveHead(string VNo, string EntryDate) 
        {
            return Fn.ExenID("INSERT INTO TblVoucherHDR (VoucherNo, EntryDate) VALUES ( '" + VNo + "', '" + EntryDate + "'); Select SCOPE_IDENTITY();");
        }


        [WebMethod]
        public static string SaveDetail(string vID, string Head, string Narration, string Dr, string Cr)
        {
            return Fn.Exec("INSERT INTO TblVoucherDTL (VoucherID, AccEntryID, Description, AmountDeb, AmountCre, Repli) VALUES ('" + vID + "', '" + Head + "', '" + Narration + "', '" + Dr + "', '" + Cr + "', 0)");
        }


        [WebMethod(EnableSession=true)]
        public static string DateValidation(string ValidationDate) 
        {
            DateTime dt = Convert.ToDateTime(ValidationDate);
            string vDate = Convert.ToString(dt.Month) + Convert.ToString(dt.Year);
            if (vDate.Length != 6)
	        {
		        vDate = "0" + vDate;
	        }
            var tmp = Convert.ToString(HttpContext.Current.Session["Amonth"]);
            if (vDate == tmp)
            {
                return "ValidDate";
            }
            return "InvalidDate";
        }


    }
}