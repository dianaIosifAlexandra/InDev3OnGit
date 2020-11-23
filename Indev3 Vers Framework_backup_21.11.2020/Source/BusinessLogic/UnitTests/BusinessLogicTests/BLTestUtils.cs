using System;

using Inergy.Indev3.BusinessLogic.Catalogues;

namespace Inergy.Indev3.BusinessLogicTests
{
    public class BLTestUtils
    {
        public const string ConnString = "Data Source=patrocle;Initial Catalog=Indev3Work;User ID=sa;Password=sa;";
        public const int COMMAND_TIMEOUT = 120;

        public static void DeleteCountryGLAccounts(int countryId, object connManager)
        {
            //delete the GL accounts created when the country was created
            GlAccount glAccount = new GlAccount(connManager);
            glAccount.IdCountry = countryId;
            glAccount.Id = 1;
            glAccount.SetDeleted();
            glAccount.Save();
            glAccount.Id = 2;
            glAccount.SetDeleted();
            glAccount.Save();
            glAccount.Id = 3;
            glAccount.SetDeleted();
            glAccount.Save();
            glAccount.Id = 4;
            glAccount.SetDeleted();
            glAccount.Save();
            glAccount.Id = 5;
            glAccount.SetDeleted();
            glAccount.Save();
            glAccount.Id = 6;
            glAccount.SetDeleted();
            glAccount.Save();
            glAccount.Id = 7;
            glAccount.SetDeleted();
            glAccount.Save();
        }
    }
}
