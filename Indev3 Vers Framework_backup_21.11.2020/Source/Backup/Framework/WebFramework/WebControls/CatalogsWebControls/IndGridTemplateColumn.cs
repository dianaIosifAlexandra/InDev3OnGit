using System;
using System.Collections.Generic;
using System.Text;
using Telerik.WebControls;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;

namespace Inergy.Indev3.WebFramework.WebControls.CatalogsWebControls
{
    public class IndGridTemplateColumn : GridTemplateColumn
    {

        protected override void SetupFilterControls(System.Web.UI.WebControls.TableCell cell)
        {
            
        }
        protected override void SetCurrentFilterValueToControl(System.Web.UI.WebControls.TableCell cell)
        {
            
        }
    }

    public class ImageYesNoTemplate : ITemplate
    {
        protected Image imgValidation;

        private string ValidationColumn;

        public ImageYesNoTemplate(string validationColumn)
        {
            this.ValidationColumn = validationColumn;
        }

        public void InstantiateIn(Control container)
        {
            imgValidation = new Image();
            imgValidation.ID = "imgValidation";
            imgValidation.DataBinding += new EventHandler(imgValidation_DataBinding);

            container.Controls.Add(imgValidation);
        }

        private void imgValidation_DataBinding(object sender, EventArgs e)
        {
            Image img = (Image)sender;
            GridDataItem container = (GridDataItem)img.NamingContainer;
            if (!(((DataRowView)container.DataItem)[ValidationColumn] is bool))
                return;
            bool validation = (bool)((DataRowView)container.DataItem)[ValidationColumn];
            string imageUrl;
            switch (validation)
            {
                case false:
                    imageUrl = "~/Images/PastilleRed.gif";
                    break;
                case true:
                    imageUrl = "~/Images/PastilleGreen.gif";
                    break;
                default:
                    throw new IndException("Unexpected value in validation column: " + validation);
            }
            img.ImageUrl = imageUrl;
        }
    }

    public class ImageTemplate : ITemplate
    {
        protected Image imgValidation;

        private string ValidationColumn;

        public ImageTemplate(string validationColumn)
        {
            this.ValidationColumn = validationColumn;
        }

        public void InstantiateIn(Control container)
        {
            imgValidation = new Image();
            imgValidation.ID = "imgValidation";
            imgValidation.DataBinding += new EventHandler(imgValidation_DataBinding);

            container.Controls.Add(imgValidation);
        }

        private void imgValidation_DataBinding(object sender, EventArgs e)
        {
            Image img = (Image)sender;
            GridDataItem container = (GridDataItem)img.NamingContainer;
            string validationString = ((DataRowView)container.DataItem)[ValidationColumn].ToString();
            string imageUrl;
            switch (validationString)
            {
                case "O":
                    imageUrl = "~/Images/TrafficOrange.gif";
                    break;
                case "G":
                    imageUrl = "~/Images/TrafficGreen.gif";
                    break;
                case "R":
                    imageUrl = "~/Images/TrafficRed.gif";
                    break;
                default:
                    throw new IndException("Unexpected value in validation column: " + validationString);
            }
            img.ImageUrl = imageUrl;
        }
    }
}
