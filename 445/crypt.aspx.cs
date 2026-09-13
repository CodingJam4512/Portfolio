using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Cryptography;
using System.Text;

namespace Assignment5
{
    public partial class WebForm2 : System.Web.UI.Page
    {
        private static RSA rsa = RSA.Create();
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Goto_Staff_Page(object sender, EventArgs e)
        {
            Response.Redirect("Staff.aspx");
        }
        protected void EGo_click(object sender, EventArgs e)
        {
            // encryption using System.Security.Cryptography local component
            byte[] encrypt = rsa.Encrypt(Encoding.UTF8.GetBytes(eTextBox.Text), RSAEncryptionPadding.Pkcs1); ;
            eText.Text = Convert.ToBase64String(encrypt);
        }
        protected void DGo_click(object sender, EventArgs e)
        {
            // encryption using System.Security.Cryptography local component
            byte[] decrypt = rsa.Decrypt(Convert.FromBase64String(dTextBox.Text), RSAEncryptionPadding.Pkcs1); ;
            dText.Text = Encoding.UTF8.GetString(decrypt);
        }

    }
}