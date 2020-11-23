using System;
using System.Collections.Generic;
using System.Text;

namespace Inergy.Indev3.BusinessLogic.Authorization
{
    /// <summary>
    /// Contains the operations that can be performed on a module
    /// </summary>
    public enum Operations
    {
        View = 1,
        Add,
        Edit,
        Delete,
        Submit,
        Approve,
        Refuse,
        Validate,
        ManageLogs
    }

    /// <summary>
    /// Contains the permissions that a user has when doing an operation on a certain module
    /// </summary>
    public enum Permissions
    {
        All = 1,
        Restricted,
        None
    }
}
