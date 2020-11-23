using System;
using System.Collections.Generic;
using System.Text;
using System.Reflection;
using Inergy.Indev3.ApplicationFramework.ExceptionHandling;
using Inergy.Indev3.Entities;
using System.Data;

namespace Inergy.Indev3.BusinessLogic
{
    public static class EntityFactory
    {
        public static IGenericEntity GetEntityInstance(Type entityType, object connectionManager)
        {
            IGenericEntity newEntity;
            ConstructorInfo constructor;

            try
            {
                constructor = entityType.GetConstructor(new Type[] { typeof(object) });
                newEntity = (IGenericEntity)constructor.Invoke(new object[] { connectionManager });
            }
            catch (TargetInvocationException exc)
            {
                throw new IndException(exc.InnerException);
            }
            catch (Exception exc)
            {
                throw new IndException(exc);
            }

            return newEntity;
        }
        public static IGenericEntity GetEntityInstance(Type entityType, DataRow row, object connectionManager)
        {
            IGenericEntity newEntity;
            ConstructorInfo constructorInfo;

            try
            {
                constructorInfo = entityType.GetConstructor(new Type[] { typeof(DataRow), typeof(object) });
                newEntity = (IGenericEntity)constructorInfo.Invoke(new object[] { row, connectionManager });
            }
            catch (TargetInvocationException exc)
            {
                throw new IndException(exc.InnerException);
            }
            catch (Exception exc)
            {
                throw new IndException(exc);
            }

            return newEntity;
        }
    }
}
