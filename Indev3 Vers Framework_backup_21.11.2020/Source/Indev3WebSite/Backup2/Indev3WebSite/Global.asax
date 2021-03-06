<%@ Application Language="C#" %>
<%@ Import Namespace = "System.Data.SqlClient" %>
<%@ Import Namespace = "Inergy.Indev3.WebFramework.Utils" %>
<%@ Import Namespace = "Inergy.Indev3.BusinessLogic" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e) 
    {
        // Code that runs on application startup

    }
    
    void Application_End(object sender, EventArgs e) 
    {
        //  Code that runs on application shutdown

    }
        
    void Application_Error(object sender, EventArgs e) 
    { 
        // Code that runs when an unhandled error occurs

    }

    void Session_Start(object sender, EventArgs e) 
    {
        // Code that runs when a new session is started
    }

    void Session_End(object sender, EventArgs e) 
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.
        object connManager = Session[SessionStrings.CONNECTION_MANAGER];

        if (connManager != null)
        {
            SessionConnectionHelper sessionConnectionHelper = new SessionConnectionHelper();
            sessionConnectionHelper.DisposeConnection(connManager);
        }
    }
       
</script>
