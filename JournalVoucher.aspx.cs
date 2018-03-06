using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;


namespace PSIC
{
    public partial class JournalVoucher : System.Web.UI.Page
    {
        public static MyClass Fn = new MyClass();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string Getdate() 
        {
            return Fn.Data2Json("select Format(getdate(), 'dd - MMMM - yyyy') as EntryDate");
        }

        [WebMethod(EnableSession=true)]
        public static string GetVoucherNo(string VType)
        {
            TextBox voucherN = new TextBox();

            if (VType == "Journal Voucher")
            {
                return Fn.Data2Json("Select 'JV/' + Convert(varchar(50), ISNULL(Count(TblVoucherHDR.VoucherID) + 1 , 1 )) AS Voch FROM TblVoucherHDR WHERE  (Replace(Str(CONVERT(varchar, MONTH(EntryDate)), 2), ' ' , '0') + CONVERT(varchar, YEAR(EntryDate)) = '" + HttpContext.Current.Session["Amonth"] + "') AND (VoucherNo LIKE N'JV/%')");

            }
            else if (VType == "Grant Payment Voucher")
            {
                return Fn.Data2Json("Select 'GPV/' + Convert(varchar(50), ISNULL(Count(TblVoucherHDR.VoucherID) + 1, 1 )) AS Voch FROM TblVoucherHDR WHERE  (Replace(Str(CONVERT(varchar, MONTH(EntryDate)), 2), ' ' , '0') + CONVERT(varchar, YEAR(EntryDate)) = '" + HttpContext.Current.Session["Amonth"] + "') AND (VoucherNo LIKE N'GPV/%')");

            }
            else if (VType == "Grant Receipt Voucher")
            {
                return Fn.Data2Json("Select 'GRV/' + Convert(varchar(50), ISNULL(Count(TblVoucherHDR.VoucherID) + 1, 1 )) AS Voch FROM TblVoucherHDR WHERE  (Replace(Str(CONVERT(varchar, MONTH(EntryDate)), 2), ' ' , '0') + CONVERT(varchar, YEAR(EntryDate)) = '" + HttpContext.Current.Session["Amonth"] + "') AND (VoucherNo LIKE N'GRV/%')");

            }
            else if (VType == "Security Payment Voucher")
            {
                return Fn.Data2Json("Select 'SPV/' + Convert(varchar(50), ISNULL(Count(TblVoucherHDR.VoucherID) + 1, 1 )) AS Voch FROM TblVoucherHDR WHERE  (Replace(Str(CONVERT(varchar, MONTH(EntryDate)), 2), ' ' , '0') + CONVERT(varchar, YEAR(EntryDate)) = '" + HttpContext.Current.Session["Amonth"] + "') AND (VoucherNo LIKE N'SPV/%')");

            }
            else if (VType == "Security Receipt Voucher")
            {
                return Fn.Data2Json("Select 'SRV/' + Convert(varchar(50), ISNULL(Count(TblVoucherHDR.VoucherID) + 1, 1 )) AS Voch FROM TblVoucherHDR WHERE  (Replace(Str(CONVERT(varchar, MONTH(EntryDate)), 2), ' ' , '0') + CONVERT(varchar, YEAR(EntryDate)) = '" + HttpContext.Current.Session["Amonth"] + "') AND (VoucherNo LIKE N'SRV/%')");

            }
            else if (VType == "Bank Receipt Voucher")
            {
                return Fn.Data2Json("Select 'BRV/' + Convert(varchar(50), ISNULL(Count(TblVoucherHDR.VoucherID) + 1, 1 )) AS Voch FROM TblVoucherHDR WHERE  (Replace(Str(CONVERT(varchar, MONTH(EntryDate)), 2), ' ' , '0') + CONVERT(varchar, YEAR(EntryDate)) = '" + HttpContext.Current.Session["Amonth"] + "') AND (VoucherNo LIKE N'BRV/%')");

            }
            else if (VType == "Cash Receipt Voucher")
            {
                return Fn.Data2Json("Select 'CRV/' + Convert(varchar(50), ISNULL(Count(TblVoucherHDR.VoucherID) + 1, 1 )) AS Voch FROM TblVoucherHDR WHERE  (Replace(Str(CONVERT(varchar, MONTH(EntryDate)), 2), ' ' , '0') + CONVERT(varchar, YEAR(EntryDate)) = '" + HttpContext.Current.Session["Amonth"] + "') AND (VoucherNo LIKE N'CRV/%')");

            }
            else if (VType == "Bank Payment Voucher")
            {
                return Fn.Data2Json("Select 'BPV/' + Convert(varchar(50), ISNULL(Count(TblVoucherHDR.VoucherID) + 1, 1 )) AS Voch FROM TblVoucherHDR WHERE  (Replace(Str(CONVERT(varchar, MONTH(EntryDate)), 2), ' ' , '0') + CONVERT(varchar, YEAR(EntryDate)) = '" + HttpContext.Current.Session["Amonth"] + "') AND (VoucherNo LIKE N'BPV/%')");

            }
            else if (VType == "Cash Payment Voucher")
            {
                return Fn.Data2Json("Select 'CPV/' + Convert(varchar(50), ISNULL(Count(TblVoucherHDR.VoucherID) + 1, 1 )) AS Voch FROM TblVoucherHDR WHERE  (Replace(Str(CONVERT(varchar, MONTH(EntryDate)), 2), ' ' , '0') + CONVERT(varchar, YEAR(EntryDate)) = '" + HttpContext.Current.Session["Amonth"] + "') AND (VoucherNo LIKE N'CPV/%')");

            }

            return string.Empty;

        }


        [WebMethod]
        public static string LoadAccountHead() 
        {
            return Fn.Data2Json("select AccountID,   HeadName + ' - ' + Replace(Str(AccountCode, Leavel + 1), ' ' , '0') as HeadName  from tbl_ChartOfAccount where ISEntryLevel = 1 order by HeadName");
        }

        [WebMethod]
        public static string NumericToWord(string Value) 
        {
            Words wrd = new Words();
            return wrd.changeNumericToWords(Value) + " Rupees Only";
        }

        [WebMethod]
        public static string SaveHead(string EntryDate, string VNo) 
        {
            return Fn.ExenID("INSERT INTO TblVoucherHDR (VoucherNo, EntryDate) VALUES ('" + VNo + "', '" + EntryDate + "'); Select Scope_Identity();");
        }


        [WebMethod]
        public static string SaveDetail(string vID, string Head, string Narration, string Dr, string Cr)
        {
            return Fn.Exec("INSERT INTO TblVoucherDTL (VoucherID, AccEntryID, Description, AmountDeb, AmountCre, Repli) VALUES ('" + vID + "', '" + Head + "', '" + Narration + "', '" + Dr + "', '"+ Cr +"', 0)");
        }

    }
}