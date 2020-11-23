begin tran
--tables
DROP TABLE BRANDS
DROP TABLE BUDGET_PERIODS
DROP TABLE CAPCOM
DROP TABLE PROGRAM_PRODUCTION_INFO
DROP TABLE TECHNOLOGIES
DROP TABLE PROGRAM_PERIMETERS
DROP TABLE CUSTOMERS_LOCATIONS
DROP TABLE CUSTOMERS
DROP TABLE PERIODS
DROP TABLE PRODUCT_FAMILIES
DROP TABLE PROGRAM_CHARACTERISTICS
DROP TABLE PROGRAM_REGULATIONS
DROP TABLE PROGRAM_INFO
DROP TABLE PROGRAM_STATUSES
DROP TABLE PROGRAM_CONFIDENCES

--stored procedures
--1.brand
DROP PROCEDURE catDeleteBrand
DROP PROCEDURE catInsertBrand
DROP PROCEDURE catUpdateBrand
DROP PROCEDURE catSelectBrand

--2.customers
DROP PROCEDURE catInsertCustomer
DROP PROCEDURE catUpdateCustomer
DROP PROCEDURE catDeleteCustomer
DROP PROCEDURE catSelectCustomer

--3.period
--no procedure exist for this entity

--4.Product Family
DROP PROCEDURE catDeleteProductFamily
DROP PROCEDURE catInsertProductFamily
DROP PROCEDURE catUpdateProductFamily
DROP PROCEDURE catSelectProductFamily

--5.Product Family
DROP PROCEDURE catDeleteTechnology
DROP PROCEDURE catInsertTechnology
DROP PROCEDURE catUpdateTechnology
DROP PROCEDURE catSelectTechnology

--6.Capcom
DROP PROCEDURE catDeleteCapcom

DROP PROCEDURE catDeleteGroup
DROP PROCEDURE catDeleteProgramCharacteristic
DROP PROCEDURE catDeleteProgramConfidence
DROP PROCEDURE catDeleteProgramInfo
DROP PROCEDURE catDeleteProgramOrganization
DROP PROCEDURE catDeleteProgramOwner
DROP PROCEDURE catDeleteProgramPerimeter
DROP PROCEDURE catDeleteProgramProductionInfo
DROP PROCEDURE catDeleteProgramRegulation
DROP PROCEDURE catDeleteProgramStatus
DROP PROCEDURE catDeleteProjectNature
DROP PROCEDURE catDeleteSiteType
DROP PROCEDURE catInsertProgramCharacteristic
DROP PROCEDURE catInsertProgramConfidence
DROP PROCEDURE catInsertProgramOrganization
DROP PROCEDURE catInsertProgramOwner
DROP PROCEDURE catInsertProgramPerimeter
DROP PROCEDURE catInsertProgramRegulation
DROP PROCEDURE catInsertProgramStatus
DROP PROCEDURE catInsertProjectNature
DROP PROCEDURE catSelectProgramConfidence
DROP PROCEDURE catSelectProgramOrganization
DROP PROCEDURE catSelectProgramPerimeter
DROP PROCEDURE catSelectProgramRegulation
DROP PROCEDURE catSelectProgramStatus
DROP PROCEDURE catSelectProjectNature
DROP PROCEDURE catUpdateProgramConfidence
DROP PROCEDURE catUpdateProgramOrganization
DROP PROCEDURE catUpdateProgramPerimeter
DROP PROCEDURE catUpdateProgramRegulation
DROP PROCEDURE catUpdateProgramStatus
DROP PROCEDURE catUpdateProjectNature



commit

