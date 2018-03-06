using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PSIC
{
    public class cssMenu
    {
        int Emp_ID;
        public cssMenu(int EmpId)
        {
            Emp_ID = EmpId;
        }

        public string main()
        {
            string Menu = "";
            List<sp_cssMenuResult> top = new List<sp_cssMenuResult>();
            using (DBDataContext _eq = new DBDataContext())
            {
                top = _eq.sp_cssMenu(Emp_ID).ToList<sp_cssMenuResult>();

                foreach (var item in top)
                {
                    if (item.Module_Id>0)
                    {
                        Menu = Menu + item.Module_Name + _eq.sp_cssMenuSub(item.Module_Id, item.User_Group_Id).FirstOrDefault().Column1;
                    }
                    else
                    {
                        Menu = Menu + item.Module_Name;

                    }
                }

            }
            return "<ul>" + Menu + "</ul>";
        }
    }
}