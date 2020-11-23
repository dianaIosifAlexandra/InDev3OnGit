SET IDENTITY_INSERT INDev3Delivery7Patch1..dtproperties ON

INSERT INDev3Delivery7Patch1..dtproperties (id, objectid, property, value, uvalue, lvalue, version)
SELECT T1.id, T1.objectid, T1.property, T1.value, T1.uvalue, T1.lvalue, T1.version
FROM INDev3Work..dtproperties T1
 
SET IDENTITY_Insert INDev3Delivery7Patch1..dtproperties OFF
