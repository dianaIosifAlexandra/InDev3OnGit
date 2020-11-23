------------------- REGIONS catalogue-------------------------------------------
--DELETE FROM REGIONS
exec catInsertRegion @Code ='CESA',@Name='Central Europe / South Africa',@Rank=1
exec catInsertRegion @Code ='ASIA',@Name='Continental Asia',@Rank=2
exec catInsertRegion @Code ='NAO',@Name='North America',@Rank=3
exec catInsertRegion @Code ='SPUR',@Name='Spain & Mercosur',@Rank=4
exec catInsertRegion @Code ='FRUK',@Name='Western Europe',@Rank=5
exec catInsertRegion @Code ='CORP',@Name='Corporate',@Rank=6
-------------------END OF REGIONS catalogue------------------------------------

------------------- COUNTRY catalogue------------------------------------------
--DELETE FROM COUNTRIES
exec catInsertCountry @Name ='Argentina', @Code ='ARG',@IdRegion=4, @IdCurrency = 1, @Email='', @Rank=1
exec catInsertCountry @Name ='Belgium', @Code ='BEL',@IdRegion=1, @IdCurrency = 1, @Email='', @Rank=2
exec catInsertCountry @Name ='Brazil', @Code ='BRA',@IdRegion=4, @IdCurrency = 1, @Email='', @Rank=3
exec catInsertCountry @Name ='Canada', @Code ='CAN',@IdRegion=3, @IdCurrency = 1, @Email='', @Rank=4
exec catInsertCountry @Name ='China', @Code ='CHI',@IdRegion=2, @IdCurrency = 1, @Email='', @Rank=5
exec catInsertCountry @Name ='France', @Code ='FRA',@IdRegion=5, @IdCurrency = 1, @Email='', @Rank=6
exec catInsertCountry @Name ='Germany', @Code ='GER',@IdRegion=1, @IdCurrency = 1, @Email='',@Rank=7
exec catInsertCountry @Name ='Japan', @Code ='JPN',@IdRegion=2, @IdCurrency = 1, @Email='', @Rank=8
exec catInsertCountry @Name ='Mexico', @Code ='MEX',@IdRegion=3, @IdCurrency = 1, @Email='', @Rank=9
exec catInsertCountry @Name ='Poland', @Code ='POL',@IdRegion=1, @IdCurrency = 1, @Email='', @Rank=10
exec catInsertCountry @Name ='Romania', @Code ='ROM',@IdRegion=5, @IdCurrency = 1, @Email='', @Rank=11
exec catInsertCountry @Name ='Slovakia', @Code ='SLO',@IdRegion=1, @IdCurrency = 1, @Email='', @Rank=12
exec catInsertCountry @Name ='South Africa', @Code ='SAF',@IdRegion=1, @IdCurrency = 1, @Email='', @Rank=13
exec catInsertCountry @Name ='South Korea', @Code ='KOR',@IdRegion=2, @IdCurrency = 1, @Email='', @Rank=14
exec catInsertCountry @Name ='Spain', @Code ='SPA',@IdRegion=4, @IdCurrency = 1, @Email='', @Rank=15
exec catInsertCountry @Name ='Spain Valla', @Code ='SPV',@IdRegion=4, @IdCurrency = 1, @Email='', @Rank=16
exec catInsertCountry @Name ='Thailand', @Code ='THA',@IdRegion=2, @IdCurrency = 1, @Email='', @Rank=17
exec catInsertCountry @Name ='Turkey', @Code ='TUR',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=18
exec catInsertCountry @Name ='United Kingdom', @Code ='UK_',@IdRegion=5, @IdCurrency = 1, @Email='', @Rank=19
exec catInsertCountry @Name ='USA', @Code ='USA',@IdRegion=3, @IdCurrency = 1, @Email='', @Rank=20
exec catInsertCountry @Name ='Research', @Code ='NOH',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=21
exec catInsertCountry @Name ='Management', @Code ='MAN',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=22
exec catInsertCountry @Name ='Australia', @Code ='AUS',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=23
exec catInsertCountry @Name ='Austria', @Code ='AUT',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=24
exec catInsertCountry @Name ='Bosnia-Herzegovina', @Code ='BIH',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=25
exec catInsertCountry @Name ='Chile', @Code ='CHL',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=26
exec catInsertCountry @Name ='Colombia', @Code ='COL',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=27
exec catInsertCountry @Name ='Czech Republic', @Code ='CZE',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=28
exec catInsertCountry @Name ='Ecuador', @Code ='ECU',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=29
exec catInsertCountry @Name ='Finland', @Code ='FIN',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=30
exec catInsertCountry @Name ='Hungary', @Code ='HUN',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=31
exec catInsertCountry @Name ='India', @Code ='IND',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=32
exec catInsertCountry @Name ='Indonesia', @Code ='IDN',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=33
exec catInsertCountry @Name ='Iran', @Code ='IRN',@IdRegion=5, @IdCurrency = 1, @Email='', @Rank=34
exec catInsertCountry @Name ='Italy', @Code ='ITA',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=35
exec catInsertCountry @Name ='Kazakhstan', @Code ='KAZ',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=36
exec catInsertCountry @Name ='Malaysia', @Code ='MYS',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=37
exec catInsertCountry @Name ='Netherlands', @Code ='NLD',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=38
exec catInsertCountry @Name ='Philippines', @Code ='PHL',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=39
exec catInsertCountry @Name ='Portugal', @Code ='PRT',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=40
exec catInsertCountry @Name ='Russia', @Code ='RUS',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=41
exec catInsertCountry @Name ='Serbia-Montenegro', @Code ='SCG',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=42
exec catInsertCountry @Name ='Slovenia', @Code ='SVN',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=43
exec catInsertCountry @Name ='Sweden', @Code ='SWE',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=44
exec catInsertCountry @Name ='Taiwan', @Code ='TWN',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=45
exec catInsertCountry @Name ='Ukraine', @Code ='UKR',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=46
exec catInsertCountry @Name ='Uruguay', @Code ='URY',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=47
exec catInsertCountry @Name ='Venezuela', @Code ='VEN',@IdRegion=6, @IdCurrency = 1, @Email='', @Rank=48
-------------------END OF COUNTRY catalogue------------------------------------




------------------- INERGY LOCATIONS catalogue------------------------------------------
exec catInsertInergyLocation @Name ='Technical Center Compiègne', @Code ='TCC',@IdCountry=6, @Rank =1
exec catInsertInergyLocation @Name ='Technical Center Laval', @Code ='TCL',@IdCountry=6, @Rank =2
exec catInsertInergyLocation @Name ='Research Center NOH', @Code ='NOH',@IdCountry=21, @Rank =3
exec catInsertInergyLocation @Name ='Technical Center Korea', @Code ='TCK',@IdCountry=14, @Rank =4
exec catInsertInergyLocation @Name ='Technical Center Troy', @Code ='TCT',@IdCountry=20, @Rank =5
exec catInsertInergyLocation @Name ='Adrian', @Code ='ADR',@IdCountry=20, @Rank =6
exec catInsertInergyLocation @Name ='Anderson', @Code ='AND',@IdCountry=20, @Rank =7
exec catInsertInergyLocation @Name ='Arevalo', @Code ='ARE',@IdCountry=15, @Rank =8
exec catInsertInergyLocation @Name ='Blenheim', @Code ='BLE',@IdCountry=4, @Rank =9
exec catInsertInergyLocation @Name ='Brits', @Code ='BRT',@IdCountry=13, @Rank =10
exec catInsertInergyLocation @Name ='Buenos Aires', @Code ='BUE',@IdCountry=1, @Rank =11
exec catInsertInergyLocation @Name ='Bursa', @Code ='BUR',@IdCountry=18, @Rank =12
exec catInsertInergyLocation @Name ='Compiègne', @Code ='COM',@IdCountry=6, @Rank =13
exec catInsertInergyLocation @Name ='Curitiba', @Code ='CUR',@IdCountry=3, @Rank =14
exec catInsertInergyLocation @Name ='Eisenach', @Code ='EIS',@IdCountry=7, @Rank =15
exec catInsertInergyLocation @Name ='Fontaine', @Code ='FON',@IdCountry=6, @Rank =16
exec catInsertInergyLocation @Name ='Grenay', @Code ='GRE',@IdCountry=6, @Rank =17
exec catInsertInergyLocation @Name ='Herentals', @Code ='HER',@IdCountry=2, @Rank =18
exec catInsertInergyLocation @Name ='Kyongju', @Code ='KYO',@IdCountry=14, @Rank =19
exec catInsertInergyLocation @Name ='Kitakyushu', @Code ='KYU',@IdCountry=8, @Rank =20
exec catInsertInergyLocation @Name ='Laval', @Code ='LAV',@IdCountry=6, @Rank =21
exec catInsertInergyLocation @Name ='Lozorno', @Code ='LOZ',@IdCountry=12, @Rank =22
exec catInsertInergyLocation @Name ='Lublin', @Code ='LUB',@IdCountry=10, @Rank =23
exec catInsertInergyLocation @Name ='Nucourt', @Code ='NUC',@IdCountry=6, @Rank =24
exec catInsertInergyLocation @Name ='Oppama', @Code ='OPP',@IdCountry=8, @Rank =25
exec catInsertInergyLocation @Name ='Pfastatt', @Code ='PFA',@IdCountry=6, @Rank =26
exec catInsertInergyLocation @Name ='Pitesti', @Code ='PIT',@IdCountry=11, @Rank =27
exec catInsertInergyLocation @Name ='Ramos Arizpe', @Code ='RAM',@IdCountry=9, @Rank =28
exec catInsertInergyLocation @Name ='Rayong', @Code ='RAY',@IdCountry=17, @Rank =29
exec catInsertInergyLocation @Name ='Rottenburg', @Code ='ROT',@IdCountry=7, @Rank =30
exec catInsertInergyLocation @Name ='Telford', @Code ='TEL',@IdCountry=19, @Rank =31
exec catInsertInergyLocation @Name ='Valladolid', @Code ='VAL',@IdCountry=15, @Rank =32
exec catInsertInergyLocation @Name ='Vigo', @Code ='VIG',@IdCountry=15, @Rank =33
exec catInsertInergyLocation @Name ='Kyushu', @Code ='KSH',@IdCountry=8, @Rank =34
exec catInsertInergyLocation @Name ='Aulnay', @Code ='AUL',@IdCountry=6, @Rank =35
exec catInsertInergyLocation @Name ='Bratislava', @Code ='BVA',@IdCountry=12, @Rank =36
exec catInsertInergyLocation @Name ='Brussels', @Code ='BRU',@IdCountry=2, @Rank =37
exec catInsertInergyLocation @Name ='Coventry', @Code ='COV',@IdCountry=19, @Rank =38
exec catInsertInergyLocation @Name ='Duncan', @Code ='DUN',@IdCountry=20, @Rank =39
exec catInsertInergyLocation @Name ='Ellesmere Port', @Code ='ELL',@IdCountry=19, @Rank =40
exec catInsertInergyLocation @Name ='Flörsheim ', @Code ='FLO',@IdCountry=7, @Rank =41
exec catInsertInergyLocation @Name ='Grand Bourg', @Code ='GRB',@IdCountry=1, @Rank =42
exec catInsertInergyLocation @Name ='Norcross', @Code ='NOR',@IdCountry=20, @Rank =43
exec catInsertInergyLocation @Name ='Pindamonhangaba', @Code ='PIN',@IdCountry=3, @Rank =44
exec catInsertInergyLocation @Name ='Port Elizabeth', @Code ='POE',@IdCountry=13, @Rank =45
exec catInsertInergyLocation @Name ='Rennes – La Touche Tizon', @Code ='RST',@IdCountry=6, @Rank =46
exec catInsertInergyLocation @Name ='Sandouville', @Code ='SAN',@IdCountry=6, @Rank =47
exec catInsertInergyLocation @Name ='Karben', @Code ='KAR',@IdCountry=7, @Rank =48
exec catInsertInergyLocation @Name ='München', @Code ='MUN',@IdCountry=7, @Rank =49
exec catInsertInergyLocation @Name ='Paris', @Code ='PAR',@IdCountry=6, @Rank =50
exec catInsertInergyLocation @Name ='Raunheim', @Code ='RAU',@IdCountry=7, @Rank =51
exec catInsertInergyLocation @Name ='Suwon City/Seoul', @Code ='SEO',@IdCountry=14, @Rank =52
exec catInsertInergyLocation @Name ='Tokyo Shibuya', @Code ='SHI',@IdCountry=8, @Rank =53
exec catInsertInergyLocation @Name ='Troy', @Code ='TRO',@IdCountry=20, @Rank =54
exec catInsertInergyLocation @Name ='Poissy', @Code ='POI',@IdCountry=6, @Rank =55
exec catInsertInergyLocation @Name ='Trnava', @Code ='TRN',@IdCountry=12, @Rank =56
exec catInsertInergyLocation @Name ='Hordain - Valenciennes', @Code ='HOR',@IdCountry=6, @Rank =57
exec catInsertInergyLocation @Name ='Wuhan', @Code ='WUH',@IdCountry=5, @Rank =58
exec catInsertInergyLocation @Name ='Beijing', @Code ='BEJ',@IdCountry=5, @Rank =59
exec catInsertInergyLocation @Name ='das', @Code ='dsa',@IdCountry=1, @Rank =60

-------------------END OF INERGY LOCATIONS catalogue------------------------------------

------------------- ASSOCIATES catalogue------------------------------------------
BEGIN TRAN
exec catInsertAssociate @IdCountry=34, @Name ='Mocanu, Andrei', @EmployeeNumber ='123456789', @InergyLogin ='akelainf\amocanu', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=34, @Name ='Burtan, Ionel', @EmployeeNumber ='23456789', @InergyLogin ='akelainf\ionelb', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
INSERT INTO ASSOCIATE_ROLES VALUES (1,2)
INSERT INTO ASSOCIATE_ROLES VALUES (2,2)
exec catInsertAssociate @IdCountry=35, @Name ='Adrian', @EmployeeNumber ='0', @InergyLogin ='gyr.f', @IsActive =1, @IsSubcontractor =1, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=17, @Name ='Cauvin, Pascal', @EmployeeNumber ='640163', @InergyLogin ='cauvin.p', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=3, @Name ='Clery, Pierre', @EmployeeNumber ='640176', @InergyLogin ='clery.p', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=1, @Name ='Gyr, Frédéric', @EmployeeNumber ='640290', @InergyLogin ='gyr.f', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=11, @Name ='Le-bihan, Gervais', @EmployeeNumber ='640325', @InergyLogin ='lebihan.g', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=9, @Name ='Leroy, Christian', @EmployeeNumber ='640347', @InergyLogin ='leroy.c', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=35, @Name ='Redzimski, Frederic', @EmployeeNumber ='640443', @InergyLogin ='redzimski.f', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=10, @Name ='Wirth, Alexander', @EmployeeNumber ='200058', @InergyLogin ='GE200058', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=13, @Name ='Weyel, Isabelle', @EmployeeNumber ='230002', @InergyLogin ='GE230002', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=2, @Name ='Comte, Christophe', @EmployeeNumber ='230003', @InergyLogin ='GE230003', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=39, @Name ='Greiser, Manfred', @EmployeeNumber ='230012', @InergyLogin ='GE230012', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=6, @Name ='Dreut, Olivier', @EmployeeNumber ='230020', @InergyLogin ='GE230020', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=25, @Name ='Spee, Alexander', @EmployeeNumber ='230022', @InergyLogin ='GE230022', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=40, @Name ='Olbrich, Frank', @EmployeeNumber ='230029', @InergyLogin ='GE230029', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=37, @Name ='sdf', @EmployeeNumber ='23', @InergyLogin ='sdf', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=39, @Name ='Verwoort, Kristoff', @EmployeeNumber ='bel2', @InergyLogin ='Kristoff.Vervoort', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=5, @Name ='Cho, Seong-Hoon', @EmployeeNumber ='770729', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=37, @Name ='Ju, Myung-Ha', @EmployeeNumber ='92001', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=36, @Name ='Cronier, Joël', @EmployeeNumber ='630457', @InergyLogin ='FR30457', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=24, @Name ='Laclos, Jean-Marie', @EmployeeNumber ='630458', @InergyLogin ='FR30458', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=21, @Name ='Beloin, Pascal', @EmployeeNumber ='630534', @InergyLogin ='FR30534', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=4, @Name ='Bernardeau, Laurent', @EmployeeNumber ='630535', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=45, @Name ='Palermo, Christian', @EmployeeNumber ='630743', @InergyLogin ='FR30743', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=22, @Name ='Crochet, Christophe', @EmployeeNumber ='630871', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=18, @Name ='Lecourt, Gerard', @EmployeeNumber ='630993', @InergyLogin ='FR88731', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=27, @Name ='Monne, Michel', @EmployeeNumber ='631048', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=13, @Name ='Veron, Michel', @EmployeeNumber ='631143', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=19, @Name ='Lemonnier, Hervé', @EmployeeNumber ='632040', @InergyLogin ='FR32040', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=33, @Name ='Libert, Nikit', @EmployeeNumber ='634990', @InergyLogin ='FR34990', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=45, @Name ='Belniak, Jaroslaw', @EmployeeNumber ='LUB1', @InergyLogin ='BelniaJ', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=1, @Name ='Kus, Agnieszka', @EmployeeNumber ='LUB2', @InergyLogin ='KusA', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=30, @Name ='Grudzien, Artur', @EmployeeNumber ='LUB3', @InergyLogin ='GrudziA', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=7, @Name ='Wojtowicz, Grezgorz', @EmployeeNumber ='LUB4', @InergyLogin ='WojtowG', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=7, @Name ='Karolak, Ireneusz', @EmployeeNumber ='LUB5', @InergyLogin ='KarolaI', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=31, @Name ='Bauriedl, Martin', @EmployeeNumber ='200016', @InergyLogin ='GE200016', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=41, @Name ='Oxfort, Andreas', @EmployeeNumber ='200031', @InergyLogin ='GE200031', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=26, @Name ='Renje, Christian', @EmployeeNumber ='200044', @InergyLogin ='GE200044', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=31, @Name ='Farkas, Attila', @EmployeeNumber ='200070', @InergyLogin ='GE200069', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=44, @Name ='Labaye, Bruno', @EmployeeNumber ='200073', @InergyLogin ='GE200073', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=13, @Name ='Malcharczik, Matthias', @EmployeeNumber ='200077', @InergyLogin ='GE200077', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=32, @Name ='Knobloch, Peter', @EmployeeNumber ='210010', @InergyLogin ='GE210010', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Roemer, Robert', @EmployeeNumber ='GE200081', @InergyLogin ='GE200081', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=22, @Name ='Bernard, Pierre', @EmployeeNumber ='634141', @InergyLogin ='FR34141', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=25, @Name ='Kern, Wolfgang', @EmployeeNumber ='200061', @InergyLogin ='GE200061', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=30, @Name ='Launay, Marie-helene', @EmployeeNumber ='2', @InergyLogin ='THIASMHL', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=31, @Name ='Olarnratmanee, Chitson', @EmployeeNumber ='4', @InergyLogin ='THIASCSO', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=37, @Name ='Plissart, Paul', @EmployeeNumber ='6689', @InergyLogin ='BE06689', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=12, @Name ='Senelier, Sandrine', @EmployeeNumber ='40644', @InergyLogin ='senelier.s', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=7, @Name ='Fournillon, Yahn', @EmployeeNumber ='40716', @InergyLogin ='ias-yfour', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=46, @Name ='Rebillon, Victor', @EmployeeNumber ='624809', @InergyLogin ='FR24809', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=13, @Name ='Hulot, Jacky', @EmployeeNumber ='630484', @InergyLogin ='FR30484', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=35, @Name ='Dubois, Odile', @EmployeeNumber ='630798', @InergyLogin ='FR30798', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=32, @Name ='Lemonnier, Valérie', @EmployeeNumber ='630825', @InergyLogin ='FR30825', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=35, @Name ='Moreau, Martine', @EmployeeNumber ='630826', @InergyLogin ='FR30826', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=12, @Name ='Graindorge, Thierry', @EmployeeNumber ='630935', @InergyLogin ='FR30935', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=32, @Name ='Lebailly, Daniel', @EmployeeNumber ='630986', @InergyLogin ='FR30986', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=43, @Name ='Manoury, Pierre-Louis', @EmployeeNumber ='631023', @InergyLogin ='FR31023', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=7, @Name ='Touchard, Jean-Pierre', @EmployeeNumber ='632297', @InergyLogin ='FR32297', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=27, @Name ='Teroitin, Luc', @EmployeeNumber ='634068', @InergyLogin ='FR34068', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=28, @Name ='Duval, Stephane', @EmployeeNumber ='634153', @InergyLogin ='FR34153', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=40, @Name ='Cordier, Stephanie', @EmployeeNumber ='634305', @InergyLogin ='FR34305', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=43, @Name ='Cottereau, Laurent', @EmployeeNumber ='634306', @InergyLogin ='FR34306', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=45, @Name ='Maretheu, Eric', @EmployeeNumber ='634434', @InergyLogin ='FR34434', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=5, @Name ='Louis, Damien', @EmployeeNumber ='634528', @InergyLogin ='FR34528', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=39, @Name ='Rouanet, Philippe', @EmployeeNumber ='635108', @InergyLogin ='FR35108', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=30, @Name ='Galliot, Stephane', @EmployeeNumber ='635114', @InergyLogin ='galliot.s', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=22, @Name ='Toutain, Stephane', @EmployeeNumber ='635178', @InergyLogin ='toutain.s', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=25, @Name ='Beaussier, Severine', @EmployeeNumber ='635537', @InergyLogin ='FR35537', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=31, @Name ='Guillet, Laurent', @EmployeeNumber ='635566', @InergyLogin ='FR35566', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=28, @Name ='Guillouet, Cédric', @EmployeeNumber ='635705', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=46, @Name ='Scandola, Olivier', @EmployeeNumber ='639991', @InergyLogin ='scandola.o', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=44, @Name ='Stawarski, Robert', @EmployeeNumber ='639999', @InergyLogin ='stawarski.r', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=39, @Name ='Biebow, Patrick', @EmployeeNumber ='640008', @InergyLogin ='biebow.p', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=14, @Name ='Bleriot, Xavier', @EmployeeNumber ='640010', @InergyLogin ='bleriot.x', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=32, @Name ='Boucaux, Eric', @EmployeeNumber ='640011', @InergyLogin ='boucaux.e', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=42, @Name ='Coste, Christian', @EmployeeNumber ='640012', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=35, @Name ='Dauchet, Francis', @EmployeeNumber ='640015', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=12, @Name ='Dhaussy, Franck', @EmployeeNumber ='640017', @InergyLogin ='dhaussy.f', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=37, @Name ='Duprez, Claudine', @EmployeeNumber ='640018', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=14, @Name ='Heudel, Jean-Luc', @EmployeeNumber ='640024', @InergyLogin ='heudel.jl', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=10, @Name ='Jacqmart, Denis', @EmployeeNumber ='640026', @InergyLogin ='jacqmart.d', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=40, @Name ='Lachaise, Robert', @EmployeeNumber ='640029', @InergyLogin ='lachaise.r', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=2, @Name ='Marchal, Stephanie', @EmployeeNumber ='640034', @InergyLogin ='marchal.s', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=23, @Name ='Nokerman, Jean', @EmployeeNumber ='640036', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=35, @Name ='Rosseel, Alexis', @EmployeeNumber ='640040', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=4, @Name ='Thon, Jean-Philippe', @EmployeeNumber ='640043', @InergyLogin ='thon.jp', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Pohlmann, Ralph', @EmployeeNumber ='640053', @InergyLogin ='pohlmann.r', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=26, @Name ='Casier, Patrick', @EmployeeNumber ='640054', @InergyLogin ='casier.p', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=5, @Name ='Bieth, Florence', @EmployeeNumber ='640058', @InergyLogin ='FR40058', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=26, @Name ='Oberle, Jean-Luc', @EmployeeNumber ='640059', @InergyLogin ='oberle.jl', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=14, @Name ='Mollet, Frederic', @EmployeeNumber ='640060', @InergyLogin ='mollet.f', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=24, @Name ='Cassarin-Grand, Laurent', @EmployeeNumber ='640061', @InergyLogin ='cassarin-grand.l', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=5, @Name ='Gauthier, Yves', @EmployeeNumber ='640062', @InergyLogin ='gauthier.y', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=43, @Name ='Frejean, Thierry', @EmployeeNumber ='640063', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=10, @Name ='Lemoine, Hervé', @EmployeeNumber ='640064', @InergyLogin ='lemoine.h', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=11, @Name ='Chanier, Hélène', @EmployeeNumber ='640065', @InergyLogin ='chanier.h', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=45, @Name ='Firtion, Eric', @EmployeeNumber ='640076', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=4, @Name ='Forriere, Barbara', @EmployeeNumber ='640077', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=10, @Name ='Georis, Philippe', @EmployeeNumber ='640078', @InergyLogin ='georis.p', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=34, @Name ='Delande, Muriel', @EmployeeNumber ='640079', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=31, @Name ='Lamazou, Anne', @EmployeeNumber ='640085', @InergyLogin ='lamazou.a', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=23, @Name ='Desachy, Jean-Luc', @EmployeeNumber ='640088', @InergyLogin ='desachy.jl', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=37, @Name ='Lopata, Christian', @EmployeeNumber ='640089', @InergyLogin ='lopata.c', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=22, @Name ='Mur, Jean-Claude', @EmployeeNumber ='640091', @InergyLogin ='mur.jc', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=29, @Name ='Martin, Stephane', @EmployeeNumber ='640092', @InergyLogin ='martin.s', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=1, @Name ='Boulay, Didier', @EmployeeNumber ='640095', @InergyLogin ='boulay.d', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=20, @Name ='Zorzato, Jean-Claude', @EmployeeNumber ='640103', @InergyLogin ='zorzato.jc', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=24, @Name ='Albert, Ludivine', @EmployeeNumber ='640110', @InergyLogin ='albert.l', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=43, @Name ='Amiard, Jean-Pierre', @EmployeeNumber ='640111', @InergyLogin ='amiard.jp', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=20, @Name ='Marbach, Gaelle', @EmployeeNumber ='640112', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=25, @Name ='Aubert, Gaetan', @EmployeeNumber ='640116', @InergyLogin ='aubert.g', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=8, @Name ='Auxenfans, Nicolas', @EmployeeNumber ='640117', @InergyLogin ='auxenfans.n', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=9, @Name ='Bahramian, Kourosh', @EmployeeNumber ='640119', @InergyLogin ='bahramk', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=18, @Name ='Bajor, Franck', @EmployeeNumber ='640120', @InergyLogin ='bajor.f', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=24, @Name ='Baudoux, Benoit', @EmployeeNumber ='640126', @InergyLogin ='baudoux.b', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=7, @Name ='Baudoux, Patrice', @EmployeeNumber ='640127', @InergyLogin ='baudoux.p', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=26, @Name ='Bonkowski, Marc', @EmployeeNumber ='640143', @InergyLogin ='bonkowski.m', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=2, @Name ='Bouda, Zohir', @EmployeeNumber ='640147', @InergyLogin ='bouda.z', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=26, @Name ='Broux, Pascal', @EmployeeNumber ='640151', @InergyLogin ='broux.p', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=19, @Name ='Carlier, Francis', @EmployeeNumber ='640158', @InergyLogin ='carlier.f', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=42, @Name ='Carlier, Philippe', @EmployeeNumber ='640159', @InergyLogin ='carlier.p', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=38, @Name ='Castel, Olivier', @EmployeeNumber ='640162', @InergyLogin ='castel.o', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=38, @Name ='Coquelle, Pierre', @EmployeeNumber ='640179', @InergyLogin ='coquelp', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=43, @Name ='Couillaud, Jerome', @EmployeeNumber ='640184', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=45, @Name ='Gazaud, Blandine', @EmployeeNumber ='640185', @InergyLogin ='FR40185', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=42, @Name ='Couturier, Thibaut', @EmployeeNumber ='640186', @InergyLogin ='couturier.t', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=17, @Name ='Decobert, Philippe', @EmployeeNumber ='640202', @InergyLogin ='decobert.p', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=40, @Name ='Delannoy, Catherine', @EmployeeNumber ='640208', @InergyLogin ='delannoy.c', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=42, @Name ='Delville, Priscilla', @EmployeeNumber ='640211', @InergyLogin ='delville.p', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=11, @Name ='Dequin, Marc', @EmployeeNumber ='640217', @InergyLogin ='dequin.m', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=25, @Name ='Descendre, Emmanuel', @EmployeeNumber ='640220', @InergyLogin ='descendres.e', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=35, @Name ='Desjardin, Dominique', @EmployeeNumber ='640221', @InergyLogin ='desjardins.d', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=18, @Name ='Devillers, Camille', @EmployeeNumber ='640228', @InergyLogin ='devillers.c', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=46, @Name ='Ducrot, Bertrand', @EmployeeNumber ='640244', @InergyLogin ='ducrot.b', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=32, @Name ='Dufresne, Gerald', @EmployeeNumber ='640245', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=3, @Name ='Duhan, Eric', @EmployeeNumber ='640246', @InergyLogin ='duhan.e', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=28, @Name ='Durieux, Pascal', @EmployeeNumber ='640251', @InergyLogin ='durieux.p', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=33, @Name ='Escande, Thierry', @EmployeeNumber ='640255', @InergyLogin ='escande.t', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=32, @Name ='Fleuriot, Hubert', @EmployeeNumber ='640259', @InergyLogin ='fleuriot.h', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=44, @Name ='Galleux, Elisabeth', @EmployeeNumber ='640270', @InergyLogin ='galleux.e', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=33, @Name ='Gazaud, William', @EmployeeNumber ='640273', @InergyLogin ='gazaud.w', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=12, @Name ='George, Andre', @EmployeeNumber ='640275', @InergyLogin ='george.a', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=5, @Name ='Guinard, Patrick', @EmployeeNumber ='640287', @InergyLogin ='guinard.p', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=17, @Name ='Guyotte, Laurent', @EmployeeNumber ='640288', @InergyLogin ='guyotte.l', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=34, @Name ='Guyotte, Stephane', @EmployeeNumber ='640289', @InergyLogin ='guyotte.s', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=17, @Name ='Hamart, Olivier', @EmployeeNumber ='640293', @InergyLogin ='hamart.o', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=34, @Name ='Hilaire, Chantal', @EmployeeNumber ='640299', @InergyLogin ='hilaire.c', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=27, @Name ='Keovongkot, Bounsom', @EmployeeNumber ='640308', @InergyLogin ='keovongkot.b', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=9, @Name ='Lavier, Betty', @EmployeeNumber ='640322', @InergyLogin ='lavier.b', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=13, @Name ='Le Mentec, Nathalie', @EmployeeNumber ='640323', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Le Guillou, Bernard', @EmployeeNumber ='640326', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=5, @Name ='Lefevre, Philippe', @EmployeeNumber ='640335', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=34, @Name ='Lemaitre, Bernard', @EmployeeNumber ='640341', @InergyLogin ='lemaitre.b', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=28, @Name ='Lepori, Delphine', @EmployeeNumber ='640344', @InergyLogin ='lepori.d', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=18, @Name ='Letupe, Alain', @EmployeeNumber ='640349', @InergyLogin ='Letupe.a', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=11, @Name ='Lopata, Vincent', @EmployeeNumber ='640353', @InergyLogin ='lopata.v', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Matuszewski, Franck', @EmployeeNumber ='640372', @InergyLogin ='matuszewski.f', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=7, @Name ='Menager, Marie-Pierre', @EmployeeNumber ='640374', @InergyLogin ='menager.mp', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=42, @Name ='Menetrier, Francois', @EmployeeNumber ='640376', @InergyLogin ='menetrier.f', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=23, @Name ='Moisan, Michel', @EmployeeNumber ='640386', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=32, @Name ='Myslinski, Thierry', @EmployeeNumber ='640395', @InergyLogin ='myslinski.t', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=19, @Name ='Parmentier, Hubert', @EmployeeNumber ='640408', @InergyLogin ='parmentier.h', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=4, @Name ='Pellegrinelli, Alain', @EmployeeNumber ='640411', @InergyLogin ='pellegrinelli.a', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=45, @Name ='Perdriau, Eddy', @EmployeeNumber ='640414', @InergyLogin ='perdrieau.e', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=38, @Name ='Pereira, Manuel', @EmployeeNumber ='640416', @InergyLogin ='pereira.m', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=26, @Name ='Perrin, Betty', @EmployeeNumber ='640419', @InergyLogin ='perrin.b', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=43, @Name ='Petit, Sylvie', @EmployeeNumber ='640421', @InergyLogin ='petit.s', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=19, @Name ='Pin, Solange', @EmployeeNumber ='640426', @InergyLogin ='pin.s', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=28, @Name ='Prouet, Bruno', @EmployeeNumber ='640437', @InergyLogin ='prouet.b', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=15, @Name ='Quidecon, Patrice', @EmployeeNumber ='640441', @InergyLogin ='quidecon.p', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=4, @Name ='Roccasalva, Philippe', @EmployeeNumber ='640449', @InergyLogin ='roccasalva.p', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=26, @Name ='Rondon, Jean-Luc', @EmployeeNumber ='640451', @InergyLogin ='rondon.jl', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=29, @Name ='Routier, Franck', @EmployeeNumber ='640455', @InergyLogin ='routier.f', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=45, @Name ='Routier, Olivier', @EmployeeNumber ='640456', @InergyLogin ='routier.o', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=7, @Name ='Ruyant, Olivier', @EmployeeNumber ='640459', @InergyLogin ='ruyant.o', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=34, @Name ='Rybkowski, Christian', @EmployeeNumber ='640460', @InergyLogin ='rybkowski.c', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Souply, Yann', @EmployeeNumber ='640474', @InergyLogin ='souplyy', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=17, @Name ='Soyer, Andre', @EmployeeNumber ='640476', @InergyLogin ='soyer.an', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=28, @Name ='Swiac, Philippe', @EmployeeNumber ='640481', @InergyLogin ='swiac.p', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=3, @Name ='Terrien, Eric', @EmployeeNumber ='640486', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=38, @Name ='Thian, Gilles', @EmployeeNumber ='640491', @InergyLogin ='thiant.g', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=14, @Name ='Thiesset, Patrick', @EmployeeNumber ='640492', @InergyLogin ='thiessp', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=8, @Name ='Thisselin, Bertrand', @EmployeeNumber ='640494', @InergyLogin ='thisselin.b', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=33, @Name ='Trehou, Benoit', @EmployeeNumber ='640503', @InergyLogin ='trehou.b', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=5, @Name ='Turpin, Jean-Marc', @EmployeeNumber ='640507', @InergyLogin ='turpin.jm', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=38, @Name ='Vasseur, Philippe', @EmployeeNumber ='640518', @InergyLogin ='vasseur p', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=37, @Name ='Wolck, Daniel', @EmployeeNumber ='640536', @InergyLogin ='wolck.d', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=36, @Name ='Woszczyk, Laurent', @EmployeeNumber ='640537', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=43, @Name ='Zagula, Nathalie', @EmployeeNumber ='640540', @InergyLogin ='zagula.n', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=9, @Name ='Ruat, Francois', @EmployeeNumber ='640548', @InergyLogin ='ruat.f', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=7, @Name ='Gautherin, Bernard', @EmployeeNumber ='640550', @InergyLogin ='gautherin.b', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=9, @Name ='Druesnes, Elodie', @EmployeeNumber ='640551', @InergyLogin ='druesnes.e', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=25, @Name ='Le Men, Marine', @EmployeeNumber ='640554', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=39, @Name ='Beaulieux, Franck', @EmployeeNumber ='640558', @InergyLogin ='beaulieux.f', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=23, @Name ='Fomer, Laurent', @EmployeeNumber ='640562', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=41, @Name ='Coing, Jean-Francois', @EmployeeNumber ='640564', @InergyLogin ='Coing.jf', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=13, @Name ='Laune, Karine', @EmployeeNumber ='640574', @InergyLogin ='laune.k', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=12, @Name ='Duprat, Iris', @EmployeeNumber ='640583', @InergyLogin ='duprat.i', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=28, @Name ='Briche, Christine', @EmployeeNumber ='640590', @InergyLogin ='briche.c', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=13, @Name ='Charbonnet, Philippe', @EmployeeNumber ='640593', @InergyLogin ='charbonnet.p', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=29, @Name ='Lefebvre, Yann', @EmployeeNumber ='640599', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=9, @Name ='Laumonerie, Frederic', @EmployeeNumber ='640600', @InergyLogin ='laumonerie.f', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=8, @Name ='Munoz-Amaro, Carolina', @EmployeeNumber ='640602', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=37, @Name ='Texier, Raphael', @EmployeeNumber ='640609', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=16, @Name ='Blanchot Cailleretz, Penelope', @EmployeeNumber ='640610', @InergyLogin ='cailleretz.p', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=42, @Name ='Potier, Alain', @EmployeeNumber ='640611', @InergyLogin ='potier.a', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=44, @Name ='Mercier, Maxime', @EmployeeNumber ='640614', @InergyLogin ='mercier.m', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=3, @Name ='Basire, Didier', @EmployeeNumber ='640615', @InergyLogin ='basire.d', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=21, @Name ='Domanski, Jean-Philippe', @EmployeeNumber ='640618', @InergyLogin ='domanski.jp', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=21, @Name ='El-Ouali, Omar', @EmployeeNumber ='640619', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=46, @Name ='Pierre, Eric', @EmployeeNumber ='640625', @InergyLogin ='pierre.e', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=40, @Name ='Duez, Laurent', @EmployeeNumber ='640628', @InergyLogin ='duez.l', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=40, @Name ='Coulon, Philippe', @EmployeeNumber ='640629', @InergyLogin ='coulon.p', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=14, @Name ='Thouvenin, Odile', @EmployeeNumber ='640633', @InergyLogin ='thouvenin.o', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Dufays, Emmanuel', @EmployeeNumber ='640636', @InergyLogin ='dufays.e', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=34, @Name ='Monel, Sylvie', @EmployeeNumber ='640640', @InergyLogin ='monel.s', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=40, @Name ='Elkhanfari, Souad', @EmployeeNumber ='640642', @InergyLogin ='elkhanfari.s', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=6, @Name ='Belkessam, Samya', @EmployeeNumber ='640645', @InergyLogin ='belkessam.s', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=19, @Name ='Guillemont, Isabelle', @EmployeeNumber ='640646', @InergyLogin ='guillemont.i', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=20, @Name ='Monie, Marc', @EmployeeNumber ='640650', @InergyLogin ='monie.m', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=17, @Name ='Capuzzo, Veronique', @EmployeeNumber ='640652', @InergyLogin ='capuzzo.v', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=14, @Name ='Wils, Olivier', @EmployeeNumber ='640655', @InergyLogin ='wils.o', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=16, @Name ='Blieux, Alex', @EmployeeNumber ='640656', @InergyLogin ='blieux.a', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=40, @Name ='Thisselin, Cathy', @EmployeeNumber ='640657', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=36, @Name ='Cohen, Benjamin', @EmployeeNumber ='640658', @InergyLogin ='cohen.b', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=32, @Name ='Volto, Eric', @EmployeeNumber ='640676', @InergyLogin ='volto.e', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=15, @Name ='Dupuy, Ludovic', @EmployeeNumber ='640678', @InergyLogin ='dupuy.l', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Demougin, Marc', @EmployeeNumber ='640687', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=14, @Name ='Guillerme, Hervé', @EmployeeNumber ='640694', @InergyLogin ='guillerme.h', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=36, @Name ='Walling, Nadja', @EmployeeNumber ='640696', @InergyLogin ='walling.n', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=18, @Name ='Paolini, Gwereg', @EmployeeNumber ='640697', @InergyLogin ='paolini.g', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=9, @Name ='Bourely, Serge', @EmployeeNumber ='640699', @InergyLogin ='bourely.s', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=26, @Name ='Izvolensky, Vladislav', @EmployeeNumber ='640701', @InergyLogin ='izvolensky.v', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=22, @Name ='Frerejean, Damien', @EmployeeNumber ='640704', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=31, @Name ='De-Novion, Stanislas', @EmployeeNumber ='640709', @InergyLogin ='denovion.s', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=24, @Name ='Laborde, Fabrice', @EmployeeNumber ='640731', @InergyLogin ='laborde.f', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=30, @Name ='Lemasson, Wilfried', @EmployeeNumber ='640818', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=9, @Name ='Oszwald, Pierre', @EmployeeNumber ='640823', @InergyLogin ='oszwald.p', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=43, @Name ='Meyer, Caroline', @EmployeeNumber ='640832', @InergyLogin ='FR40832', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=11, @Name ='Le Men, Marine', @EmployeeNumber ='640833', @InergyLogin ='lemen.m', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=33, @Name ='Lemasson, Wilfried', @EmployeeNumber ='640844', @InergyLogin ='lemasson.w', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=20, @Name ='Lindgren, Henrik', @EmployeeNumber ='640845', @InergyLogin ='FR40845', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=30, @Name ='Flatet, Ludovic', @EmployeeNumber ='640846', @InergyLogin ='FR88481', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=26, @Name ='Bertin, Cindy', @EmployeeNumber ='640848', @InergyLogin ='FR88622', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=40, @Name ='Auvergne, Gregory', @EmployeeNumber ='640863', @InergyLogin ='FR40863', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=9, @Name ='Bordier, Luc', @EmployeeNumber ='640868', @InergyLogin ='FR40868', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=6, @Name ='Berg, Gert', @EmployeeNumber ='640875', @InergyLogin ='FR88685', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=17, @Name ='Goodwin, Armelle', @EmployeeNumber ='640878', @InergyLogin ='FR88621', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Francini, Francois', @EmployeeNumber ='640883', @InergyLogin ='FR40883', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=26, @Name ='Cambier, Corinne', @EmployeeNumber ='640884', @InergyLogin ='FR88639', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=16, @Name ='Durupt, Marc', @EmployeeNumber ='640889', @InergyLogin ='FR40889', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=35, @Name ='Junot, Etienne', @EmployeeNumber ='640891', @InergyLogin ='junot.e', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=5, @Name ='Zhang, Zhenquan', @EmployeeNumber ='640894', @InergyLogin ='FR40851', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=28, @Name ='Plet, Mickael', @EmployeeNumber ='640901', @InergyLogin ='FR40901', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=43, @Name ='Parrain, Franck', @EmployeeNumber ='640915', @InergyLogin ='FR40915', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=27, @Name ='Quennelle, Jean-Roger', @EmployeeNumber ='640924', @InergyLogin ='FR88881', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=13, @Name ='Jeronimo, Ana', @EmployeeNumber ='640926', @InergyLogin ='BE05651', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Thielan, Hervé', @EmployeeNumber ='640935', @InergyLogin ='thielah', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=30, @Name ='Vasek, Jan', @EmployeeNumber ='640950', @InergyLogin ='vasekj', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=41, @Name ='Lamy, Bruno', @EmployeeNumber ='65432', @InergyLogin ='ias-blamy', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Courcelle, Stéphanie', @EmployeeNumber ='687972', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=43, @Name ='Flatet, Ludovic', @EmployeeNumber ='688481', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=46, @Name ='Pichaisawad, Praves', @EmployeeNumber ='688570', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=5, @Name ='Bauer, Martin', @EmployeeNumber ='688575', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=32, @Name ='Bauriedl, Martin', @EmployeeNumber ='688576', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=32, @Name ='Wimmersberger, Richard', @EmployeeNumber ='688577', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=4, @Name ='Oxfort, Andreas', @EmployeeNumber ='688578', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=14, @Name ='Kern, Wolfgang', @EmployeeNumber ='688579', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=5, @Name ='Knoblock, Peter', @EmployeeNumber ='688580', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=47, @Name ='Junot, Etienne', @EmployeeNumber ='688582', @InergyLogin ='junot.e', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=26, @Name ='Op de Beeck, Joël', @EmployeeNumber ='688583', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=10, @Name ='Wolf, Guido', @EmployeeNumber ='688584', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=37, @Name ='Ridon, Ludovic', @EmployeeNumber ='688586', @InergyLogin ='ridon.l', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=33, @Name ='Khammar, Mustapha', @EmployeeNumber ='688587', @InergyLogin ='khammar.m', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=45, @Name ='Luisin, Vincent', @EmployeeNumber ='688588', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=3, @Name ='Renje, Christian', @EmployeeNumber ='688592', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Santner, Christian', @EmployeeNumber ='688593', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=28, @Name ='Zimmermann, Markus', @EmployeeNumber ='688594', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=45, @Name ='Dubois, Alain', @EmployeeNumber ='688596', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=19, @Name ='Overt, Benoit', @EmployeeNumber ='688597', @InergyLogin ='FR88597', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=7, @Name ='Mouton, Sylvain', @EmployeeNumber ='688598', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=6, @Name ='Petibon, Charles', @EmployeeNumber ='688599', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=33, @Name ='Rabat, Philippe', @EmployeeNumber ='688600', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=21, @Name ='Kim, Byung Hyun', @EmployeeNumber ='688603', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=14, @Name ='Journée, Maurice', @EmployeeNumber ='688613', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=34, @Name ='INVENIO', @EmployeeNumber ='688617', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=32, @Name ='ACTIVETECH', @EmployeeNumber ='688626', @InergyLogin ='', @IsActive =0, @IsSubcontractor =1, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=43, @Name ='Vanderzwalm, Patrick (IDC)', @EmployeeNumber ='688634', @InergyLogin ='', @IsActive =0, @IsSubcontractor =1, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=31, @Name ='I.D. CONCEPT', @EmployeeNumber ='688651', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=36, @Name ='CEFF', @EmployeeNumber ='688652', @InergyLogin ='', @IsActive =0, @IsSubcontractor =1, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=3, @Name ='GROEBLI', @EmployeeNumber ='688653', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=10, @Name ='2.I.A', @EmployeeNumber ='688654', @InergyLogin ='', @IsActive =0, @IsSubcontractor =1, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=26, @Name ='JACQUES SERVICES', @EmployeeNumber ='688655', @InergyLogin ='', @IsActive =0, @IsSubcontractor =1, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=12, @Name ='SIGMA', @EmployeeNumber ='688656', @InergyLogin ='', @IsActive =0, @IsSubcontractor =1, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=40, @Name ='SEEE', @EmployeeNumber ='688657', @InergyLogin ='', @IsActive =0, @IsSubcontractor =1, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=32, @Name ='SEEE', @EmployeeNumber ='688658', @InergyLogin ='', @IsActive =0, @IsSubcontractor =1, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=6, @Name ='Hennequin, Rudy', @EmployeeNumber ='688718', @InergyLogin ='FR88859', @IsActive =1, @IsSubcontractor =1, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=15, @Name ='Grueschow, Andreas (BERTRAND)', @EmployeeNumber ='688719', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=41, @Name ='Devulder, Ludovic (ACTIVETECH)', @EmployeeNumber ='688720', @InergyLogin ='', @IsActive =0, @IsSubcontractor =1, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Cochez, Nathalie (Michael PAGE)', @EmployeeNumber ='688773', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=15, @Name ='Himene, Françoise', @EmployeeNumber ='688781', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=39, @Name ='Minami, Toshihiko', @EmployeeNumber ='688815', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=3, @Name ='Chemla, Sidonie', @EmployeeNumber ='689028', @InergyLogin ='chemlas', @IsActive =1, @IsSubcontractor =1, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=22, @Name ='ATS Conseil Local', @EmployeeNumber ='ATS Conseil Local', @InergyLogin ='malgoiw', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=24, @Name ='Perche, Philippe', @EmployeeNumber ='INDEV2 Admin - PP', @InergyLogin ='FR40897', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=10, @Name ='Jang, Hyuk-Jin', @EmployeeNumber ='20011', @InergyLogin ='hjjang', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=19, @Name ='Cho, Seong-Hoon', @EmployeeNumber ='770729', @InergyLogin ='shcho', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=23, @Name ='Ju, Myung-Ha', @EmployeeNumber ='92001', @InergyLogin ='mhju', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=4, @Name ='Kim, Jeong-Jin', @EmployeeNumber ='92002', @InergyLogin ='jjkim', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=2, @Name ='Kang, Pil-Sung', @EmployeeNumber ='93001', @InergyLogin ='pskang', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=21, @Name ='Park, Jong-Moo', @EmployeeNumber ='93002', @InergyLogin ='jmpark', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=14, @Name ='Jang, Yong-Seok', @EmployeeNumber ='93003', @InergyLogin ='ysjang', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=35, @Name ='Yoo, Jung-Keun', @EmployeeNumber ='94004', @InergyLogin ='jkyoo', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=24, @Name ='Kim, Young-Man', @EmployeeNumber ='94036', @InergyLogin ='ymkim', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Kim, Tae-Wan', @EmployeeNumber ='95005', @InergyLogin ='twkim', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=43, @Name ='Yoo, Byong-Jae', @EmployeeNumber ='95019', @InergyLogin ='bjyoo', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=47, @Name ='Jeong, Sung-Hoon', @EmployeeNumber ='95042', @InergyLogin ='shchung', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=29, @Name ='Son, Jae-Hwan', @EmployeeNumber ='96004', @InergyLogin ='Jaehwan', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=16, @Name ='Kim, Hwan', @EmployeeNumber ='96014', @InergyLogin ='hkim', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=42, @Name ='Nam, Kwon-Woo', @EmployeeNumber ='97002', @InergyLogin ='kwnam', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=28, @Name ='Son, Jin-Ho', @EmployeeNumber ='97003', @InergyLogin ='jhson', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=11, @Name ='Park, Se-Hyung', @EmployeeNumber ='97012', @InergyLogin ='shpark', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=35, @Name ='Ahn, Sang-Kyu', @EmployeeNumber ='97015', @InergyLogin ='skahn', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=19, @Name ='Hwang, Chai-Suk', @EmployeeNumber ='97016', @InergyLogin ='cshwang', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=1, @Name ='Park, Jeong-Ho', @EmployeeNumber ='99006', @InergyLogin ='jhpark', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=36, @Name ='Kim, Do-Keun', @EmployeeNumber ='A0008', @InergyLogin ='DKKIM', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=41, @Name ='Lee, Kyeong-Wook', @EmployeeNumber ='A0009', @InergyLogin ='kwlee', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Lee, Jung-Hyun', @EmployeeNumber ='A0012', @InergyLogin ='junghyun', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=4, @Name ='Kim, Gyu-Beom', @EmployeeNumber ='C0003', @InergyLogin ='gbkim', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=10, @Name ='Kim, Tae-Gwon', @EmployeeNumber ='C0006', @InergyLogin ='tgkim', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=16, @Name ='Kang, Won-Young', @EmployeeNumber ='C0007', @InergyLogin ='wykang', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=44, @Name ='Kim, Woo-Tae', @EmployeeNumber ='C0013', @InergyLogin ='wtkim', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=2, @Name ='Kim, Ei-Yeon', @EmployeeNumber ='C0014', @InergyLogin ='eykim', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=40, @Name ='Chang, Nam-Soon', @EmployeeNumber ='D0002', @InergyLogin ='nschang', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=44, @Name ='Rosseel, Alexis', @EmployeeNumber ='D0009', @InergyLogin ='rosseel.a', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=31, @Name ='Kang, Sung-Choong', @EmployeeNumber ='D0010', @InergyLogin ='sckang', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Cho, Eun-Hee', @EmployeeNumber ='E0001', @InergyLogin ='EHCHO', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=47, @Name ='Kim, Young-Min', @EmployeeNumber ='E0002', @InergyLogin ='youngmin', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=43, @Name ='Han, Ji-Ho', @EmployeeNumber ='E0003', @InergyLogin ='jhhan', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=13, @Name ='Hong, Jin-Hwa', @EmployeeNumber ='E0008', @InergyLogin ='jhhong', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=23, @Name ='Kang, Seung-Heon', @EmployeeNumber ='E0010', @InergyLogin ='shkang', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=34, @Name ='Seo, Dong-Min', @EmployeeNumber ='F0001', @InergyLogin ='dmseo', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=21, @Name ='Cho, Seon-Goo', @EmployeeNumber ='F0004', @InergyLogin ='shcho', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=25, @Name ='Nam, Sang-Soo', @EmployeeNumber ='F0009', @InergyLogin ='ssnam', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=37, @Name ='Lee, Dong-Jang', @EmployeeNumber ='F0010', @InergyLogin ='djlee', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=36, @Name ='Jun, Sung-Jin', @EmployeeNumber ='F0011', @InergyLogin ='junsj', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=26, @Name ='Bretnacher, Manuel', @EmployeeNumber ='F0022', @InergyLogin ='bmanuel', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=30, @Name ='Autin, Jean-Pierre', @EmployeeNumber ='623626', @InergyLogin ='FR23626', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=26, @Name ='Dujarrier, Vincent', @EmployeeNumber ='626935', @InergyLogin ='FR26935', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=43, @Name ='Girard, Dominique', @EmployeeNumber ='628589', @InergyLogin ='FR28589', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=36, @Name ='Rolinat, Jean-Philippe', @EmployeeNumber ='630062', @InergyLogin ='FR30062', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=39, @Name ='Guyard, Loic', @EmployeeNumber ='630176', @InergyLogin ='FR30176', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Cerbelle, Lionel', @EmployeeNumber ='630452', @InergyLogin ='FR30452', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=32, @Name ='Flechard, Alain', @EmployeeNumber ='630468', @InergyLogin ='FR30468', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=5, @Name ='Fretard, Jean-Marc', @EmployeeNumber ='630475', @InergyLogin ='FR30475', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=42, @Name ='Huet, Gilles', @EmployeeNumber ='630483', @InergyLogin ='FR30483', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=8, @Name ='Iribarne, Alain', @EmployeeNumber ='630485', @InergyLogin ='FR30485', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=33, @Name ='Jambou, Patrick', @EmployeeNumber ='630486', @InergyLogin ='FR30486', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=42, @Name ='Jaouen, Denis', @EmployeeNumber ='630487', @InergyLogin ='FR30487', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=12, @Name ='Laigneau, Joseph', @EmployeeNumber ='630488', @InergyLogin ='FR30488', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=34, @Name ='Landemaine, Michel', @EmployeeNumber ='630490', @InergyLogin ='FR30490', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=34, @Name ='Berthiau, Marcel', @EmployeeNumber ='630537', @InergyLogin ='FR30537', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=50
exec catInsertAssociate @IdCountry=46, @Name ='Bichot, Jean-Paul', @EmployeeNumber ='630551', @InergyLogin ='FR30551', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=6, @Name ='Forveille, Bernard', @EmployeeNumber ='630610', @InergyLogin ='FR30610', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=45, @Name ='Dufourd, Gilles', @EmployeeNumber ='630676', @InergyLogin ='FR30676', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=42, @Name ='Renaud, Pascal', @EmployeeNumber ='630678', @InergyLogin ='FR30678', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Le-Floch, Christian', @EmployeeNumber ='630721', @InergyLogin ='FR30721', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=8, @Name ='Leclair, Albert', @EmployeeNumber ='630725', @InergyLogin ='FR30725', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=36, @Name ='Maraquin, Didier', @EmployeeNumber ='630734', @InergyLogin ='FR30734', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=12, @Name ='Mariel, Gerard', @EmployeeNumber ='630735', @InergyLogin ='FR30735', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=40, @Name ='Morin, Patrick', @EmployeeNumber ='630740', @InergyLogin ='FR30740', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=30, @Name ='Palermo, Christian', @EmployeeNumber ='630741', @InergyLogin ='FR30743', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Palermo, Christian', @EmployeeNumber ='630743', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=47, @Name ='Peigner, Jeannick', @EmployeeNumber ='630746', @InergyLogin ='FR30746', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=46, @Name ='Pottier, Pierre', @EmployeeNumber ='630752', @InergyLogin ='FR30752', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=38, @Name ='Bellanger, Patrick', @EmployeeNumber ='630787', @InergyLogin ='FR30787', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=28, @Name ='Bouvry, Pierre-Yves', @EmployeeNumber ='630792', @InergyLogin ='FR30792', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=17, @Name ='Fretard, Joelle', @EmployeeNumber ='630802', @InergyLogin ='FR30802', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=5, @Name ='Gate, Yves', @EmployeeNumber ='630804', @InergyLogin ='FR30804', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=3, @Name ='Lecommandoux, Pascal', @EmployeeNumber ='630817', @InergyLogin ='FR30817', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=28, @Name ='Clochet, Michel', @EmployeeNumber ='630854', @InergyLogin ='FR30854', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=1, @Name ='Coupard, Emile', @EmployeeNumber ='630866', @InergyLogin ='FR30866', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=13, @Name ='Defraine, Jean-Jacques', @EmployeeNumber ='630878', @InergyLogin ='FR30878', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=32, @Name ='Divay, Franck', @EmployeeNumber ='630891', @InergyLogin ='FR30891', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=35, @Name ='Dubois, Philippe', @EmployeeNumber ='630897', @InergyLogin ='FR30897', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=46, @Name ='Ganachaud, Patrick', @EmployeeNumber ='630909', @InergyLogin ='FR30909', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=41, @Name ='Guerro, Eric', @EmployeeNumber ='630937', @InergyLogin ='FR30937', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=13, @Name ='Guichoux, Laurent', @EmployeeNumber ='630942', @InergyLogin ='FR30942', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=28, @Name ='Hamelin, Philippe', @EmployeeNumber ='630950', @InergyLogin ='FR30950', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=10, @Name ='Hamonic, Dominique', @EmployeeNumber ='630954', @InergyLogin ='FR30954', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=21, @Name ='Hautbois, Jean-Marie', @EmployeeNumber ='630955', @InergyLogin ='FR30955', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=47, @Name ='Launay, Patrick', @EmployeeNumber ='630984', @InergyLogin ='FR30984', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=43, @Name ='Lebailly, Daniel', @EmployeeNumber ='630986', @InergyLogin ='FR30986', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=42, @Name ='Metrard, Camille', @EmployeeNumber ='631039', @InergyLogin ='FR31039', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=23, @Name ='Midon, Jean-Francois', @EmployeeNumber ='631041', @InergyLogin ='FR31041', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=4, @Name ='Moret-Es-Jean, Joel', @EmployeeNumber ='631051', @InergyLogin ='FR31051', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=20, @Name ='Quittet, Dominique', @EmployeeNumber ='631088', @InergyLogin ='FR31088', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=36, @Name ='Rayniere, Laurent', @EmployeeNumber ='631090', @InergyLogin ='FR31090', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=46, @Name ='Retiere, Emmanuel', @EmployeeNumber ='631094', @InergyLogin ='FR31094', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=35, @Name ='Ruault, Nicole', @EmployeeNumber ='631108', @InergyLogin ='FR31108', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=24, @Name ='Savigny, Dominique', @EmployeeNumber ='631117', @InergyLogin ='FR31117', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=39, @Name ='Thevenard, Bruno', @EmployeeNumber ='631131', @InergyLogin ='FR31131', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=47, @Name ='Ferotin, Nathalie', @EmployeeNumber ='631763', @InergyLogin ='FR31763', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=46, @Name ='Prodhomme, Sylvain', @EmployeeNumber ='632127', @InergyLogin ='FR32127', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=23, @Name ='Besnard, Pierric', @EmployeeNumber ='632264', @InergyLogin ='FR32264', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=39, @Name ='Malet, Fabrice', @EmployeeNumber ='632373', @InergyLogin ='FR32373', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=29, @Name ='Lemerle, Gerard', @EmployeeNumber ='632471', @InergyLogin ='FR32471', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=17, @Name ='Gilles, Stephane', @EmployeeNumber ='632580', @InergyLogin ='FR32580', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=26, @Name ='Manach, Pierre', @EmployeeNumber ='632640', @InergyLogin ='FR32640', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=48, @Name ='Blanchet, Daniel', @EmployeeNumber ='632708', @InergyLogin ='FR32708', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=37, @Name ='Landreau, Anne', @EmployeeNumber ='632836', @InergyLogin ='FR32836', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=9, @Name ='Dexet, Laurent', @EmployeeNumber ='632847', @InergyLogin ='FR32847', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=19, @Name ='Rouxel, Thierry', @EmployeeNumber ='632879', @InergyLogin ='FR32879', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=3, @Name ='Chiron, Patrice', @EmployeeNumber ='633048', @InergyLogin ='FR33048', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=43, @Name ='Choquet, Pascal', @EmployeeNumber ='633181', @InergyLogin ='FR33181', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=25, @Name ='Fortune, Paul', @EmployeeNumber ='633265', @InergyLogin ='FR33265', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=26, @Name ='Gelin, Stephane', @EmployeeNumber ='633266', @InergyLogin ='FR33266', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=15, @Name ='Bellain, Francois', @EmployeeNumber ='633305', @InergyLogin ='FR33305', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=20, @Name ='Runarvot, Herve', @EmployeeNumber ='633306', @InergyLogin ='FR33306', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=37, @Name ='Gandemer, Pascal', @EmployeeNumber ='633350', @InergyLogin ='FR33350', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=23, @Name ='Parizel, Bruno', @EmployeeNumber ='633675', @InergyLogin ='FR33675', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=4, @Name ='Ropert, Jerome', @EmployeeNumber ='633914', @InergyLogin ='FR33914', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=34, @Name ='Foubert, Stephane', @EmployeeNumber ='633980', @InergyLogin ='FR33980', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=6, @Name ='Favroult, Laurent', @EmployeeNumber ='634162', @InergyLogin ='FR34162', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=36, @Name ='Houdemond, Didier', @EmployeeNumber ='634191', @InergyLogin ='FR34191', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=11, @Name ='Kunstmann, Olivier', @EmployeeNumber ='634227', @InergyLogin ='FR34227', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=11, @Name ='Buffard, Laurie', @EmployeeNumber ='634237', @InergyLogin ='FR34237', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=14, @Name ='Gral, Denis', @EmployeeNumber ='634441', @InergyLogin ='FR34441', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=4, @Name ='Gille, Arnaud', @EmployeeNumber ='634471', @InergyLogin ='FR34471', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=31, @Name ='Fougeray, Jack', @EmployeeNumber ='634484', @InergyLogin ='FR34484', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=10, @Name ='Riviere, Eric', @EmployeeNumber ='634571', @InergyLogin ='FR34571', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=6, @Name ='Bernard, Frederic', @EmployeeNumber ='634665', @InergyLogin ='FR34665', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=1, @Name ='Ravenel, Loic', @EmployeeNumber ='634699', @InergyLogin ='FR34699', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=35, @Name ='Charrier, Mickael', @EmployeeNumber ='634815', @InergyLogin ='FR34815', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Griot, Mathias', @EmployeeNumber ='634893', @InergyLogin ='FR34893', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=8, @Name ='Martinet, Bruno', @EmployeeNumber ='634895', @InergyLogin ='FR34895', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=9, @Name ='Bourdin, Sarah', @EmployeeNumber ='634963', @InergyLogin ='FR34963', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=33, @Name ='Brechenmacher, Rodolphe', @EmployeeNumber ='635095', @InergyLogin ='FR35095', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=13, @Name ='Bouju, Martial', @EmployeeNumber ='635103', @InergyLogin ='FR35103', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Ganon, Sebastien', @EmployeeNumber ='635116', @InergyLogin ='FR35116', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=27, @Name ='Lombard, Hugues', @EmployeeNumber ='635167', @InergyLogin ='FR35167', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Chevallier, David', @EmployeeNumber ='635176', @InergyLogin ='FR35176', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=14, @Name ='Debray, Nicolas', @EmployeeNumber ='635177', @InergyLogin ='FR35177', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=8, @Name ='Rocher, Vincent', @EmployeeNumber ='635219', @InergyLogin ='FR35219', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=20, @Name ='Lebellego, David', @EmployeeNumber ='635242', @InergyLogin ='FR35242', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=10, @Name ='Huaulme, David', @EmployeeNumber ='635291', @InergyLogin ='FR35291', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=26, @Name ='Marchand, Ludovic', @EmployeeNumber ='635493', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=12, @Name ='Broutet, Stephane', @EmployeeNumber ='635494', @InergyLogin ='FR35494', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=18, @Name ='Cordier, Ludovic', @EmployeeNumber ='635495', @InergyLogin ='FR35495', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=3, @Name ='Compere, Nicolas', @EmployeeNumber ='635510', @InergyLogin ='FR35510', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=3, @Name ='Masson, Bertrand', @EmployeeNumber ='635511', @InergyLogin ='FR35511', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=39, @Name ='Bougeard, Laurent', @EmployeeNumber ='635668', @InergyLogin ='FR35668', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=7, @Name ='Leroy, Frank', @EmployeeNumber ='635679', @InergyLogin ='FR35679', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=44, @Name ='Covet, Jacques', @EmployeeNumber ='635681', @InergyLogin ='FR35681', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=2, @Name ='Raino, Joseph', @EmployeeNumber ='635695', @InergyLogin ='FR35695', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=7, @Name ='Penkala, Jeremy', @EmployeeNumber ='635706', @InergyLogin ='FR35706', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=21, @Name ='Lim, Julie', @EmployeeNumber ='635717', @InergyLogin ='FR35717', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=2, @Name ='Geoffroy, Kristine', @EmployeeNumber ='635816', @InergyLogin ='FR35816', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=36, @Name ='Lebas, Olivier', @EmployeeNumber ='635927', @InergyLogin ='FR35927', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=2, @Name ='Fercot, Michel', @EmployeeNumber ='640020', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=36, @Name ='Lacome, Pierre', @EmployeeNumber ='640101', @InergyLogin ='lacome.p', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=42, @Name ='Manoury, Vincent', @EmployeeNumber ='640576', @InergyLogin ='FR40576', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=15, @Name ='Nail, Franck', @EmployeeNumber ='640820', @InergyLogin ='FR40820', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=22, @Name ='Salfray, Teddy', @EmployeeNumber ='640912', @InergyLogin ='FR40912', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=17, @Name ='Frere, Antoine', @EmployeeNumber ='640914', @InergyLogin ='FR40914', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=15, @Name ='Galichet, Helene', @EmployeeNumber ='640925', @InergyLogin ='galichh', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=42, @Name ='Vaultier, Laurent', @EmployeeNumber ='640934', @InergyLogin ='FR88849', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=31, @Name ='Linard de Guertechin, Ferdinand', @EmployeeNumber ='640937', @InergyLogin ='linardf', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=37, @Name ='Perez, Laurent', @EmployeeNumber ='688456', @InergyLogin ='FR88680', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=5, @Name ='Tryoen, Arnaud ', @EmployeeNumber ='688522', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=25, @Name ='Morisseau, Nicolas', @EmployeeNumber ='688585', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=20, @Name ='Lejeune, Julien', @EmployeeNumber ='688650', @InergyLogin ='lejeunj', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=29, @Name ='Garnier, Nicolas', @EmployeeNumber ='688729', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=7, @Name ='Naudy, Antoine', @EmployeeNumber ='688748', @InergyLogin ='FR88748', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=19, @Name ='Magueresse, Anthony', @EmployeeNumber ='688777', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=26, @Name ='Vaultier, Laurent', @EmployeeNumber ='688849', @InergyLogin ='FR88849', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=22, @Name ='Clayer, Jean-Pierre', @EmployeeNumber ='688883', @InergyLogin ='clayerjp', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=43, @Name ='Derouet, Teo', @EmployeeNumber ='688902', @InergyLogin ='derouet', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=8, @Name ='Le-Courtois, Florent ', @EmployeeNumber ='688903', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=41, @Name ='Nicotera, Pierrick ', @EmployeeNumber ='688931', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=45, @Name ='Pann, Franck', @EmployeeNumber ='688950', @InergyLogin ='pannf', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=36, @Name ='Weyrech, Frederick  ', @EmployeeNumber ='688963', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=33, @Name ='Baldachino, Simon', @EmployeeNumber ='689018', @InergyLogin ='', @IsActive =0, @IsSubcontractor =1, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=41, @Name ='Marin, Kevin', @EmployeeNumber ='689019', @InergyLogin ='', @IsActive =0, @IsSubcontractor =1, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=22, @Name ='GERBOUIN Gilles', @EmployeeNumber ='INDEV2 Admin - GG', @InergyLogin ='FR31375', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Camussi Laurent', @EmployeeNumber ='309574', @InergyLogin ='USTTLJC', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=17, @Name ='Swysen, Pierre', @EmployeeNumber ='7', @InergyLogin ='SWYSENP', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=16, @Name ='Toyoshima, Shigeaki', @EmployeeNumber ='260', @InergyLogin ='toyoshs', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=47, @Name ='Kitamura, Kimie', @EmployeeNumber ='35', @InergyLogin ='KITAMUK', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=35, @Name ='Okada, Hideyo', @EmployeeNumber ='36', @InergyLogin ='OKADAH', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=16, @Name ='Van Autreeve, Marc', @EmployeeNumber ='48', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=18, @Name ='Sugie, Takeshi', @EmployeeNumber ='52', @InergyLogin ='SUGIET', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=48, @Name ='Kosako, Seiji', @EmployeeNumber ='75', @InergyLogin ='KosakoS', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=44, @Name ='Shinozaki, Hatsue', @EmployeeNumber ='84', @InergyLogin ='SHINOZH', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=19, @Name ='Bae, Jonghak', @EmployeeNumber ='86', @InergyLogin ='BAEJ', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=24, @Name ='Akiyama, Takuji', @EmployeeNumber ='93', @InergyLogin ='AKIYAMT', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=9, @Name ='Watanabe, Masako', @EmployeeNumber ='99', @InergyLogin ='WATANAM', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=14, @Name ='Matsui, Satomi', @EmployeeNumber ='100', @InergyLogin ='', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=14, @Name ='Jo, Takahiro', @EmployeeNumber ='101', @InergyLogin ='JOT', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=18, @Name ='Taguchi, Haruhisa', @EmployeeNumber ='113', @InergyLogin ='TAGUCHH', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=20, @Name ='Kuramoto, Makiko', @EmployeeNumber ='135', @InergyLogin ='kuramom', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=19, @Name ='Sugahara, Tomoko', @EmployeeNumber ='146', @InergyLogin ='Sugahat', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=19, @Name ='Shinohara, Tomoaki', @EmployeeNumber ='155', @InergyLogin ='SHINOHT', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=41, @Name ='Minami, Toshihiko', @EmployeeNumber ='156', @InergyLogin ='MINAMIT', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=30, @Name ='Tsumuraya, Mieko', @EmployeeNumber ='163', @InergyLogin ='TSUMURM', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=31, @Name ='Hokamura, Masashi', @EmployeeNumber ='173', @InergyLogin ='HOKAMUM', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=21, @Name ='Oda, Yasuhisa', @EmployeeNumber ='178', @InergyLogin ='ODAY', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=35, @Name ='Ankai, Motoi', @EmployeeNumber ='190', @InergyLogin ='anzaim', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=22, @Name ='Watabe, Nobuyuki', @EmployeeNumber ='192', @InergyLogin ='wataben', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=5, @Name ='Tistchenko, Michel', @EmployeeNumber ='202', @InergyLogin ='USTTMAT', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=17, @Name ='Shimotake, Koichiro', @EmployeeNumber ='205', @InergyLogin ='shimotk', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=5, @Name ='Saito, Junichi', @EmployeeNumber ='208', @InergyLogin ='saitoj', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=43, @Name ='Yamada, Shigeo', @EmployeeNumber ='221', @InergyLogin ='YAMADAS', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=16, @Name ='Ishikawa, Takaaki', @EmployeeNumber ='223', @InergyLogin ='ISHIKAT2', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=25, @Name ='Koul, Amit', @EmployeeNumber ='225', @InergyLogin ='koula', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=46, @Name ='Aubin, Gabrajoanne', @EmployeeNumber ='227', @InergyLogin ='FR35536', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=39, @Name ='Yokoi, Yutaka', @EmployeeNumber ='242', @InergyLogin ='yokoiy', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=16, @Name ='Yoshida, Tatsuji', @EmployeeNumber ='246', @InergyLogin ='yoshidt', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=28, @Name ='Okajima, Keisuke', @EmployeeNumber ='248', @InergyLogin ='okajimak', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=11, @Name ='Furuta, Katsumi', @EmployeeNumber ='250', @InergyLogin ='', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=27, @Name ='Reinders, Wim', @EmployeeNumber ='251', @InergyLogin ='reindew', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=17, @Name ='Wakui, Fumiyuki', @EmployeeNumber ='30', @InergyLogin ='WAKUIF', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=0
exec catInsertAssociate @IdCountry=25, @Name ='Kurata, Youji', @EmployeeNumber ='9023', @InergyLogin ='kuratay', @IsActive =0, @IsSubcontractor =1, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=37, @Name ='Ishiguro, Masaya', @EmployeeNumber ='9024', @InergyLogin ='ISHIGUM', @IsActive =0, @IsSubcontractor =1, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=13, @Name ='Maruyama, Mikio', @EmployeeNumber ='9025', @InergyLogin ='', @IsActive =1, @IsSubcontractor =1, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=46, @Name ='Levenez, Yannick', @EmployeeNumber ='INDEV2 Admin - YL', @InergyLogin ='FR88847', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=32, @Name ='Furuta, Katsumi', @EmployeeNumber ='JPN01', @InergyLogin ='FURUTAK', @IsActive =0, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=3, @Name ='Soto, Begoña', @EmployeeNumber ='90700337', @InergyLogin ='sotob', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=1, @Name ='Otero, Jacobo', @EmployeeNumber ='90700342', @InergyLogin ='oteroj', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=46, @Name ='Sabin, Jaime', @EmployeeNumber ='90700515', @InergyLogin ='sabinj', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=27, @Name ='Rodriguez, Dimas', @EmployeeNumber ='90700516', @InergyLogin ='rodrigd', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=6, @Name ='Lorenzo, Enrique', @EmployeeNumber ='90700517', @InergyLogin ='lorenze', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=5, @Name ='Iglesias, Javier', @EmployeeNumber ='90700523', @InergyLogin ='iglesij', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=9, @Name ='Alonso, Pablo', @EmployeeNumber ='90700537', @InergyLogin ='alonsop', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=39, @Name ='Garcia, Yolanda', @EmployeeNumber ='90700538', @InergyLogin ='garciay', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=24, @Name ='Barros, David', @EmployeeNumber ='90700540', @InergyLogin ='barrosd', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
exec catInsertAssociate @IdCountry=34, @Name ='Stiers, Emmanuel', @EmployeeNumber ='90740478', @InergyLogin ='stiers.e', @IsActive =1, @IsSubcontractor =0, @PercentageFullTime=100
COMMIT TRAN
-------------------END OF ASSOCIATES catalogue------------------------------------


------------------- PROGRAM OWNER catalogue------------------------------------------
exec catInsertOwner @Code = 'Owner    1', @Name = 'Program Owner                1', @IdOwnerType = 1 
exec catInsertOwner @Code = 'Owner    2', @Name = 'Program Owner                2', @IdOwnerType = 2
exec catInsertOwner @Code = 'Owner    3', @Name = 'Program Owner                3', @IdOwnerType = 3
exec catInsertOwner @Code = 'Owner    4', @Name = 'Program Owner                4', @IdOwnerType = 4
exec catInsertOwner @Code = 'Owner    5', @Name = 'Program Owner                5', @IdOwnerType = 1
exec catInsertOwner @Code = 'Owner    6', @Name = 'Program Owner                6', @IdOwnerType = 2
exec catInsertOwner @Code = 'Owner    7', @Name = 'Program Owner                7', @IdOwnerType = 3
exec catInsertOwner @Code = 'Owner    8', @Name = 'Program Owner                8', @IdOwnerType = 4
-------------------END OF PROGRAM OWNER catalogue------------------------------------


-------------------PROGRAM catalogue------------------------------------------
exec catInsertProgram @Code ='A00001',@Name='USA', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='A00002',@Name='Mexico', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='A00003',@Name='France', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='A00004',@Name='U.K.', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='A00005',@Name='Romania', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='A00006',@Name='Spain Vigo', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='A00008',@Name='Brazil', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='A00009',@Name='Argentina', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='A00010',@Name='Germany', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='A00011',@Name='Belgium', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='A00012',@Name='Slovakia', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='A00013',@Name='Poland', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='A00014',@Name='South Africa', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='A00015',@Name='Japan', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='A00016',@Name='Korea', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='A00017',@Name='Thailand', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='A00018',@Name='Research', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='A00019',@Name='Other', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='AA0000',@Name='AAA_Test', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='AAA000',@Name='AAAAA_MYTEST', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C00001',@Name='VIG Metal', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C00002',@Name='VIG Air Duct', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C00017',@Name='REN J77', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C00101',@Name='GMW W169', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C00106',@Name='PCA N68/M49', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C00977',@Name='NIS ZW', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C00978',@Name='DAE M200', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C00979',@Name='NIS Bluebird', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C00980',@Name='FOR C170 - Russia', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C00981',@Name='FOR B 325', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C00982',@Name='FIA CMPV', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C00983',@Name='FIA Premium', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C00984',@Name='HMC LD Dom', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C00985',@Name='RSM SM3', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C00986',@Name='DCN CS', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C00987',@Name='BMW E85', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C00988',@Name='DCN TJ 03', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C00989',@Name='NIS TT', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C00990',@Name='DCN ZB', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C00991',@Name='DCN RS 03/04', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C00992',@Name='DCN JR', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C00993',@Name='DCN AN', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C00995',@Name='GMN GMT 830', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C00996',@Name='PVW PQ 24', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C00998',@Name='NIS JATQ', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C00999',@Name='NIS MM/YY', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C01006',@Name='PCA A31 (A8)', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C01011',@Name='REN P210', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C01012',@Name='REN P240', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C01013',@Name='GMW NCV2', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C01021',@Name='PCA D2 Nao', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C01026',@Name='REN B85', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C01029',@Name='PCA A42', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C01030',@Name='PCA A08', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C01041',@Name='RSA X70 - Phase 2', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C01045',@Name='PCA B0', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C01046',@Name='REN X83', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C01052',@Name='PCA A6', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C01055',@Name='Proton SCM/GMX', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C01056',@Name='REN X76', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C01064',@Name='PCA B5', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C01982',@Name='HMC MR', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C01983',@Name='VW_ PQ 46', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C01984',@Name='DCN KJ 04', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C01985',@Name='HMC HR', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C01986',@Name='DAE J200 Dom', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C01987',@Name='HMC SA', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C01988',@Name='MER WG', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C01989',@Name='DCW PT Cruiser PG 2003', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C01990',@Name='NIS ZR', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C01991',@Name='VW_ B5 additive', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C01992',@Name='TOY IMV', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C01993',@Name='DCN HB', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C01994',@Name='PVW PQ 35', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C01995',@Name='MER NCV2 - Nafta (Euro prod)', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C01996',@Name='GMN GMT 345', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C01997',@Name='DAE Y200', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C01998',@Name='BMW PL2', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C01999',@Name='PVW C2/C4', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C02009',@Name='PCA A31 (A8) Mercosur', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C02020',@Name='PCA A7', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C02032',@Name='PCA Z8/Z9', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C02100',@Name='HMC NF', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C02101',@Name='DAE D100', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C02102',@Name='DCN C-segment', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C02103',@Name='GMN GMT 201', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C02104',@Name='GMN GMX 215-GMX 245', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C02105',@Name='GMW A3300', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C02106',@Name='GMW A3370', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C02107',@Name='HMC MC/TC', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C02108',@Name='MER NCV3', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C02109',@Name='RSM EX', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C02110',@Name='SUZ YN2', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C02968',@Name='GMW X4400', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C02969',@Name='GMW Celta II', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C02970',@Name='FOR CD3XX', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C02971',@Name='NIS Platform C (US)', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C02972',@Name='NIS Platform C (UK)', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C02973',@Name='GMN GMX 222 / 272', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C02974',@Name='FIA 199', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C02975',@Name='FOR D310', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C02976',@Name='MIT MMC truck (CR)', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C02977',@Name='MIT C-segment', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C02978',@Name='SUZ Escudo', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C02979',@Name='MIT Z-car Japan 2WD', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C02980',@Name='DAE V200 Lev2', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C02981',@Name='DAE U200 Lev2', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C02982',@Name='NIS X61B QW Europe', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C02983',@Name='NIS X61B QW US', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C02984',@Name='FOR P131', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C02985',@Name='GMN GMT 360/370', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C02986',@Name='DCN ND platform', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C02987',@Name='FOR C1', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C02988',@Name='DCN PT Cruiser - Nafta', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C02989',@Name='DCN RS 05', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C02990',@Name='DCN LX 04/05', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C02991',@Name='PCA T5 China', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C02992',@Name='HMC CT Pregio F/L', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C02993',@Name='SUZ MR Wagon (Moco)', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C02994',@Name='GMN GMX 380', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C02995',@Name='FOR IKON', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C02996',@Name='DCW RG - Voyager', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C02997',@Name='NIS XX/UL', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C02998',@Name='NIS B30 (J32B-C Platform)', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C02999',@Name='SYM A100', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C03001',@Name='PVW PL71', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C03005',@Name='RDX 60', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C03007',@Name='PCA X4', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C03010',@Name='REN W44', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C03011',@Name='REN W61', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C03013',@Name='PCA G9', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C03020',@Name='GMW EPSILON', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C03021',@Name='SUZ NBC', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C03022',@Name='PVW 997', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C03025',@Name='BMW E9x Motorsport', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C03102',@Name='PCA B58', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C03103',@Name='BMW PL4', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C03104',@Name='BMW Mini', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C03105',@Name='LDV BD100', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C03106',@Name='DAE V231', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C03107',@Name='FOR D219/D258', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C03108',@Name='FOR V34', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C03109',@Name='HMC CM Nao', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C03110',@Name='MAZ J56', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C03111',@Name='DCN RT 07', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C03981',@Name='MER BR 204/207', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C03982',@Name='HON XF', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C03983',@Name='MAZ C-4WD', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C03984',@Name='VW_ PQ 35 Europe', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C03985',@Name='NIS W39 (D Platform UK)', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C03986',@Name='GMN Lambda', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C03987',@Name='FIA Ducato', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C03988',@Name='DC JS', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C03989',@Name='GMN GMX 020', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C03990',@Name='MER W456', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C03991',@Name='NIS J32J', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C03992',@Name='MIT SQ', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C03993',@Name='TOY Yaris', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C03994',@Name='GMN Delta - GMX 357', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C03995',@Name='HMC TG US', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C03996',@Name='VW_ PQ 35 US', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C03997',@Name='SYM D-100', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C03998',@Name='DCW RS 05 - Europe', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C03999',@Name='VOLVO EUCD', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C04001',@Name='MAZ B2E', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C04002',@Name='REN X91', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C04004',@Name='PCA T1 China & Iran', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C04005',@Name='REN X70 Mercosur', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C04009',@Name='REN W16', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C04101',@Name='MCC BR451', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C04102',@Name='PVW C1', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C04104',@Name='MAZ J61X - CD 2WD', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C04105',@Name='TOY 130L', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C04107',@Name='HON CRV (EU)', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C04108',@Name='NIS P32K', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C04111',@Name='DCN KK 07 - KA', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C04112',@Name='DCN JK 07', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C04113',@Name='DCN DR / DH', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C04114',@Name='GMN GMT 836 Cab Chassis', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C04115',@Name='PVW PL48', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C04116',@Name='NIS X61B', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C04117',@Name='HMC ED', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C04118',@Name='PCA X7', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C04119',@Name='PCA T7', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C04120',@Name='PVW PQ Mix', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C04121',@Name='DCN JS - PZEV', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C04122',@Name='NIS P32M', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C04123',@Name='NIS X11C Coex', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C04124',@Name='HMC XD/GK', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C04126',@Name='SUZ YP0 Europe', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C04128',@Name='DCN DC/DM   07/08', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C04130',@Name='SUZ NATC', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C04131',@Name='GMX 322', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C04133',@Name='DCN JC 49', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C04134',@Name='NIS L42A', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C04135',@Name='GMN GMT 930 (830 Repl.)', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C04136',@Name='GMN GMT 920 (820 Repl.)', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C04137',@Name='GMN GMX 365 & 222 PZEV', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C04138',@Name='DAE C100', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C04139',@Name='GMN GMT 355', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C04140',@Name='HMC MG', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C04141',@Name='GMN GMT 800', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C04142',@Name='NIS W42E', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C04143',@Name='HMC CM Dom', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C04144',@Name='NIS X11C MEX', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C04147',@Name='GMW S0421', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C04148',@Name='GMW X4000', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C04149',@Name='GMN GMX 280 - Zeta Platform', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C04150',@Name='GMN GMT 900 (26 Gallons)', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C04151',@Name='BMW K72', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C04152',@Name='NIS P32L', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C04153',@Name='NIS X11C Mono', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C04154',@Name='FOR C1 SAF', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C04155',@Name='HMC TQ', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C04158',@Name='HON CRV', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C04160',@Name='NIS W42D', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C04161',@Name='MAS M139', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C04162',@Name='DCW Actros - Urea - HDV', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C04163',@Name='SYM G100', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C04986',@Name='POR C2 / C4', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C04987',@Name='VW_ PQ25 SAF', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C04988',@Name='GMN W car & 222', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C04989',@Name='GMN GMX 282 & VE', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C04991',@Name='SUZ YS7 - (AA)', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C04992',@Name='SUZ YS6 - (AA)', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C04993',@Name='HON MD2', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C04994',@Name='FOR U222', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C04995',@Name='VW_ PQ25', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C04996',@Name='TOY 800x', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C04997',@Name='HMC UN', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C04998',@Name='GMW A3300 - Brazil', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C04999',@Name='NIS J32B', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C05100',@Name='NIS W12A', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C05101',@Name='PVW AU416', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C05102',@Name='GMW X3500', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C05103',@Name='SUZ YP0', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C05104',@Name='DCN D-Segment (New JR) - JS', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C05105',@Name='GMN GMT 319', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C05106',@Name='SUZ YN3 Japan', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C05107',@Name='MER BR212', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C05108',@Name='REN W62', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C05110',@Name='GMN GMT 001', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C05111',@Name='GMN GMT 610', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C05112',@Name='DCW LE', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C05113',@Name='MER W204', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C05114',@Name='BMW K25 Motorbike', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C05115',@Name='DCW NCV3 Argentina', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C05116',@Name='RSA W95', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C05117',@Name='BMW PL6', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C05118',@Name='GMW New Epsilon (X 3500) - Filler Pipes', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C05119',@Name='SUZ YD2', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C05121',@Name='MIT I3-I4', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C05122',@Name='TOY IMV - SWB 80L', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C05123',@Name='NIS W02A', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C05124',@Name='DCW LCV', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C05125',@Name='NIS L42F', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C05126',@Name='SUZ ATV Tank homologation', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C05127',@Name='Suzuki ATV Smac', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C05128',@Name='SUZ Tank A', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C05129',@Name='HON Accord', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C05130',@Name='VW_ VW249', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C05131',@Name='FOR C1 Russia', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C05132',@Name='GMN Epsilon 1 PZEV', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C05135',@Name='GMN Lambda (replacement)', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C05136',@Name='POR Panamera 970', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C05137',@Name='DCN CT09', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C05138',@Name='GMN GMT 511', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C05139',@Name='GMN GM Theta Epsilon', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C05140',@Name='PCA A58', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C05141',@Name='BMW X3', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C05142',@Name='BMW E89', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C05143',@Name='MER BR 212 Urea', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C05144',@Name='GMW T3600 (Delta)', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C05145',@Name='TOY 681X', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C05146',@Name='PCA A51', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C05147',@Name='PCA T3', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C05148',@Name='RSA X93', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C05149',@Name='FOR Galaxy', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C05150',@Name='NIS P32 E/L', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C05151',@Name='NIS X11M', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C05152',@Name='RSA R77', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C05153',@Name='BMW E88 Pzev', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C05154',@Name='PCA T8', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C05155',@Name='PCA W31', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C05156',@Name='VW_ PQ46 China', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C05157',@Name='VW_ AU5XX', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C05158',@Name='VW_ D4', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C05159',@Name='VW_ D4 SUV', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C05160',@Name='NIS New Cube', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C05161',@Name='Suzuki Tank B', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C05162',@Name='DAE V300', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C05163',@Name='HMC PO', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C05164',@Name='HMC TG Korea', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C05166',@Name='PCA W2Z', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C05167',@Name='HMC AM', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C05168',@Name='SUZ ATV LT6', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C05169',@Name='VW_ SCR Urea systems', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C06001',@Name='GMN GMX 222', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C06002',@Name='GMN GMX 365', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C06003',@Name='GMW NCV3 & NCV2 China', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C06005',@Name='ISU I190 repl', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C06006',@Name='VW_ 817 RPU', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C06007',@Name='RSM LP1', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C06008',@Name='NIS J42G UL Lev2', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C06009',@Name='NIS K11 repl', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C06010',@Name='GMW S4200 Argentina', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C06011',@Name='GMW S10 Mercosur', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C06012',@Name='TOY 445L', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C06013',@Name='SYM Y300', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C06014',@Name='Haitec NV1', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C06015',@Name='DC HB HEV/PZEV', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C06016',@Name='Daihatsu Car', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C75001',@Name='PCA S90', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C80001',@Name='PCA M24', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C81001',@Name='PCA VDU', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C84001',@Name='PCA ZA', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C89113',@Name='PCA S8', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C89168',@Name='PCA X1', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C90001',@Name='PCA N2', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C90168',@Name='MER T1N Filler Pipe', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C91040',@Name='PCA N3/N5', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C91052',@Name='PCA V - U64', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C92063',@Name='REN X65', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C92079',@Name='REN F40', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C92999',@Name='RSA X57', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C93271',@Name='REN X70', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C94073',@Name='PCA T1', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C94132',@Name='RSA X74 (M2S Platform)', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C94997',@Name='DCW T0', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C94998',@Name='PVW S03', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C94999',@Name='PCA SAMAND', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C95999',@Name='HMC A1', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C96067',@Name='PCA X2', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C96158',@Name='REN X64', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C96219',@Name='PCA T6 (T5)', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C96999',@Name='GMW T3000', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C97108',@Name='REN X73 (M2S Platform)', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C97998',@Name='HMC LC', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C97999',@Name='NIS U13', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C98018',@Name='REN X81 (M2S Platform)', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='C98070',@Name='REN X84', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C98101',@Name='PCA V', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C98992',@Name='BMW E53', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C98994',@Name='NIS H21', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C98995',@Name='GMN GMX 320', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C98996',@Name='GMN GMT 200 AWD', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='C98998',@Name='MCC 22L', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C98999',@Name='ISU i190', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='C99057',@Name='PCA N6/N7', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C99066',@Name='DAC L90', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C99082',@Name='PCA D2', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C99083',@Name='PCA X6', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='C99133',@Name='PCA T1/T12/T16', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='C99984',@Name='HMC TB', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C99985',@Name='BMW E46', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C99986',@Name='GMW T0600', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C99987',@Name='MCC 35L', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C99989',@Name='GMW S4300 Brazil', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C99990',@Name='GMW Epsilon (3200/3210)', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C99991',@Name='RSM SM5', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='C99994',@Name='GMW S0411 & S4300 Europe', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='C99998',@Name='DAC W41', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='C99999',@Name='PVW Colorado', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='I00001',@Name='Patents', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='I00004',@Name='Corporate Quality Support', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='I00006',@Name='TECHWATCH', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='I00008',@Name='Productivity', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='I03001',@Name='Knowledge Management', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='I04001',@Name='Corp. R&D support', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='I04002',@Name='IMIS', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='I04003',@Name='JPN - JPN 5 layer EVOH', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='I04004',@Name='Corp. Industrial support', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='I05001',@Name='Corp Marketing support', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='I05002',@Name='CC Korean General', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='I05003',@Name='RSM General', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='I05004',@Name='SYM General ', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='I05005',@Name='DAE General ', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='I05006',@Name='CPO Support', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='I05007',@Name='VAVE Japan', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='I05009',@Name='Warranty issues', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='I05010',@Name='Coaching B2e team', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='I05011',@Name='CC Japan General support', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='I05012',@Name='Suzuki general', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='I05013',@Name='BMW General', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='I05014',@Name='TOY - Toyota general', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='I05015',@Name='Corp Finance support', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='I05016',@Name='HON General', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='I05017',@Name='JAPN Business development', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='I05018',@Name='5 layer PA Nanocomposite', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='I05019',@Name='PVW General', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='I05020',@Name='GMW General', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='I05021',@Name='PCA General support', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='I05022',@Name='RNDS General support', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='I05023',@Name='Corp HR support', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='I05024',@Name='FRUK Clapets Support', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='I05025',@Name='FRUK - Regional purchases', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='I05026',@Name='FRUK - Region Support', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='I06001',@Name='HMC SCR', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='I06002',@Name='Global productivity', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='I06003',@Name='Corp Purchases support', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='I06004',@Name='ICV Support', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='I06005',@Name='Easybench', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='N00001',@Name='Vacation & other absence', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='N00002',@Name='General administration', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='N00003',@Name='Department improvment', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='N00004',@Name='Quality system', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='N00005',@Name='Standardization', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='N00006',@Name='Innovation', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='N00007',@Name='Marketing & Com.', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='N00008',@Name='Benchmark', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='N02001',@Name='Material studies', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='N03001',@Name='Inergy University', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='R02001',@Name='PZEV', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='R03002',@Name='INSAS', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='R03003',@Name='Fluid Mechanics', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='R03004',@Name='Filler Pipes', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='R03005',@Name='Noise', @IdOwner = 4, @IsActive = 1
exec catInsertProgram @Code ='R04001',@Name='Surface Treatments', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='R04002',@Name='TSBM', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='R04003',@Name='Materials', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='R04004',@Name='Canister', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='R04005',@Name='INVALVE', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='R04006',@Name='Solid Mechanics', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='R04007',@Name='Blow Molding simulation', @IdOwner = 7, @IsActive = 1
exec catInsertProgram @Code ='R04008',@Name='IFS', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='R04009',@Name='BM process control', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='R05002',@Name='SCR-UREA', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='R05003',@Name='New Testing', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='R05004',@Name='New Tank Architecture', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='R05005',@Name='Product Testing Center', @IdOwner = 1, @IsActive = 1
exec catInsertProgram @Code ='R06004',@Name='Newfill', @IdOwner = 5, @IsActive = 1
exec catInsertProgram @Code ='R06008',@Name='INPump', @IdOwner = 6, @IsActive = 1
exec catInsertProgram @Code ='Research',@Name='research projects', @IdOwner = 3, @IsActive = 1
exec catInsertProgram @Code ='VW_ D1',@Name='VW_ D1', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='VW_ LT3',@Name='VW_ LT3', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='VW_ Microb',@Name='VW_ Microbus', @IdOwner = 2, @IsActive = 1
exec catInsertProgram @Code ='VW_ PL 47',@Name='VW_ PL 47', @IdOwner = 8, @IsActive = 1
exec catInsertProgram @Code ='VW_ Tango',@Name='VW_ Tango', @IdOwner = 8, @IsActive = 1
-------------------END OF PROGRAMS catalogue------------------------------------


------------------- PROJECTS catalogue------------------------------------------
exec catInsertProject @Code ='0',@Name='123456789', @IdProgram = 183, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='027LIB',@Name='Liberty Research Project', @IdProgram = 51, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='043320D',@Name='2004 GMX 320 Prototype V Series', @IdProgram = 142, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='046403P',@Name='HB04 Production', @IdProgram = 172, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='055345D',@Name='GM TK 05 GMT345', @IdProgram = 271, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='055345T',@Name='GMT 345 - 2005', @IdProgram = 61, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='065501D',@Name='2006 Hyundai NF Prototype', @IdProgram = 40, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='065501DH',@Name='Hyundai NF', @IdProgram = 88, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='068355D',@Name='2006 GM 355 Prototype Tank', @IdProgram = 120, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='068455D',@Name='2006 GM 355 Prototype Fillpipe', @IdProgram = 176, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='100',@Name='TUBULURE MM', @IdProgram = 431, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10001',@Name='BMW E46', @IdProgram = 22, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10002',@Name='BMW E46.5', @IdProgram = 247, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10004',@Name='E53', @IdProgram = 235, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10006',@Name='PORSCHE 986-996 MODIF SERIE', @IdProgram = 266, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10009',@Name='OPEL 4300 MY04', @IdProgram = 16, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10011',@Name='PORSCHE 996 GT', @IdProgram = 324, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10024',@Name='VW PQ24', @IdProgram = 403, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1003',@Name='TUBULURE T12', @IdProgram = 426, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1004',@Name=' RàC NISSAN JAPON JA/TQ INERGY TOKYO', @IdProgram = 152, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1005',@Name='RàC NISSAN JAPON XX/UL', @IdProgram = 165, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10055',@Name='BMW E46 float valve-Japan', @IdProgram = 431, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1006',@Name='CàC A86', @IdProgram = 200, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1007',@Name='RàC 3200 EPSILON', @IdProgram = 198, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1008',@Name=' TRANSF. IRAN T1/D70/X2', @IdProgram = 213, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1009',@Name=' POS TELFORD PRESTAT°SUPPORT HORS PROJET', @IdProgram = 345, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1010',@Name=' CIRCUIT A CARBURANT SM3 ALMERA', @IdProgram = 436, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1011',@Name=' CIRCUIT A CARBURANT P210', @IdProgram = 196, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1012',@Name=' CIRCUIT A CARBURANT P240', @IdProgram = 117, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10124',@Name='BMW - PPQ5', @IdProgram = 374, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1013',@Name='CIRCUIT A CARBURANT NCV2 INERGY ESPAGNE', @IdProgram = 54, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1014',@Name='RESERVOIR A CARBURANT NCV2 INERGY ARGENT', @IdProgram = 99, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10141',@Name='PORSCHE COLORADO', @IdProgram = 319, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1015',@Name='HAUT DE TUBULURE STANDARD', @IdProgram = 18, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1016',@Name='INERGY TELFORD PRESTATION SUPPORT', @IdProgram = 366, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1017',@Name='CANISTER OPTIMISATION & INTEGRATION', @IdProgram = 60, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1018',@Name='ENVELOPPE LEVII 1800 1700 51', @IdProgram = 198, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1019',@Name='OPEL GM VA/VE', @IdProgram = 247, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1020',@Name='RECHERCHE MATERIALS APPLICATIONS', @IdProgram = 270, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1021',@Name='D2 US STANDARD', @IdProgram = 47, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1022',@Name='D2 US DEMONSTRATEUR X4', @IdProgram = 97, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10221',@Name='POR 986/996', @IdProgram = 168, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1023',@Name='SUIVI FOURNISSEUR COMPOSANTS ACTIFS', @IdProgram = 146, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1024',@Name='OPEL COMBO COMPIEGNE', @IdProgram = 175, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1025',@Name='PCA Reservoir Generique Injecté', @IdProgram = 201, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1026',@Name='RESERVOIR A CARBURANT ET TUBULURE B85', @IdProgram = 425, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1028',@Name='E53 LEVII COMPIEGNE', @IdProgram = 14, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1029',@Name='PCA A42', @IdProgram = 337, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1030',@Name='PCA A08 COM', @IdProgram = 6, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1031',@Name='PLASTIC PZEV FUEL SYSTEM 073654000021', @IdProgram = 283, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1032',@Name='CàC NCV3', @IdProgram = 177, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10321',@Name='BMW E8X - E9X', @IdProgram = 421, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10323',@Name='BMW PL2 SAF lines ', @IdProgram = 298, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1033',@Name='INERGY A. S. CENTRE PRESTATION SUPPORT', @IdProgram = 338, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1034',@Name='RESERVOIR A CARBURANT XTERRA X61/QW', @IdProgram = 143, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10341',@Name='PORSCHE 987-997', @IdProgram = 129, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1035',@Name='PRESTATION COMPIEGNE J.F. SMORZYK', @IdProgram = 353, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1036',@Name='PLATEFORME C ALMERA/TINO 1800200010', @IdProgram = 278, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10362',@Name='E85 NG6', @IdProgram = 123, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10363',@Name='E85 NG Motorposrt', @IdProgram = 29, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10366',@Name='BMW PL88', @IdProgram = 134, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1037',@Name='PRESTATIONS SOLVAY CARBONATE France', @IdProgram = 401, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1038',@Name='GM RECYCLABILITE', @IdProgram = 137, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1039',@Name='PREST. SUPPORT HORS PROJET SLOVAQUIE', @IdProgram = 412, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='104',@Name='RESERVOIR A CARBURANT FAP N7', @IdProgram = 54, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1040',@Name='RESERVOIR HILUX TOYOTA', @IdProgram = 387, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1041',@Name='RESERVOIR A CARBURANT X70 PHASE', @IdProgram = 69, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1045',@Name='CIRCUIT A CARBURANT B0', @IdProgram = 33, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1046',@Name='RàC X83 ESPAGNE', @IdProgram = 14, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1047',@Name='PREST. SUPPORT HORS PROJET BELGIQUE', @IdProgram = 152, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1048',@Name='TUBULURE E46/5 1800150465', @IdProgram = 334, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1049',@Name='ASSISTANCE RAMOZ MEXIQUE 1811260140', @IdProgram = 382, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1050',@Name='SM5 180022000', @IdProgram = 302, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10500',@Name='EPSILON 3200', @IdProgram = 186, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10501',@Name='EPSILON 0620', @IdProgram = 207, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10502',@Name='GMW Epsilon - General support', @IdProgram = 64, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10503',@Name='GMW Epsilon - Cost saving', @IdProgram = 391, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10505',@Name='Saab Diesel filter', @IdProgram = 59, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10506',@Name='GMW X3500 generic', @IdProgram = 348, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1051',@Name='PdR EPSILON 3210 1800 240 263', @IdProgram = 193, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10511',@Name='Opel X4400', @IdProgram = 147, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10512',@Name='B5 ADDITIF', @IdProgram = 132, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10513',@Name='D1 Additive', @IdProgram = 186, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10514',@Name='COLORADO additive', @IdProgram = 95, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10515',@Name='PQ 35', @IdProgram = 38, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10516',@Name='PORSCHE COLORADO claim', @IdProgram = 216, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10517',@Name='MERCEDES NCV2', @IdProgram = 182, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10518',@Name='EPSILON 3210', @IdProgram = 142, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10519',@Name='BMW E8X - E9X PZEV', @IdProgram = 46, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1052',@Name='PCA A6', @IdProgram = 207, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10520',@Name='BMW E8X - E9X Motorsport', @IdProgram = 365, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10521',@Name='BMW mini', @IdProgram = 372, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10522',@Name='PL4', @IdProgram = 178, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10523',@Name='VW_ PQ35 Additive', @IdProgram = 9, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10524',@Name='BMW E85 Motorausgeher(153085)', @IdProgram = 359, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10525',@Name='PORSCHE 997 GT', @IdProgram = 426, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10526',@Name='BMW task force PL2 pump', @IdProgram = 232, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10527',@Name='VW PL71', @IdProgram = 376, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10528',@Name='Nissan project', @IdProgram = 147, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10529',@Name='VW PL48', @IdProgram = 256, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1053',@Name='QW/X61B 1800 230 01', @IdProgram = 331, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10535',@Name='BMW PL2 Britz', @IdProgram = 83, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10536',@Name='MAZ B2e Generic', @IdProgram = 259, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10537',@Name='BMW K72', @IdProgram = 371, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10538',@Name='BMW E92/93 Common FP', @IdProgram = 394, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10539',@Name='BMW E9x Park Heating', @IdProgram = 213, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1054',@Name='ET.IMPLANT°CLAPET-CANISTER 1800 1700 58', @IdProgram = 197, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='10540',@Name='BMW PL2 Nox', @IdProgram = 276, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10545',@Name='BMW PL2 - Water in the tank issue', @IdProgram = 70, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10546',@Name='BMW PL2 - Pressure regulator acoustic', @IdProgram = 216, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10548',@Name='BMW PL2 Generic', @IdProgram = 418, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1055',@Name='SCM GXM PROTON', @IdProgram = 11, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1056',@Name='X76 4*4 (GM) 1800 041 27', @IdProgram = 357, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10567',@Name='BMW Cost Saving', @IdProgram = 418, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10568',@Name='VW_ SCR Urea PQ35', @IdProgram = 364, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1057',@Name='PRESTATIONS AFRIQUE DU SUD', @IdProgram = 384, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1058',@Name='BOL DE REMPLISSAGE GNV X65', @IdProgram = 25, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1059',@Name='RESERVOIR A CARBURANT TOLE', @IdProgram = 109, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='106',@Name='RES ET RUB M49 N68', @IdProgram = 28, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1060',@Name='RESERVOIR A CARBURANT PORSCHE C2', @IdProgram = 420, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10600',@Name='BMW PL6', @IdProgram = 346, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1061',@Name='RESERVOIR A CARBURANT 35L VERSION DIESEL', @IdProgram = 109, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1062',@Name='PLATEFORME C', @IdProgram = 374, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1063',@Name='PCA A8 Spain', @IdProgram = 397, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1064',@Name='CIRCUIT A CARBURANT B5', @IdProgram = 110, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='107',@Name='RESERVOIR A CARBURANT NISSAN MM MICRA', @IdProgram = 35, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='108',@Name='RESERVOIR Colorado', @IdProgram = 379, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='109',@Name='TUBULURE EPSILON PO COMPIEGNE', @IdProgram = 88, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='10998',@Name='Meetings', @IdProgram = 120, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='10999',@Name='Vacation', @IdProgram = 188, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='110',@Name='RESERVOIR PQ24 VW PO COMPIEGNE', @IdProgram = 19, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='111',@Name='RESERVOIR INJECTE FAP A86', @IdProgram = 137, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='111101',@Name='GM TK 05 GMT 201 LWB LevII', @IdProgram = 298, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='111102',@Name='GM TK 05 GMT 201 SWB LevII', @IdProgram = 222, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='111112',@Name='DC TK 05 NCV2', @IdProgram = 149, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='111116',@Name='DC TK 05 HB', @IdProgram = 80, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='111121',@Name='GM TK 06 GMT355 LEVII', @IdProgram = 18, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='111122',@Name='GM 06 FP GMT355 LEVII', @IdProgram = 125, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='111125',@Name='GM TK 05 GMT201 LEVII', @IdProgram = 115, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='111128',@Name='DC TK 04 AN', @IdProgram = 251, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='113',@Name='MODULE POMPE JAUGE PORSCHE C2/C4', @IdProgram = 283, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='114',@Name='RàC XX/UL NOUVELLE MAXIMA', @IdProgram = 17, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='13',@Name='CIRCUIT A CARBURANT VW - GOLF', @IdProgram = 27, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='14',@Name='SYSTEME DE MàL ET REMPLISSAGE', @IdProgram = 12, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='140000',@Name='2003 CS PRODUCTION TANK', @IdProgram = 300, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='140002',@Name='DC TK 03.5 CS', @IdProgram = 168, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='150053',@Name='TK 02 E53', @IdProgram = 17, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='150085',@Name='E85', @IdProgram = 322, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='17',@Name='CàC J77', @IdProgram = 334, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800000001',@Name='ABSENCES/CONGES', @IdProgram = 373, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800000002',@Name='REUNIONS', @IdProgram = 272, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800000003',@Name='Formations', @IdProgram = 129, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800000140',@Name='ISO 14001', @IdProgram = 417, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800000900',@Name='ISO 9001', @IdProgram = 251, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800010268',@Name='N68/M49 RECONCEPTION', @IdProgram = 15, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800023001',@Name='TOYOTA IMV (Japon)', @IdProgram = 76, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800023005',@Name='RFQ TOYOTA YARIS II', @IdProgram = 72, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800023006',@Name='RFQ BENCHMARK TOYOTA COROLLA', @IdProgram = 118, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800030005',@Name='T5', @IdProgram = 225, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800030007',@Name='FAP N7 ( FILTRE A PARTICULE )', @IdProgram = 83, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800030008',@Name='PCA A8', @IdProgram = 195, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800030009',@Name='D2X6', @IdProgram = 53, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800030010',@Name='D2Z -DOSSIER CONSULTATION', @IdProgram = 376, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800030017',@Name='RAC N7', @IdProgram = 238, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800030050',@Name='N5 EURO 2000', @IdProgram = 123, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800030052',@Name='T52', @IdProgram = 288, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800030053',@Name='T53 Chine', @IdProgram = 195, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800030056',@Name='T56', @IdProgram = 265, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800030084',@Name='FAP Z8 / V / X4', @IdProgram = 112, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800030108',@Name='PCA A08 Mercosur', @IdProgram = 392, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800030128',@Name='A08 FRANCE', @IdProgram = 239, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800030150',@Name='RFQ B 50/51', @IdProgram = 50, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800030153',@Name='T53 CHINE ESSAIS SOUFFLAGE', @IdProgram = 47, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800030160',@Name='RFQ D2Z', @IdProgram = 354, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800031003',@Name='T1 RECONCEPTION ', @IdProgram = 45, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800031004',@Name='T12 TUBULURE', @IdProgram = 186, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800031016',@Name='T.16 RECONCEPTION', @IdProgram = 232, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800033000',@Name='PCA Machine Iran', @IdProgram = 280, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1800040012',@Name='W84 4X2', @IdProgram = 416, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800040013',@Name='W84 4X4', @IdProgram = 133, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800040014',@Name='W84 GNC(GAZ NATUREL COMPRIME)', @IdProgram = 179, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800040015',@Name='W 84GPL', @IdProgram = 135, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800040041',@Name='W41 VEHICULE DACIA', @IdProgram = 302, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800040070',@Name='X 70 MATRA RSA', @IdProgram = 329, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800040083',@Name='W83', @IdProgram = 128, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800040090',@Name='W90 ROUMANIE', @IdProgram = 274, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800041076',@Name='X76(ECO+EURO 2000+MODIF)', @IdProgram = 229, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800041183',@Name='W83 GPL', @IdProgram = 106, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800041276',@Name='X76 4x4(RAC + PIPE)', @IdProgram = 415, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800042070',@Name='X.70 MASTER PHASE II', @IdProgram = 424, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800042183',@Name='W83 ESPAGNE', @IdProgram = 76, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800043164',@Name='X64 (PRODUIT+EURO2000+MODIF)', @IdProgram = 351, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800043183',@Name='W83 MODIF', @IdProgram = 247, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800043265',@Name='X 65 TURQUIE  BPO TURQUIE', @IdProgram = 262, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800080101',@Name='GM X4400/FIAT 199 (ex small&mild)', @IdProgram = 37, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800080102',@Name='RFQ GM / FIAT MID AND LARGE PLATFORM', @IdProgram = 212, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800080103',@Name='RFQ GM / FIAT SMALL PLATFORM', @IdProgram = 414, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800090510',@Name='TUB SEAT S03 MY 2000', @IdProgram = 417, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800100003',@Name='Nissan JATQ 2WB 4WD', @IdProgram = 164, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800100010',@Name='PLATEFORME C - JAPON (Métrologie)', @IdProgram = 11, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800100020',@Name='NISSAN ZR - SUPPORT JAPON (Métrologie)', @IdProgram = 106, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800100030',@Name='NISSAN T30 JAPON (Métrologie)', @IdProgram = 405, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800100040',@Name='BLOW MOLD.SIMUL.X11C NISSAN (Métrologie)', @IdProgram = 133, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800140002',@Name='MERCEDES MCC', @IdProgram = 428, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800140004',@Name='MERCEDES MCO 33L', @IdProgram = 331, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800140005',@Name='RFQ  SMART SUV', @IdProgram = 240, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800140006',@Name='RFQ SMART CITY COUPE GEN 2', @IdProgram = 279, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800140007',@Name='RFQ DC C-CLASS', @IdProgram = 420, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800140008',@Name='DC NCV2 NAFTA PROJECT', @IdProgram = 192, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800150046',@Name='BMW E.46', @IdProgram = 107, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800150070',@Name='RFQ PL4', @IdProgram = 36, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800150075',@Name='RFQ MINI', @IdProgram = 165, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800150081',@Name='BMW E81-E82/E90 (SERIES 2&3) - PL2', @IdProgram = 169, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800150092',@Name='BMW E9X MOTORSPORT', @IdProgram = 33, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800150093',@Name='E92/93 common FP & E93 diesel vers.', @IdProgram = 373, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800150094',@Name='RFQ BMW E9X PZEV PLASTIC', @IdProgram = 378, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800150095',@Name='PL2 - Parkheating version ""(ICR/ICN 018)""', @IdProgram = 230, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800150096',@Name='RFQ BMW PL2 CHINA', @IdProgram = 186, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800150098',@Name='BMW PL2 E9X SAF', @IdProgram = 428, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800150099',@Name='Localisation of PL2 lines SAF', @IdProgram = 146, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800150100',@Name='BMW ESD', @IdProgram = 392, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800150181',@Name='BMW PL2 - SPIDER/DOVE TAIL FIXATION', @IdProgram = 213, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800150200',@Name='BMW Innovation day', @IdProgram = 91, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1800150246',@Name='PARTICULATE TRAP ADDITIV.TANK BMW E46', @IdProgram = 427, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800150281',@Name='BMW PL2 - NEW U.S. ARCHITECTURE', @IdProgram = 281, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800150346',@Name='BMW E.46 FLOAT VALVE', @IdProgram = 131, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800150381',@Name='BMW PL2 - TASK FORCE PUMP', @IdProgram = 137, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800150465',@Name='BMW E46.5 PLASTIC OMNIUM ALLEMAGNE', @IdProgram = 279, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800150481',@Name='PL2 pump straimer issue', @IdProgram = 263, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800151053',@Name='E53 LEVII', @IdProgram = 86, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800151085',@Name='E85 - New Engine', @IdProgram = 224, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800153085',@Name='BMW E85 - ANALYSE PANNE SUR VEHICULE', @IdProgram = 397, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800160001',@Name='VW A4 AFRIQUE DU SUD', @IdProgram = 417, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800160003',@Name='RFQ : VW LT3', @IdProgram = 400, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800160045',@Name='FA RESERVOIR COLORADO WOLKSWAGEN', @IdProgram = 219, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800160046',@Name='RFQ PQ 46', @IdProgram = 162, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800160047',@Name='RFQ : PL47 CONCEPT', @IdProgram = 298, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800160100',@Name='VW D1 Additive', @IdProgram = 184, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800160124',@Name='VW PQ24 AFRIQUE DU SUD', @IdProgram = 372, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800160135',@Name='RFQ PQ 35 additive', @IdProgram = 125, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800160201',@Name='VW B5 Additive Cont. Improvment', @IdProgram = 144, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800160224',@Name='VW PQ24 CHINE', @IdProgram = 380, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800160235',@Name='RFQ PQ 35 cabriolet', @IdProgram = 5, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800160250',@Name='RFQ SEAT TANGO', @IdProgram = 224, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800160335',@Name='VW PQ35 SOUTH AFRICA', @IdProgram = 54, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800160435',@Name='PQ35', @IdProgram = 95, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800160500',@Name='RFQ Audi Pikes Peak (PL 75 Lang)', @IdProgram = 414, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800160600',@Name='RFQ : VW MICROBUS', @IdProgram = 167, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800160701',@Name='VW COST SAVING', @IdProgram = 215, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1800161024',@Name='PQ24 - CONTINOUS IMPROVEMENTS', @IdProgram = 46, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800161124',@Name='PQ24 SOUTH AFRICA -CONTINOUS IMPROV.', @IdProgram = 43, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800170001',@Name='RESERVOIR GENERIQUE INJECTE', @IdProgram = 103, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170004',@Name='RECYCLAGE', @IdProgram = 433, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170007',@Name='In & off line fluorination performance', @IdProgram = 111, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170008',@Name='FUEL BARRIER TREATMENT & COATING', @IdProgram = 259, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170010',@Name='ISO TS 16949', @IdProgram = 11, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170012',@Name='SAC Material studies', @IdProgram = 393, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170015',@Name='PATENT MANAGEMENT', @IdProgram = 9, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170020',@Name='INPRO / INCHANGE', @IdProgram = 49, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170030',@Name='O VENTING', @IdProgram = 287, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170034',@Name='ELECTRONIC FUEL SYSTEM CONTROL', @IdProgram = 186, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170040',@Name='INERGY UNIVERSITE', @IdProgram = 318, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1800170042',@Name='SAC Competitors analysis', @IdProgram = 297, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170043',@Name='SAC normalisation management', @IdProgram = 85, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170045',@Name='IN TOGETHER', @IdProgram = 109, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170050',@Name='RAC TOLE', @IdProgram = 302, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170051',@Name='ZERO EVAP COMPONENTS', @IdProgram = 260, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170053',@Name='EVAPORATIVE LOSSES EQUIPMENT & PROCEDURE', @IdProgram = 192, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170060',@Name='PIECES DE RECHANGE (Proto)', @IdProgram = 417, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800170070',@Name='LAB NVH expertise', @IdProgram = 107, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170071',@Name='POLE MECANIQUE', @IdProgram = 381, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170073',@Name='GAZ ANALYSES POLE', @IdProgram = 171, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170074',@Name='LAB Refueling expertise', @IdProgram = 257, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170075',@Name='VENTING POLE', @IdProgram = 211, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170076',@Name='COMPONENTS BENCH IMPROVEMENT', @IdProgram = 7, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170077',@Name='METHODOLOGIE PRODUIT PROCESS', @IdProgram = 428, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170078',@Name='APPLICATION METIERS CAO', @IdProgram = 276, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170080',@Name='ACTIVE COMPONENTS BENCHMARKING', @IdProgram = 49, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170081',@Name='BENCHMARKING PASSIVE COMPONENTS', @IdProgram = 199, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170082',@Name='CONFORMATION', @IdProgram = 288, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170085',@Name='R&D MARQUAGE PARAISON', @IdProgram = 413, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170086',@Name='ACQUISITION DE DONNEES', @IdProgram = 346, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170087',@Name='Inerfill', @IdProgram = 384, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170088',@Name='INseal', @IdProgram = 403, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170089',@Name='PZEV VAVE nipples', @IdProgram = 407, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170090',@Name='TSBM', @IdProgram = 180, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170091',@Name='PZEV VAVE - Sender closing system', @IdProgram = 30, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170092',@Name='Multilayer plastic Filler pipe', @IdProgram = 346, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170093',@Name='SAC research support', @IdProgram = 246, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170095',@Name='Contact Level Sensor', @IdProgram = 241, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170096',@Name='Active systems - Hybrid Measurement gaging', @IdProgram = 69, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170097',@Name='Active systems - Vapor management', @IdProgram = 180, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170098',@Name='Active systems - Smart pump concept', @IdProgram = 337, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170100',@Name='Industrial innovation', @IdProgram = 405, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170101',@Name='Industrial Coporate', @IdProgram = 373, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1800170102',@Name='PS - Plant support', @IdProgram = 297, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800170103',@Name='Research CAD support', @IdProgram = 209, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170104',@Name='AGING PROCEDURE', @IdProgram = 428, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170105',@Name='SAC Capless system', @IdProgram = 101, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170107',@Name='SAC Emission studies', @IdProgram = 60, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170109',@Name='Rear Floor Module', @IdProgram = 45, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170110',@Name='SAC exploratory & Tech watch', @IdProgram = 17, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170111',@Name='Filling global simulation', @IdProgram = 175, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170112',@Name='Slosh noise simulation', @IdProgram = 11, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170113',@Name='Venting model', @IdProgram = 6, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170114',@Name='Hot filament welding', @IdProgram = 167, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170115',@Name='New material & process', @IdProgram = 254, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170116',@Name='SCR Urea', @IdProgram = 317, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170117',@Name='IFDM', @IdProgram = 173, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170118',@Name='IFS Europe - Electronic architecture', @IdProgram = 53, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170119',@Name='Pressurized system', @IdProgram = 236, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170120',@Name='KM', @IdProgram = 256, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1800170121',@Name='FRIATEC', @IdProgram = 137, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800170130',@Name='FORMATION QUALITE - FARO/PRELUDE INSPECT', @IdProgram = 215, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170131',@Name='FONCTIONNEMENT SERVICE', @IdProgram = 383, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170132',@Name='Sous activité RDF', @IdProgram = 393, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170133',@Name='Gestion de service', @IdProgram = 282, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170181',@Name='MODULE SOUDURE LOW COST', @IdProgram = 57, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170191',@Name='SLUG RETENTION', @IdProgram = 386, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170200',@Name='ALL Chantier 5S', @IdProgram = 206, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170201',@Name='BE PDM', @IdProgram = 276, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1800170202',@Name='BE Routines & Simulation', @IdProgram = 83, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170203',@Name='Assistance Usine', @IdProgram = 226, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800170204',@Name='BE METHODOLOGY KM', @IdProgram = 161, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1800170205',@Name='BE CAD Administration', @IdProgram = 132, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170206',@Name='LAB Acquisition et automatisation', @IdProgram = 235, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170207',@Name='LAB Bench', @IdProgram = 282, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170208',@Name='Vehicule Laboratoire', @IdProgram = 266, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170209',@Name='SYNERGY (LAB,CAE,ASC)', @IdProgram = 134, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170210',@Name='LAB Laboratory maintenance', @IdProgram = 215, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170215',@Name='LAB Laboratory productivity', @IdProgram = 306, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170220',@Name='LAB Verification and Capacity', @IdProgram = 94, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170224',@Name='ASC - Fuel System Innovation', @IdProgram = 107, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170225',@Name='SAC Barrier Treatment', @IdProgram = 181, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170228',@Name='SAC Components Standardisation', @IdProgram = 312, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170230',@Name='SAC Zero-Evap components', @IdProgram = 218, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170232',@Name='KM C.A.E. Compiègne', @IdProgram = 28, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1800170234',@Name='KM Process Compiègne', @IdProgram = 85, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1800170235',@Name='BD KM product interface design guideline', @IdProgram = 68, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170240',@Name='Méthodologie de mise au point soufflage', @IdProgram = 422, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170245',@Name='R&D Industrial Flexible line', @IdProgram = 145, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1800170250',@Name='PURCHASING Internal Workload', @IdProgram = 44, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1800170255',@Name='Advance purchasing (new components)', @IdProgram = 162, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170260',@Name='FUEL COOLER INTEGRATION', @IdProgram = 337, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170280',@Name='TASK FORCE FLUORATION', @IdProgram = 367, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1800170300',@Name='X84 X76 PASSAGE FINA A BPS', @IdProgram = 253, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800170500',@Name='CAPLESS Lev II = 1800170087C', @IdProgram = 275, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800179999',@Name='HARMONISATION COMPIEGNE/LAVAL', @IdProgram = 341, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800180300',@Name='OPEL T3000', @IdProgram = 329, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800180331',@Name='RFQ A3300 MERCOSUR', @IdProgram = 241, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800180342',@Name='Corsa/Combo/T3000 plant support', @IdProgram = 298, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800180411',@Name='COMBO SO411', @IdProgram = 166, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800180430',@Name='OPEL 4300', @IdProgram = 26, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800180431',@Name='OPEL 4300 BRESIL', @IdProgram = 194, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800180500',@Name='TUBULURE VECTRA - VIE SERIE ', @IdProgram = 114, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800180510',@Name='RFQ REMPLACANTE CORSA FIAT', @IdProgram = 327, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800180600',@Name='OPEL ZAFIRA T0600', @IdProgram = 6, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800180810',@Name='GMIMAN + Cad data management', @IdProgram = 297, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800180820',@Name='TRAINING LABO & SELF CERTIFICAT', @IdProgram = 433, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800180830',@Name='Pre-development GM-DCX Capless/SRD Mal', @IdProgram = 128, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800190087',@Name='PORCHE LUPOLEN 5300 C2/C4', @IdProgram = 363, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800190187',@Name='Porsche 987/997 OPR 2 250 MBAR', @IdProgram = 297, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800190923',@Name='RFQ : PORSCHE 997 GT2/GT3/CUP', @IdProgram = 236, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800190987',@Name='PORSCHE 987/O-EVAP', @IdProgram = 54, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800190997',@Name='PORSCHE 997 (C4)', @IdProgram = 211, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800191044',@Name='PORSCHE 996 4*4', @IdProgram = 345, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800191045',@Name='Colorado', @IdProgram = 239, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800191145',@Name='Colorado LEV II', @IdProgram = 348, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800191986',@Name='PORSCHE 986/996', @IdProgram = 252, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800191997',@Name='PORSCHE 997 TURBO', @IdProgram = 156, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800192045',@Name='Colorado LEV I COST SAVING', @IdProgram = 230, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800192986',@Name='PORSCHE 986/996   MODIF SERIE', @IdProgram = 207, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800192996',@Name='PORSCHE 996 GT2', @IdProgram = 114, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800193046',@Name='Colorado LEV I RESOL', @IdProgram = 321, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800194046',@Name='Colorado Quality issues Canister', @IdProgram = 352, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800195046',@Name='RESOLUTION SPIT-BACK DIESEL', @IdProgram = 104, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800196046',@Name='MODIFICATION DE LA LAME RESSORT', @IdProgram = 213, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800200001',@Name='NISSAN Z W', @IdProgram = 281, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800200003',@Name='NISSAN JATQ', @IdProgram = 279, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800200004',@Name='XX/UK', @IdProgram = 113, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800200010',@Name='PLATEFORM C - Japon', @IdProgram = 1, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800200020',@Name='NISSAN ZR', @IdProgram = 373, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800200030',@Name='C: NISSAN T30', @IdProgram = 53, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800200040',@Name='BLOW MOLDING SIMULATION X11C OF NISSAN', @IdProgram = 348, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800201100',@Name='NISSAN VERSION AA', @IdProgram = 392, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800201840',@Name='ANDERSON/ASSIST SITE TRAIN+VIE+HEURES', @IdProgram = 272, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800201841',@Name='EFDM on MFDM Module Design Troy', @IdProgram = 286, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800201842',@Name='Anderson - ZW support from Process Design', @IdProgram = 364, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800201843',@Name='Anderson - GMT 322', @IdProgram = 347, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800202040',@Name='ADRIAN/ASSIST SITE TRAIN+VIE+HEURES', @IdProgram = 7, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800204001',@Name='Lublin - Progr. Kautex Machine for Dasip', @IdProgram = 379, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800205540',@Name='AREVALO/ ASSIST SITE TRAIN+VIE+HEURES', @IdProgram = 10, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800205541',@Name='MESURE MINI-SHED POUR USINE AREVALO', @IdProgram = 121, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800205542',@Name='Mesure Mini shed Arevalo', @IdProgram = 238, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800205640',@Name='VIGO/ ASSIST SITE TRAIN+VIE+HEURES', @IdProgram = 110, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800205641',@Name='VIGO - ESSAI CONDUITS B58', @IdProgram = 205, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800205740',@Name='ESPAGNE/VALLADOLID ASSIST SITE TRAIN VIE', @IdProgram = 126, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800206100',@Name='BLOW MOLDING SIMULATION - CM OF HYUNDAI', @IdProgram = 92, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800206101',@Name='MECHANICAL SIMULATION FOR HYUNDAI MC', @IdProgram = 324, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800206110',@Name='BLOW MOLDING SIMULATION - MG OF KIA', @IdProgram = 435, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800206120',@Name='BLOW MOLDING SIMULATION-C100 (GM DAEWOO)', @IdProgram = 101, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800206130',@Name='KOREA - 1 PARISON MARKING TOOL KIT', @IdProgram = 209, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800207001',@Name='Meeting supplier Thailand Post cooling', @IdProgram = 31, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800207002',@Name='THAILAND FALTNESS SEAL AREA 2nd MOLD IMV', @IdProgram = 150, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800207003',@Name='Realization of 45 tanks X11C', @IdProgram = 27, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800207004',@Name='THAILAND -IMV TRANSFERT LINE KB400/KB300', @IdProgram = 289, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800210001',@Name='ALLIANCE INERGY', @IdProgram = 90, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1800210740',@Name='BURSA/ ASSIST SITE TRAIN+VIE+HEURES', @IdProgram = 160, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800210741',@Name='BPO - H. Gyr support to change Extruder', @IdProgram = 396, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800210742',@Name='Turquey - Technical assistance', @IdProgram = 165, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800215000',@Name='ASSISTANCE USINE COMPIEGNE', @IdProgram = 91, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800215001',@Name='Support RDF Usines France - 1er semestre', @IdProgram = 92, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800215440',@Name='FONTAINE/ASSISTANCE SITE TRAIN VIE+HEURE', @IdProgram = 207, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800215540',@Name='GRENAY/ ASSIST SITE TRAIN+VIE+HEURES', @IdProgram = 420, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800215640',@Name='NUCOURT/ ASSIST SITE TRAIN+VIE+HEURES', @IdProgram = 267, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800215740',@Name='LAVAL/ ASSIST SITE TRAIN+VIE+HEURES', @IdProgram = 192, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800216140',@Name='FRANCE MAF RENNES - MATERIEL', @IdProgram = 260, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800216240',@Name='RETROFIT BFB 2-30 COMPIEGNE (VIGO 2003)', @IdProgram = 288, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800220740',@Name='EISENACH ASSIST SITE TRAIN+VIE+HEURES', @IdProgram = 374, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800220741',@Name='FILLER PIPE E8X - EISENACH', @IdProgram = 3, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800220742',@Name='VALIDATION NEW SCREWS - PL2 EISENACH', @IdProgram = 227, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800220743',@Name='ASSISTANCE PL2 EISENACH  - F.BAJOR', @IdProgram = 341, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800220744',@Name='Technical Assistance Eisenarch FP 8x', @IdProgram = 130, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800220749',@Name='EISENACH - MODIF.2 COMPONANTS -B5 ADDITI', @IdProgram = 409, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800220840',@Name='ROTTENBURG/ASSIST SITE TRAIN+VIE+HEURES', @IdProgram = 386, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800220841',@Name='Technical Assistance Rotenburg C4 LHD start-up sup', @IdProgram = 267, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800220842',@Name='ROT - 2 BM DASIP', @IdProgram = 424, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800220843',@Name='ROT - Assistance RAC E9x', @IdProgram = 101, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800220844',@Name='ROT - Measure Bonde E8x/E9x', @IdProgram = 215, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800220850',@Name='Start-up support Rottenburg C2', @IdProgram = 371, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800220851',@Name='Installation Mold C4', @IdProgram = 155, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800220852',@Name='ROTTENBURG-SLED TEST VALIDATION OF E9X', @IdProgram = 400, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800221893',@Name='Assistance technique G. Auvergne', @IdProgram = 420, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800225640',@Name='HERENTAL/ASSIST SITE TRAIN+VIE+HEURES', @IdProgram = 204, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800225641',@Name='Technical Assistance Herentals (on Colorado Filler', @IdProgram = 346, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800225642',@Name='HERENTALS - MINI SHED TESTS ON 2 T1 FS', @IdProgram = 167, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800225644',@Name='HERENTALS- FP BMW E85 EVOH ISSUE', @IdProgram = 300, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800225740',@Name='FLUORATION IN LINE HERENTALS', @IdProgram = 115, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800230002',@Name='TOYOTA IMV AFRIQUE DU SUD LWB', @IdProgram = 338, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800230450',@Name='ASSIST ROTTENBURG/ASSIST.DIRECT INDUSTRI', @IdProgram = 129, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800235010',@Name='RECEPT°& MODIF FOR C PLATFORM AA - JAPAN', @IdProgram = 290, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800235020',@Name='TRIALS TO JPO FOR ZR Canada - JAPAN', @IdProgram = 16, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800235030',@Name='TRIALS TO JPO FOR CPLATFORM AA - JAPAN', @IdProgram = 428, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800235040',@Name='JAPON/ASSIST SITE TRAIN+VIE+HEURES', @IdProgram = 284, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800235050',@Name='ASS.JAPAN - SIMUL.SETUP TOOLKIT (heures)', @IdProgram = 315, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800235060',@Name='VALID.SENDER UNIT CLOSING SYSTEM - JAPAN', @IdProgram = 258, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800235070',@Name='Assistance of J.F. Coing', @IdProgram = 59, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800235080',@Name='Peter Knobloch assistance to Japan', @IdProgram = 405, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800235081',@Name='Gregory Auvergne assistance to Japan', @IdProgram = 226, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800235082',@Name='Purchasing PE Plates & PE Tubes', @IdProgram = 19, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800235083',@Name='SHI - Coaching B2E Core Team', @IdProgram = 139, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800240006',@Name='EPSILON SAAB HFV6', @IdProgram = 46, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800240032',@Name='Plant Support Herentals for Epsilon', @IdProgram = 163, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800240144',@Name='BRI - Post cooling BMW E9x', @IdProgram = 175, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800240145',@Name='BRI - Plant training - L. Cassarin', @IdProgram = 258, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800240190',@Name='GM ISUZU 190', @IdProgram = 415, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800240200',@Name='EPSILON COST SAVING ', @IdProgram = 398, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800240201',@Name='GM COST SAVING SMALL & MIDDLE PLATFOR', @IdProgram = 425, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800240202',@Name='EPSILON SVDO Quality problem', @IdProgram = 278, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800240260',@Name='EPSILON', @IdProgram = 214, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800240261',@Name='EPSILON 3100', @IdProgram = 75, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800240267',@Name='EPSILON DIESEL COOLING SYSTEM', @IdProgram = 264, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800240268',@Name='EPSILON 3110', @IdProgram = 388, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800240270',@Name='EPSILON LOGISTIQUE ALLEMAGNE', @IdProgram = 123, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800240271',@Name='EPSILON LOGISTIQUE ANGLETERRE', @IdProgram = 355, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800240272',@Name='EPSILON 3200 DIESEL QUALITY PROBLEM', @IdProgram = 324, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800240320',@Name='GMT 320 ', @IdProgram = 335, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800240345',@Name='GMT 345', @IdProgram = 39, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800240404',@Name='SAAB 404 Petrol', @IdProgram = 432, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800240406',@Name='EPSILON Saab 406 Diesel Filter', @IdProgram = 139, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800240440',@Name='SAAB 440 Diesel', @IdProgram = 10, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800240442',@Name='SAAB NEW VERSIONS 442/443/JTD', @IdProgram = 142, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800240610',@Name='EPSILON 0610', @IdProgram = 153, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800240740',@Name='TELFORD/ ASSIST SITE TRAIN+VIE+HEURES', @IdProgram = 426, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800240741',@Name='Sled tests on BMW E85 - Anderson', @IdProgram = 92, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800240742',@Name='Cut out plate + Soudure stopping', @IdProgram = 306, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800240805',@Name='GMT 805/830', @IdProgram = 149, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800241005',@Name='CORVETTE', @IdProgram = 32, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800241263',@Name='EPSILON 3210 SOP + 1Y', @IdProgram = 4, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800241805',@Name='GMT 805/830 LEVII', @IdProgram = 327, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800242355',@Name='GMT 355', @IdProgram = 346, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800242805',@Name='GMT 805/830 LEVII IRS', @IdProgram = 114, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800245140',@Name='BRITS/ ASSIST SITE TRAIN+VIE+HEURES', @IdProgram = 357, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800245141',@Name='Change over BMW E46 from B80 to KB300', @IdProgram = 103, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800245142',@Name='Technical Assistance Britz ', @IdProgram = 37, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800245143',@Name='Finishing machine E9x - Set-up', @IdProgram = 400, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800245150',@Name='FUEL TANK BMW E46 JAPAN / AFR.DU SUD', @IdProgram = 207, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800245151',@Name='Laurent Cassarin Grand assistance to Japan', @IdProgram = 337, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800245152',@Name='SLED TEST 4 SERIAL OF NISSAN X11C JAPON', @IdProgram = 157, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800250010',@Name='SANGYONG A100', @IdProgram = 432, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800250020',@Name='RAC MG -KIA', @IdProgram = 365, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800250040',@Name='COREE ASSIST SITE TRAIN+VIE+HEURES', @IdProgram = 34, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800250041',@Name='HYU C100 Mechanical simulation', @IdProgram = 401, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800250042',@Name='A100 Vibration test', @IdProgram = 192, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800250043',@Name='Validation of the new shed equipment', @IdProgram = 347, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800250044',@Name='PURCH.OF PE PARTS', @IdProgram = 32, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800250045',@Name='PURCH.OF RESIN AND LAB. GOW', @IdProgram = 298, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800250046',@Name='MINI SHED TEST FOR C100', @IdProgram = 116, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800250047',@Name='COREE - PROJECT C100 TECHN.PLANT SUPPORT', @IdProgram = 413, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800250050',@Name='MG D et C100 Korea', @IdProgram = 365, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800250051',@Name='COREE -BLOW MOLD.& MECHANICAL SIM.TRAINI', @IdProgram = 198, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800250052',@Name='COREE - PURCH. OF 5000 NIPPLES FOR TEST', @IdProgram = 281, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800250053',@Name='Rack caster', @IdProgram = 111, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800250054',@Name='Production Engineer support for DFMEA', @IdProgram = 122, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800250055',@Name='KIA MG Process design', @IdProgram = 114, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800250056',@Name='Testing for CM fuel system', @IdProgram = 403, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800250057',@Name='MG Nafta Drop Test Failure', @IdProgram = 10, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800250058',@Name='Technical Assistance Korea - Selling part', @IdProgram = 130, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800250059',@Name='Technical Assistance Korea - Fuel tank MG', @IdProgram = 45, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800250060',@Name='NOH ASSIST SITE TRAIN+VIE+HEURES', @IdProgram = 71, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800250061',@Name='Lend Post blowing NOH', @IdProgram = 302, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800250062',@Name='Pipette basse perméabilité NOH', @IdProgram = 213, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800250063',@Name='Trial L42A PZEV on HEV Nissan', @IdProgram = 337, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800250064',@Name='DISPLACEMENT INTEGRATION IN VEGAv5 - NOH', @IdProgram = 382, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800250065',@Name='Technical Assistance NOH - Pierre Lacome', @IdProgram = 5, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800250066',@Name='Technical Assistance NOH - Quotation DC 90l', @IdProgram = 74, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800250067',@Name='Standard Valves', @IdProgram = 220, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800250068',@Name='Vibration test', @IdProgram = 323, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800250070',@Name='BELGIQUE - IMPLANT.CANISTER SUR SAC T1', @IdProgram = 388, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800250072',@Name='SLED TESTS ON PQ24 SOUTH AFRICA TANKS', @IdProgram = 198, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800250073',@Name='Permeation test on E46 fuel tank', @IdProgram = 68, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800250074',@Name='PERMEATION TEST ECE 34 ON SHELLS PQ24', @IdProgram = 384, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800250075',@Name='VW PQ35 - Trial Brits', @IdProgram = 411, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800250080',@Name='VIBRATION TEST ON 9 SAMPLES - NOH', @IdProgram = 390, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800250081',@Name='IFS System', @IdProgram = 325, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800250082',@Name='Mini shed tests on 5 Multilayer parts', @IdProgram = 173, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1800250083',@Name='TRANSPORT OF PARTS IFS - SYSTEMS', @IdProgram = 43, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='1800250084',@Name='TROY - ELECTRICAL COMPONENTS VALIDATION', @IdProgram = 250, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800260002',@Name='RFQ SUZUKI YN2', @IdProgram = 9, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800260003',@Name='RFQ SUZUKI NBC', @IdProgram = 24, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800260100',@Name='LOZORNO -VALIDATION OF 18 COLORADO TANKS', @IdProgram = 210, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800260101',@Name='LOZ - TL 668 Period. Test for PQ24', @IdProgram = 161, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800260102',@Name='SLED TEST ON COLORADO 9 PARTS', @IdProgram = 194, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800260103',@Name='Colorado - Flvv Custo. Reclamation', @IdProgram = 332, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800260140',@Name='MONTERREY/ASSISTANCE TRAIN DE VIE +HEURE', @IdProgram = 230, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800265540',@Name='CURITIBA/ASSIST SITE TRAIN+VIE+HEURES', @IdProgram = 58, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800265640',@Name='TAUBATE/ASSIST.SITE TRAIN+VIE+HEURES', @IdProgram = 190, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800270010',@Name='KB2 360 TRAIN DE VIE + HEURES', @IdProgram = 104, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800270130',@Name='FORMATIONS - ASSISTANCES - FARO-PRELUDE', @IdProgram = 355, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800271040',@Name='BRATISLAVA/ASSIST.SITE TRAIN+VIE+HEURES', @IdProgram = 135, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800271041',@Name='BRATISLAVA - NEW MOLD/MACHINE PL71 - POR', @IdProgram = 104, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1800290100',@Name='VOLVO EUCD 4WD ECE/DIESEL/LEV2', @IdProgram = 435, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800290110',@Name='VOLVO EUCD 2WD PZEV', @IdProgram = 67, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1800290120',@Name='VOLVO EUCD 4WD LEV2', @IdProgram = 154, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1810148800',@Name='ECE Petrol Diesel Serial fuel tank BR451', @IdProgram = 140, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='1810181101',@Name='PRODUCTIVITE CC PSA', @IdProgram = 120, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1810181102',@Name='SERIE CC PSA', @IdProgram = 115, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1810182101',@Name='PRODUCTIVITE CC RSA', @IdProgram = 363, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1810182102',@Name='SERIE CC RSA', @IdProgram = 358, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1810183101',@Name='PRODUCTIVITE DAIMLER CHRYSLER', @IdProgram = 400, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1810183102',@Name='SERIE CC DAIMLER CHRYSLER', @IdProgram = 385, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1810184101',@Name='PRODUCTIVITE CC GM ROW', @IdProgram = 50, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1810184102',@Name='SERIE CC GM ROW', @IdProgram = 347, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='181018510',@Name='PRODUCTIVITE CC BMW', @IdProgram = 151, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1810185102',@Name='SERIE CC BMW', @IdProgram = 235, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1810186101',@Name='PRODUCTIVITE CC PORSCHE', @IdProgram = 389, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1810186102',@Name='SERIE CC PORSCHE', @IdProgram = 394, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1810190000',@Name='Delegation', @IdProgram = 129, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='1810200000',@Name='OPTIMISATION LOGISTIQUE COMPOSANTS', @IdProgram = 290, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1810200001',@Name='Chinese sourcing', @IdProgram = 311, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='1810200004',@Name='Audi & VW innovation day', @IdProgram = 143, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='1810200005',@Name='Japon Innovation days', @IdProgram = 77, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='2001',@Name='PRESTATION SUPPORT HORS PROJET UK', @IdProgram = 20, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='2002',@Name='PRESTATION SUPPORT HORS PROJET SPAIN VI', @IdProgram = 370, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='2003',@Name='PRESTATION SUPPORT HORS PROJET SAPS', @IdProgram = 227, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='2004',@Name='OPEL COMBO S0411 1800 180 411 IASC', @IdProgram = 86, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='2005',@Name='CàC BMW E46 180015004', @IdProgram = 364, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='2006',@Name='CàC E53 BMW', @IdProgram = 345, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='2007',@Name='PREST. SUPPORT HORS PROJET COREE', @IdProgram = 159, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='2008',@Name='PRESTATIONS CONSEILS GIAT', @IdProgram = 11, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='2009',@Name='PCA A8 Mercosur', @IdProgram = 199, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='2012',@Name='RESERVOIR FAP 3éme GENERATION', @IdProgram = 380, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='2015',@Name='VALIDATION MODIFICATION RESINE RSB 714', @IdProgram = 417, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='2016',@Name='PORSCHE C4 1800190997', @IdProgram = 48, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='2017',@Name='GM OPEL A3300 1800 180 330', @IdProgram = 247, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='2018',@Name='GM OPEL A3370 1800 180 330', @IdProgram = 384, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='2019',@Name='GM EPSILON 0610 1800 240 610', @IdProgram = 23, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='2020',@Name='CIRCUIT A CARBURANT A7', @IdProgram = 237, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='2021',@Name='TOYOTA YARIS AVANCE DE PHASE CC RSA', @IdProgram = 216, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='2022',@Name='CHANGEMENT MATIERE FOURNISSEUR CABOT', @IdProgram = 47, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='2026',@Name='HYBRID GAGING TRIALS', @IdProgram = 123, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='2027',@Name='CHANGEMENT MATIERE FOURNISSEUR ATOFINA', @IdProgram = 391, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='2028',@Name='CLAPETS CRSMF-CRMF', @IdProgram = 116, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='2029',@Name='TUBULURE X61 B', @IdProgram = 309, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='2030',@Name='TUBULURE DIESEL MISE A LA MASSE ESD', @IdProgram = 312, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='2031',@Name='ANALYSE DE LA CONCURRENCE 1800 170 042', @IdProgram = 380, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='2032',@Name='CIRCUIT A CARBURANT Z9', @IdProgram = 121, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='209000na',@Name='GM FP 03 GMT355 NA', @IdProgram = 17, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='209000TH',@Name='GM FP 03 I190 ISUZU', @IdProgram = 160, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='209500NA',@Name='GM TK 03 GMT355 NA', @IdProgram = 295, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='209500TH',@Name='GM TK 03 I190 ISUZU', @IdProgram = 143, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='230000',@Name='GM TK 03 GMX320', @IdProgram = 422, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='230001',@Name='2003 GMX 320 Production', @IdProgram = 427, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='240815',@Name='GMT 805/830 S15', @IdProgram = 359, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='24183015',@Name='GM TK 04 GMT830 S15 LEVII', @IdProgram = 395, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='24183025',@Name='GM TK 04 GMT830 S25 LEVII', @IdProgram = 356, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='24183026',@Name='GMT 830 LEV2 25 Series Rear Tank', @IdProgram = 149, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='2600',@Name='PRODUCTIVITE GAZ', @IdProgram = 10, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='2601',@Name='SRDMALPhase2', @IdProgram = 62, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='2602',@Name='DURABILITE DES RESERVOIRS', @IdProgram = 129, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='2603',@Name='LIAISON BOUCHON TETE', @IdProgram = 212, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='2604',@Name='SàC X06 ANALYSE CONCURRENCE', @IdProgram = 22, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='2606',@Name='COMPORTEMENT RESERVOIRS EN DEPRESSION', @IdProgram = 64, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='2607',@Name='SUIVI FOURN.COMP.ACTIFS', @IdProgram = 168, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='2700',@Name='R&D INDUSTRIELLE', @IdProgram = 244, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='2710',@Name='CAPITALISATION EXPERIENCE INDUS', @IdProgram = 426, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='3001',@Name='CàC T53 CHINE', @IdProgram = 249, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='3002',@Name='SYSTEME A CARBURANT B58', @IdProgram = 385, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='3003',@Name='GLOBAL SOURCING MODULES P/J', @IdProgram = 242, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='3004',@Name='BD 100', @IdProgram = 113, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='3005',@Name='ROVER RXX60', @IdProgram = 30, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='3006',@Name='CREATION SITE INERGY PITESTI ROUMANIE', @IdProgram = 29, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='3007',@Name='X3 (Restyling X4)', @IdProgram = 410, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='3008',@Name='CLAPETS TOUS TYPES', @IdProgram = 20, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='3009',@Name='PCA Canister Integration', @IdProgram = 89, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='3010',@Name='CIRCUIT A CARBURANT W44 REMPL TWINGO', @IdProgram = 395, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='3011',@Name='CIRCUIT A CARBURANT W61 REMPL KANGOO', @IdProgram = 354, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='3012',@Name='V34x FORD TRANSIT', @IdProgram = 199, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='3013',@Name='CIRCUIT A CARBURANT G9-V', @IdProgram = 348, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='3014',@Name='CIRCUIT A CARBURANT NOUVELLE PRIMERA', @IdProgram = 31, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='3015',@Name='PREST. SUPPORT HORS PROJET Allemagne', @IdProgram = 180, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='3017',@Name='PRESTATION SUPPORT HORS PROJET USA', @IdProgram = 262, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='3018',@Name='Budget 2004 - T7 circuit à carburant', @IdProgram = 197, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='3019',@Name='INCIDENT QUALITE MODULE BOSCH', @IdProgram = 53, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='33',@Name='ETUDE CAPABILITES DE JAUGEAGE', @IdProgram = 138, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='3400',@Name='PETIT SOUFFLEUR SOFTWARE VALIDATION D2', @IdProgram = 334, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='3401',@Name='CARACT.PISTOLET CARBURANT 073654000042', @IdProgram = 422, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='3402',@Name='INsas', @IdProgram = 425, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='3403',@Name='Clinfill', @IdProgram = 260, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='3500',@Name='R&D INDUSTRIELLE P Maréchal', @IdProgram = 431, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='3501',@Name='Knowledge Management', @IdProgram = 359, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='3503',@Name='SAMPLES WORLDWIDE', @IdProgram = 9, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='36',@Name='FILIALISAT. AIR-CAR', @IdProgram = 118, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='3600',@Name='INNOVATION CIRCUIT A CARBURANT', @IdProgram = 101, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='3601',@Name='Expertise SAC', @IdProgram = 193, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='3602',@Name='KNOWLEDGE MANAGT + STANDARDIS° PLANS', @IdProgram = 325, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='4001',@Name='SUIVI PIECES SERIE SPID 53 (rempl. par 04006)', @IdProgram = 122, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='4002',@Name='CIRCUIT A CARBURANT W91', @IdProgram = 225, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='4003',@Name='PIPE DE REMPLISSAGE X11E', @IdProgram = 105, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='4004',@Name='T1 CHINE', @IdProgram = 225, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='4005',@Name='RESERVOIR A CARBURANT X70PH1 MERCOSUR', @IdProgram = 3, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='4006',@Name='SUIVI PIECES SERIE SPID 53', @IdProgram = 38, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='4007',@Name='CIRCUIT A CARBURANT T12 BRESIL', @IdProgram = 97, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='4008',@Name='L90 IRAN', @IdProgram = 229, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='4020',@Name='PCA Transversal hors clapets', @IdProgram = 437, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='4021',@Name='RSA Transversal hors clapet', @IdProgram = 58, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='4022',@Name='Evolution Matiere France', @IdProgram = 132, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='4023',@Name='RSA X70 phase 2 Pre-cotation', @IdProgram = 168, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='403006',@Name='DC TK 03 AN', @IdProgram = 169, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='403502',@Name='DC TK 04 HB', @IdProgram = 343, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='4400',@Name='TAF04/0003 MISSION RSA SRDMàL', @IdProgram = 268, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='4401',@Name='R&D INDUSTRIALISATION 2004', @IdProgram = 400, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='4402',@Name='ENVOI PIECES F.DOUGNIER 073654000035', @IdProgram = 245, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='4404',@Name='Canister intégré T7', @IdProgram = 82, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='4405',@Name='INValve', @IdProgram = 241, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='4406',@Name='Rear floor X84', @IdProgram = 91, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='444444',@Name='BMW Continuous Improvement', @IdProgram = 78, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='4500',@Name='SUPPORT TO EDOUARD ZYWIEC-SWAT TEAM', @IdProgram = 242, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='4501',@Name='PLM road show', @IdProgram = 3, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='4600',@Name='FUEL SYSTEMS INNOVATIONS', @IdProgram = 406, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='4603',@Name='COMPETITION PRODUCT ANALYSIS', @IdProgram = 104, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='4604',@Name='INERGY UNIVERSITY', @IdProgram = 393, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='4605',@Name='DATA base follow-up', @IdProgram = 410, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='4606',@Name='SYNERGIES TEAMS', @IdProgram = 351, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='4609',@Name='GAUGING EXPERTISE + DEFORMATION', @IdProgram = 354, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='4610',@Name='STANDARD SPECIFICATIONS', @IdProgram = 95, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='4611',@Name='VISITEURS ASIATIQUES', @IdProgram = 100, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='4612',@Name='ISO 14000 QHS', @IdProgram = 419, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='4613',@Name='Clapet Membrane', @IdProgram = 324, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='4614',@Name='Mason jar Packman', @IdProgram = 309, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='48',@Name='CAPITALISATION EXPERIENCE FAC', @IdProgram = 332, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='5002',@Name='ASSIST.G9 PAR ST CAR SURCHARGE UP TURNER', @IdProgram = 32, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='5003',@Name='PREST. SUPPORT HORS PROJET IRAN', @IdProgram = 14, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='5401',@Name='INDUS INNOVATION', @IdProgram = 257, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='5500',@Name='Warranty issues', @IdProgram = 401, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='5501',@Name='LESSONS LEARNED', @IdProgram = 306, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='5502',@Name='Marketing', @IdProgram = 166, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='5503',@Name='MANAGEMENT PANEL FOURNISSEURS', @IdProgram = 68, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='5504',@Name='INTERNAL INDUS FP STRATEGY/D2C RFQ', @IdProgram = 396, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='5600',@Name='Drawings standardization', @IdProgram = 362, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='5605',@Name='Updating Labo data acquisition software', @IdProgram = 180, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='5606',@Name='SYNERGIE BE/INDUS  (DEVLPT DPT)', @IdProgram = 326, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='5607',@Name='DESIGN TO COST', @IdProgram = 416, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='5608',@Name='DEMARCHE QUALITE DEVELOPPEMENT', @IdProgram = 428, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='5609',@Name='Caractérisation jets pistolets + usure', @IdProgram = 265, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='5610',@Name='CAD EFFICIENCY', @IdProgram = 282, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='5700',@Name='STANDARDISATION INDUS', @IdProgram = 22, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='5701',@Name='INERGY UNIVERSITY (INDUS DPT)', @IdProgram = 251, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='5703',@Name='SYNERGIE BE/INDUS (INDUS DPT)', @IdProgram = 134, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='5704',@Name='ASSISTANCE B GAUTHERIN', @IdProgram = 171, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='58',@Name='SA INC-PREST°SUPP. HORS PROJ.', @IdProgram = 315, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='5800',@Name='GENERIC PFMEA  (QUAL ENG)', @IdProgram = 294, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='5801',@Name='ISO TS 16949  (QUAL ENG)', @IdProgram = 172, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='62',@Name='RESERVOIR A CARBURANT ROADSTER', @IdProgram = 287, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='63',@Name='RESERVOIR A CARBURANT TT', @IdProgram = 187, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='720001',@Name='R&D 2002 Internal Venting & OBD', @IdProgram = 318, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='720002',@Name='R&D 2002 Smart Pump Concept (active system)', @IdProgram = 67, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='720003',@Name='R&D 2002 Canister of Tomorrow', @IdProgram = 258, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='720005',@Name='R&D 2002 Flange Integration', @IdProgram = 198, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='720007',@Name='Low Emissions COEX Spuds', @IdProgram = 395, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='720008',@Name='R&D 2002 Filler Pipes (multilayer plastic)', @IdProgram = 262, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='720009',@Name='R&D 2002 Tank inlets & outlets (optimized)', @IdProgram = 126, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='720010',@Name='R&D 2002 Noise reduction (inside car)', @IdProgram = 196, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='720016',@Name='R&D 2002 Metal Tank', @IdProgram = 350, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='720017',@Name='R&D 2002 INFILM', @IdProgram = 123, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='720018',@Name='R&D 2002 Inpinch - opt emissions, strength…', @IdProgram = 297, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='720020',@Name='R&D 2002 PZEV demo system arch, assy & testing', @IdProgram = 41, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='720021',@Name='R&D 2002 ESD Projects', @IdProgram = 231, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='720022',@Name='R&D 2002 SRDMAL Valve', @IdProgram = 409, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='720024',@Name='R&D 2002 US PZEV (Inblow/Inpinch/Infilm)', @IdProgram = 36, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='730001',@Name='R&D 2003 New Materials and Processes', @IdProgram = 140, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='730002',@Name='R&D 2003 Inpipe - 3D Multilayer plastic Pipe', @IdProgram = 422, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='730003',@Name='R&D 2003 Contactless level sensor', @IdProgram = 31, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='730004',@Name='R&D 2003 PFT in-outlets, ext. valve, internal comp', @IdProgram = 299, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='730005',@Name='R&D 2003 Reduction of noise transmission', @IdProgram = 130, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='730006',@Name='R&D 2003 IN-Pinch', @IdProgram = 74, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='730007',@Name='R&D 2003 IN-Film', @IdProgram = 104, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='730008',@Name='R&D 2003 OBD Architecture', @IdProgram = 303, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='730009',@Name='Canister of Tomorrow', @IdProgram = 121, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='73001',@Name='R&D Sulfonation - LEV II', @IdProgram = 431, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='730010',@Name='R&D 2003 PZEV Demo system Validation', @IdProgram = 158, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='730011',@Name='R&D 2003 COEX SPUD', @IdProgram = 435, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='730012',@Name='R&D 2003 Coex Cover manufacturing', @IdProgram = 308, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='730014',@Name='R&D 2003 SRDMAL valve - CV replacement', @IdProgram = 52, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='730015',@Name='R&D 2003 Marketing of Research results', @IdProgram = 68, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='730016',@Name='R&D 2003 Synergy Teams', @IdProgram = 51, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='730017',@Name='Sulfonation - LEV II', @IdProgram = 152, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='83001',@Name='Ford 08TK D219/D258', @IdProgram = 366, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='89111',@Name='RES CARBURANT TRAFIC E233', @IdProgram = 67, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='89124',@Name='RESERVOIR CARBURANT N2', @IdProgram = 27, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='89147',@Name='TUBULURE REMPLISSAGE X1', @IdProgram = 345, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='89168',@Name='RESERVOIR A CARBURANT X1', @IdProgram = 45, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='900001',@Name='Hyundai CM', @IdProgram = 180, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='90168',@Name='TUBULURE REMPLISSAGE T1N', @IdProgram = 132, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='91',@Name='EXTENSION LOCAUX SIEGE (SOGEBAIL)', @IdProgram = 423, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='91040',@Name='TUBULURE DE REMPLISSAGE  N37 / N57', @IdProgram = 28, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='91052',@Name='TUBULURE DE REMPLISSAGE U64', @IdProgram = 373, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='92063',@Name='RESERVOIR A CARBURANT X65', @IdProgram = 171, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='92064',@Name='PIPE DE REMPLISSAGE X65', @IdProgram = 241, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='92068',@Name='CLAPET ASS.SPD SEMI-AUTO DIV', @IdProgram = 125, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='92079',@Name='RESERVOIR F40 ELECTRIQUE F40', @IdProgram = 351, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='92135',@Name='RESERVOIR CHAUFFAGE ELECTRIQUE S4/M49', @IdProgram = 393, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='93144',@Name='TUBULURE DE REMPLISSAGE OPEL 2900 VECTRA', @IdProgram = 12, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='93271',@Name='RESERVOIR A CARBURANT X70', @IdProgram = 83, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='93310',@Name='SA IBERICA PRESTATION SUPPORT HORS PROJ.', @IdProgram = 405, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='94010',@Name='RESERVOIR A CARBURANT N6', @IdProgram = 46, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='94044',@Name='NORME EURO 3 DIVERS', @IdProgram = 30, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='94073',@Name='CIRCUIT A CARBURANT T1', @IdProgram = 12, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='94132',@Name='RESERVOIR A CARBURANT + PIPE P5 - W74', @IdProgram = 340, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='94135',@Name='RESERVOIR CARBURANT & TUBULURE SMART', @IdProgram = 273, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='95',@Name='TUBULURE X2 TRANSFERT IRAN', @IdProgram = 51, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='95052',@Name='CLAPET ROV P52', @IdProgram = 2, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='95100',@Name='BOL DE PIPE (SANS GPL) X65', @IdProgram = 107, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='95193',@Name='CIRCUIT A CARBURANT Z8', @IdProgram = 196, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='96',@Name='RESERVOIR X2 TRANSFERT IRAN', @IdProgram = 384, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='96067',@Name='RESERVOIR A CARBURANT X2', @IdProgram = 365, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='96080',@Name='RACCORD SORTIE TURBO DW10ATED T5', @IdProgram = 384, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='96095',@Name='SA ARGENTINA PRESTATION SUPP. HORS PROJ', @IdProgram = 366, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='96096',@Name='FILTRE A AIR T5', @IdProgram = 8, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='96101',@Name='TURBO 2001', @IdProgram = 5, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='96129',@Name='PdR X2', @IdProgram = 245, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='96158',@Name='RESERVOIR A CARBURANT X64/J64', @IdProgram = 406, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='96159',@Name='TUBULURE ARGENTINE X64(MEGANE)', @IdProgram = 426, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='96164',@Name='CIRCUIT A CARBURANT X4', @IdProgram = 425, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='96205',@Name='CLAPET CRSMF CAPACITE VIDANGEA', @IdProgram = 33, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='96208',@Name='TUBULURE REMPLISSAGE X4', @IdProgram = 274, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='96212',@Name='CLAPET MULTIFONCTIONS DEG. RAC', @IdProgram = 148, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='96219',@Name='CIRCUIT A CARBURANT T5', @IdProgram = 208, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='97',@Name='DEVELOP. TETE OBTURAT° INTEGREE', @IdProgram = 336, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='97058',@Name='RESERVOIR LAVE-VITRE BRESIL J64', @IdProgram = 48, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='97075',@Name='CIRCUIT A CARBURANT LD100', @IdProgram = 371, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='97096',@Name='RESERVOIR ET TUBULURE BERLINGO M49', @IdProgram = 7, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='97097',@Name='RESERVOIR + TUBULURE W76 KANGOO', @IdProgram = 299, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='97108',@Name='RESERVOIR A CARBURANT + PIPE P5 - W73', @IdProgram = 363, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='97120',@Name='DECHARGE ELECTROSTATIQUE PDR TOUS', @IdProgram = 47, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='97133',@Name='TUBULURE EURO 3 VECTRA VECTRA', @IdProgram = 116, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='98',@Name='SA THAILAND PREST. SUP. HS. PJ', @IdProgram = 19, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='98014',@Name='RESERV A CARBURANT BRESIL X65', @IdProgram = 218, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='98015',@Name='PIPE DE REMPLISSAGE BRESIL X65', @IdProgram = 69, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='98018',@Name='CIRCUIT A CARBURANT W81', @IdProgram = 309, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='98058',@Name='CàC A81', @IdProgram = 15, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='98066',@Name='CIRCUIT A CARBURANT T16', @IdProgram = 79, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='98070',@Name='CIRCUIT A CARBURANT X84', @IdProgram = 349, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='98071',@Name='RESERVOIR A CARBURANT MCO / MCD', @IdProgram = 38, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='98082',@Name='SA POLSKA PRESTATION SUPPORT HORS PROJET', @IdProgram = 91, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='98083',@Name='PLASTAUTO PRESTATION SUPPORT HORS PROJET', @IdProgram = 284, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='98101',@Name='CIRCUIT A CARBURANT V', @IdProgram = 120, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='99',@Name='CàC T1 IRAN', @IdProgram = 228, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='99003',@Name='INTEGRATION CANISTER SUR  RAC .', @IdProgram = 29, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='99034',@Name='RESERVOIR A CARBURANT X70F4R X70', @IdProgram = 342, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='99039',@Name='SA ROMANIA PRESTATION SUPPORT HORS PROJ.', @IdProgram = 214, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='99046',@Name='RESERVOIR A CARBURANT X65-V6 X57', @IdProgram = 252, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='99057',@Name='CIRCUIT A CARBURANT N7    RESTYLING N6', @IdProgram = 42, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='99063',@Name='ETUDE BRUITS CLAPOT SUR RAC DIV', @IdProgram = 265, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='99066',@Name='RESERVOIR + TUBULURE 5000 USD', @IdProgram = 239, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='99068',@Name='PROJET RECAFUTA', @IdProgram = 280, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='99069',@Name='CONSTRUCTION SIEGE A CX BAT', @IdProgram = 124, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='99072',@Name='CIRCUIT A CARBURANT T1   206 ARGENTINE', @IdProgram = 407, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='99073',@Name='RESERVOIR A CARBRANT ASTRA (RSA)', @IdProgram = 309, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='99082',@Name='CIRCUIT A CARBURANT D2-D23  D80', @IdProgram = 269, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='99083',@Name='CIRCUIT A CARBURANT X6', @IdProgram = 44, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='99089',@Name='ETUDE CLAPET MAL/DAR ESSENCE', @IdProgram = 345, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='99090',@Name='CLAPET ELECTR MAL/DAR ESS. CAN.', @IdProgram = 386, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='99100',@Name='RESERVOIR A CARBURANT MICRA NISSAN JAPON', @IdProgram = 44, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='99115',@Name='TUBULURE DE REMPLISSAGE T1N-VERS.US', @IdProgram = 310, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='99116',@Name='SA ASIA - PRESTATION SUPPORT HORS PROJET', @IdProgram = 253, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='99124',@Name='CLAPET MEMBRANE CMD DIESEL X65', @IdProgram = 49, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='99127',@Name='CLAPET CRSMF', @IdProgram = 234, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='99133',@Name='CIRCUIT A CARBURANT T1 BRESIL T1/206', @IdProgram = 283, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='99136',@Name='ADMISSION AIR A806', @IdProgram = 326, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='99137',@Name='RESERVOIR A CARBURANT 35L SMART', @IdProgram = 50, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='99150',@Name='RESERVOIR + TUBULURE DACIA NOVA1', @IdProgram = 125, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='999998',@Name='Mazda 6', @IdProgram = 78, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='A050004',@Name='Assistance Oppama', @IdProgram = 59, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A050005',@Name='Assistance Kitakyushu', @IdProgram = 62, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060000',@Name='Technical assistance - Budget', @IdProgram = 387, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060001',@Name='suppr VIGO IR THERMOGRAPHS FOR N68', @IdProgram = 352, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060002',@Name='VIG - B58 Air ducts test', @IdProgram = 137, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060003',@Name='KOR - Purchasing of 5 resin boxes', @IdProgram = 144, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060004',@Name='JPN - SMED Equipment for JSW', @IdProgram = 311, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060005',@Name='KOR - Inerfill implement. for Hyundai', @IdProgram = 133, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060006',@Name='SLO - Head tooling design on BM3', @IdProgram = 39, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060007',@Name='HER - Mini-shed test on 2 T1 fuel', @IdProgram = 310, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060008',@Name='CUR - 6 weeks assistance M Griot', @IdProgram = 191, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060009',@Name='COM - Délégation Services Techniques', @IdProgram = 252, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060010',@Name='LAV - Délégation Services Techniques', @IdProgram = 306, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060011',@Name='COM - Essai labo pièces série', @IdProgram = 325, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060012',@Name='ROM - Laboratory tests', @IdProgram = 260, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060013',@Name='POI - Essai labo pièces série', @IdProgram = 61, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060014',@Name='SAN - Essai labo pièces série', @IdProgram = 330, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060015',@Name='LAV - Essai labo pièces série', @IdProgram = 189, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060016',@Name='NUC - Essai labo pièces série', @IdProgram = 48, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060017',@Name='PFA - Essai labo pièces séries', @IdProgram = 37, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060018',@Name='COV - Laboratory tests', @IdProgram = 343, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060019',@Name='RST - Essai labo pièces série', @IdProgram = 415, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060020',@Name='KOR - TAF LST05/006', @IdProgram = 275, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060021',@Name='NAO - DYNAMIC EVAP TEST', @IdProgram = 76, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060022',@Name='VIG - Laboratory tests', @IdProgram = 272, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060023',@Name='VAL - Laboratory tests', @IdProgram = 168, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060024',@Name='CUR - Laboratory tests', @IdProgram = 190, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060025',@Name='LUB - Laboratory tests', @IdProgram = 290, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060026',@Name='RAY - technical assist. L.Cassarin', @IdProgram = 21, @IsActive = 0, @IdProjectType = 4
exec catInsertProject @Code ='A060027',@Name='Delphi - Test on 2 fuel E83 FS', @IdProgram = 319, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A060028',@Name='KYO - Training Inergy University', @IdProgram = 292, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A060029',@Name='EIS - Support fluo in line X4400', @IdProgram = 118, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A060030',@Name='NOH - Blow pin module adaptation', @IdProgram = 103, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A060031',@Name='LAV - Remplacement cariste Logistique CT', @IdProgram = 340, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A060032',@Name='JPN - Transfert head tooling', @IdProgram = 204, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A060033',@Name='COM - Formation', @IdProgram = 231, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A060034',@Name='VIG - Assistance B58', @IdProgram = 211, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A060035',@Name='Prestations J Covet SAC pour Qual', @IdProgram = 199, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A060037',@Name='NAO - Dynamic Evap Test 2', @IdProgram = 209, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A060038',@Name='HOR - Essai labo pièces série', @IdProgram = 56, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A060039',@Name='LAV Fluo in-line D2', @IdProgram = 59, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A060040',@Name='KYU Technical support (Process+RDF)', @IdProgram = 182, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A060041',@Name='Assist. métro/usine (bras Faro+logiciel)', @IdProgram = 309, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A060042',@Name='JPN - Technical support (Process+RDF)', @IdProgram = 99, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A060043',@Name='KYU - PV cycling bench', @IdProgram = 119, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A060044',@Name='LAV - HSE', @IdProgram = 177, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A060046',@Name='COM - Assist. Process/usine', @IdProgram = 414, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A060047',@Name='LAV - Adapt nlles étiquettes code barre', @IdProgram = 43, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A060048',@Name='ARG - 2 mini-shed tests', @IdProgram = 147, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A060052',@Name='NUC - X74 TP 27 HS', @IdProgram = 116, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A060053',@Name='Adrian - Back-up program Shenzhen', @IdProgram = 353, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A061001',@Name='VIG - General support to plastic', @IdProgram = 250, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A061003',@Name='VIG - General support to Air Duct', @IdProgram = 329, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A061004',@Name='ARE - General support', @IdProgram = 174, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A062001',@Name='General support to Kitakyushu', @IdProgram = 270, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A062002',@Name='General support to Oppama', @IdProgram = 381, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A062003',@Name='Cold roll', @IdProgram = 257, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A062005',@Name='Production transfer', @IdProgram = 120, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A062006',@Name='Unchangeable implementation', @IdProgram = 193, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A062007',@Name='OPP - Dasip implementation', @IdProgram = 313, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A062008',@Name='KYU - Dasip implementation', @IdProgram = 267, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A41749',@Name='GRE - Assistance site', @IdProgram = 390, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A51749',@Name='LAV - Assistance site', @IdProgram = 67, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A61749',@Name='NUC - Assistance site', @IdProgram = 376, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='A71749',@Name='PFA - Assistance site', @IdProgram = 51, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='AA00',@Name='AAAA_MYPROJ', @IdProgram = 303, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='AAA000',@Name='AAAA_Test', @IdProgram = 21, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='B2E',@Name='MAZ B2E', @IdProgram = 230, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C000010',@Name='VIG Metal PCA', @IdProgram = 402, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C000020',@Name='VIG Metal PO', @IdProgram = 59, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C000030',@Name='VIG Metal DCX', @IdProgram = 26, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C000040',@Name='VIG Metal Inergy', @IdProgram = 391, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C000050',@Name='VIG Metal others', @IdProgram = 187, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C000060',@Name='VIG Air Duct Trety', @IdProgram = 221, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C000170',@Name='RSA J77', @IdProgram = 153, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C000171',@Name='REN J77 Valladolid', @IdProgram = 359, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C000172',@Name='REN J77 Arevalo', @IdProgram = 237, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C000173',@Name='REN J77 Vigo', @IdProgram = 236, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C001010',@Name='MER W169 - Mercedes', @IdProgram = 31, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C001060',@Name='PCA M49/N68', @IdProgram = 232, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C001061',@Name='PSA N68 China', @IdProgram = 12, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C009770',@Name='NIS ZW', @IdProgram = 364, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C009780',@Name='DAE M200', @IdProgram = 34, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C009790',@Name='NIS Bluebird', @IdProgram = 5, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C009800',@Name='FOR C170 - Rusia', @IdProgram = 384, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C009810',@Name='FOR B 325', @IdProgram = 30, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C009820',@Name='FIA CMPV', @IdProgram = 328, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C009830',@Name='FIA Premium', @IdProgram = 282, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C009840',@Name='HMC LD Dom', @IdProgram = 324, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C009850',@Name='RSM SM3', @IdProgram = 320, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C009860',@Name='DC CS 03,5', @IdProgram = 228, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C009870',@Name='BMW E85 Lev II NG', @IdProgram = 318, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C009880',@Name='DC TJ 03', @IdProgram = 431, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C009890',@Name='NIS TT', @IdProgram = 209, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C009900',@Name='DC ZB', @IdProgram = 88, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C009910',@Name='DC RS 03/04', @IdProgram = 335, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C009920',@Name='DC JR', @IdProgram = 56, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C009930',@Name='DC AN', @IdProgram = 135, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C009950',@Name='GMN GMT 830 / 805', @IdProgram = 18, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C009960',@Name='VW_ PQ 24 Europe', @IdProgram = 331, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C009961',@Name='VW_ PQ 24 BRI', @IdProgram = 158, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C009980',@Name='NIS JATQ domestic', @IdProgram = 366, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C009981',@Name='NIS JATQ China', @IdProgram = 372, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C009982',@Name='NIS JATQ - Mason Jar', @IdProgram = 4, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C009990',@Name='NIS MM/YY', @IdProgram = 38, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C010060',@Name='PCA A31 (A8) generic', @IdProgram = 436, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C010061',@Name='PCA A31 (A8) France', @IdProgram = 146, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C010130',@Name='GMW NCV2 Valladolid', @IdProgram = 314, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C010131',@Name='GMW NCV2 Vigo', @IdProgram = 288, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C010132',@Name='GMW NCV2 Buenos Aires', @IdProgram = 227, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C010210',@Name='PSA D2Z - USA', @IdProgram = 389, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C010260',@Name='REN B85 FS GENERIC', @IdProgram = 145, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C010261',@Name='REN B85 FT LAVAL', @IdProgram = 1, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C010262',@Name='REN B85 FT NUCOURT', @IdProgram = 145, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C010263',@Name='REN B85 FT BURSA', @IdProgram = 33, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C010264',@Name='REN B85 FP VIGO', @IdProgram = 369, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C010265',@Name='REN B85 FP SPORT', @IdProgram = 360, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C010266',@Name='REN B85 FT VAL', @IdProgram = 210, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C010300',@Name='PCA A08 Generic', @IdProgram = 64, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C010302',@Name='PCA A08 Achere', @IdProgram = 83, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C010410',@Name='RSA X70 - Phase 2', @IdProgram = 121, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C010450',@Name='PSA B0', @IdProgram = 58, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C010460',@Name='REN X83 Telford', @IdProgram = 58, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C010461',@Name='REN X83 Arevalo', @IdProgram = 324, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C010462',@Name='REN X83 Vigo', @IdProgram = 319, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C010550',@Name='PRO SCM + GMX', @IdProgram = 155, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C010560',@Name='RSA X76 - 4x4', @IdProgram = 256, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C010561',@Name='REN X76 BUE', @IdProgram = 283, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C010640',@Name='PSA  B5', @IdProgram = 220, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C010641',@Name='PCA B53 CHINE', @IdProgram = 68, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C010642',@Name='B53 ARGENTINE', @IdProgram = 340, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C019820',@Name='HMC MR', @IdProgram = 209, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C019830',@Name='VW_ PQ 46', @IdProgram = 195, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C019840',@Name='DC KJ 04', @IdProgram = 337, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C019850',@Name='HMC HR', @IdProgram = 162, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C019860',@Name='DAE J200 Dom', @IdProgram = 435, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C019870',@Name='HMC SA', @IdProgram = 186, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C019880',@Name='MER WG', @IdProgram = 357, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C019890',@Name='DC PG', @IdProgram = 232, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C019900',@Name='NIS ZR - Canada', @IdProgram = 125, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C019910',@Name='VW_ B5 Additive', @IdProgram = 382, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C019920',@Name='TOY IMV generic', @IdProgram = 394, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C019921',@Name='TOY IMV Rayong', @IdProgram = 428, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C019924',@Name='TOY IMV Buenos Aires', @IdProgram = 234, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C019926',@Name='TOY IMV Brits', @IdProgram = 410, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C019930',@Name='DC HB 04/05', @IdProgram = 85, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C019940',@Name='VW_ PQ 35 HER', @IdProgram = 417, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C019941',@Name='VW_ PQ 35 BRI', @IdProgram = 329, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C019942',@Name='VW_ PQ 35 LOZ', @IdProgram = 277, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C019950',@Name='MER NCV2 - Nafta', @IdProgram = 88, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C019960',@Name='GMN GMT 345', @IdProgram = 301, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C019970',@Name='DAE T200 Dom', @IdProgram = 82, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C019981',@Name='BMW E88', @IdProgram = 23, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C019982',@Name='BMW E92/E93', @IdProgram = 85, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C019983',@Name='BMW E9X - China', @IdProgram = 59, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C019984',@Name='BMW PL2 BRI', @IdProgram = 180, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C019990',@Name='POR C2 / C4', @IdProgram = 151, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C020200',@Name='PCA A7 Generic', @IdProgram = 268, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C020201',@Name='PCA A7 Nucourt', @IdProgram = 249, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C020202',@Name='PCA A7 Arevalo', @IdProgram = 96, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C020203',@Name='PCA A7 Lublin', @IdProgram = 167, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C020204',@Name='PCA A7 Trnava', @IdProgram = 16, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C020205',@Name='PCA A7 Curitiba', @IdProgram = 272, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C020320',@Name='PSA Z8/Z9', @IdProgram = 141, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C021000',@Name='HMC NF', @IdProgram = 59, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C021001',@Name='HMC NF Nao (cap. increase)', @IdProgram = 88, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C021010',@Name='DAE D100 (SUV)', @IdProgram = 301, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C021020',@Name='DC C-segment', @IdProgram = 135, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C021030',@Name='GMN GMT 201', @IdProgram = 131, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C021040',@Name='GMN GMX 215/245', @IdProgram = 132, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C021050',@Name='GMW A3300', @IdProgram = 91, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C021060',@Name='GMW A3370', @IdProgram = 130, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C021070',@Name='HMC TC&MC Nafta', @IdProgram = 308, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C021071',@Name='HMC TC&MC Domestic', @IdProgram = 337, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C021080',@Name='MER NCV3 - Nafta', @IdProgram = 91, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C021081',@Name='MER NCV3 - Row', @IdProgram = 94, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C021090',@Name='RSM EX generic', @IdProgram = 399, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C021100',@Name='SUZ YN2 - NCC', @IdProgram = 15, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C029680',@Name='GMW X4400', @IdProgram = 234, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C029690',@Name='GMW Celta II', @IdProgram = 213, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C029700',@Name='FOR CD3XX', @IdProgram = 277, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C029710',@Name='NIS Platform C (US)', @IdProgram = 229, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C029720',@Name='NIS Platform C (UK)', @IdProgram = 137, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C029730',@Name='GMN GMX 222 / 272', @IdProgram = 298, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C029740',@Name='FIA 199', @IdProgram = 423, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C029750',@Name='FOR D 310', @IdProgram = 133, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C029760',@Name='MIT MMC truck (CR)', @IdProgram = 312, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C029770',@Name='MIT C-segment', @IdProgram = 269, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C029780',@Name='SUZ Escudo', @IdProgram = 99, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C029790',@Name='MIT Z-car Japan 2WD', @IdProgram = 122, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C029800',@Name='DAE V200 Lev2', @IdProgram = 356, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C029810',@Name='DAE U200 Lev2', @IdProgram = 159, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C029820',@Name='NIS X61B QW', @IdProgram = 308, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C029840',@Name='FOR P131', @IdProgram = 118, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C029850',@Name='GMN GMT 360/370', @IdProgram = 325, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C029860',@Name='DC ND', @IdProgram = 258, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C029870',@Name='FOR C1', @IdProgram = 368, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C029880',@Name='DC PT Cruiser', @IdProgram = 129, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C029890',@Name='DC RS 05', @IdProgram = 107, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C029900',@Name='DC LX 04/05', @IdProgram = 168, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C029910',@Name='PSA T5X', @IdProgram = 379, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C029920',@Name='HMC CT Pregio F/L', @IdProgram = 411, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C029930',@Name='SUZ MR Wagon (Moco)', @IdProgram = 339, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C029940',@Name='GMN GMX 380', @IdProgram = 389, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C029950',@Name='FOR IKON', @IdProgram = 25, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C029960',@Name='DC RG', @IdProgram = 289, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C029970',@Name='NIS TK & XXUL', @IdProgram = 93, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C029980',@Name='NIS B30 (J32B-C Platform)', @IdProgram = 38, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C029990',@Name='SSY A-100', @IdProgram = 85, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C030010',@Name='AUDI PIKES PEAK PL71', @IdProgram = 160, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C030050',@Name='ROV RDX 60', @IdProgram = 270, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C030070',@Name='PSA X3/X4', @IdProgram = 155, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C030100',@Name='RSA X44', @IdProgram = 296, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C030110',@Name='AUD X61', @IdProgram = 276, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C030130',@Name='PSA G9 Generic', @IdProgram = 100, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C030210',@Name='SUZUKI NBC', @IdProgram = 369, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C030220',@Name='POR 997 Turbo', @IdProgram = 316, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C030250',@Name='E9X motorsport', @IdProgram = 46, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C030260',@Name='GM X4400', @IdProgram = 108, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C031020',@Name='PCA B58 Vigo', @IdProgram = 266, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C031021',@Name='PCA B9 Vigo', @IdProgram = 374, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C031030',@Name='BMW PL4 - E70', @IdProgram = 66, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C031040',@Name='BMW R56/R57', @IdProgram = 133, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C031041',@Name='BMW R56', @IdProgram = 10, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C031050',@Name='LDV BD 100', @IdProgram = 210, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C031060',@Name='DAE V231', @IdProgram = 180, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C031070',@Name='AUD D219 - D258', @IdProgram = 32, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C031080',@Name='FOR V34X', @IdProgram = 359, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C031090',@Name='HMC CM Nao', @IdProgram = 128, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C031100',@Name='MAZ J56', @IdProgram = 283, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C031110',@Name='DC RT 07', @IdProgram = 326, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C039810',@Name='AUD BR 204/207', @IdProgram = 267, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C039820',@Name='HON XF', @IdProgram = 89, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C039830',@Name='MAZ C-4WD', @IdProgram = 94, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C039840',@Name='VW_ PQ 35', @IdProgram = 146, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C039850',@Name='AUD D-Platform (UK) - W39', @IdProgram = 352, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C039860',@Name='GMN Lambda', @IdProgram = 219, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C039870',@Name='FIA Ducato', @IdProgram = 36, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C039880',@Name='DC JS', @IdProgram = 31, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C039890',@Name='GMN GMX 020', @IdProgram = 196, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C039900',@Name='MCC W456', @IdProgram = 156, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C039910',@Name='NIS J32J', @IdProgram = 228, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C039920',@Name='MIT SQ', @IdProgram = 306, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C039930',@Name='TOY Yaris', @IdProgram = 178, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C039940',@Name='GMN Delta - GMX 357', @IdProgram = 135, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C039950',@Name='HMC TG', @IdProgram = 57, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C039970',@Name='SSY D-100', @IdProgram = 279, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C039990',@Name='VOL EUCD', @IdProgram = 375, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C040010',@Name='MAZDA B2e', @IdProgram = 334, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C040020',@Name='REN X91', @IdProgram = 261, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C040021',@Name='REN X91 FT Nucourt', @IdProgram = 215, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C040022',@Name='REN X91 FT Laval', @IdProgram = 27, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C040023',@Name='REN D91 FP', @IdProgram = 50, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C040041',@Name='PSA T1  - China', @IdProgram = 197, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C040042',@Name='PSA T1  - Iran', @IdProgram = 372, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C040050',@Name='RSA X70 - Phase 1 Mercosur', @IdProgram = 361, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C040090',@Name='Renault Sport Buggy - Generic', @IdProgram = 386, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C041010',@Name='MCC BR451 ECE', @IdProgram = 390, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041011',@Name='MCC BR451 Lev II', @IdProgram = 203, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C041020',@Name='Audi C1', @IdProgram = 72, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C041030',@Name='SUZ NATC generic', @IdProgram = 302, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C041040',@Name='MAZ J61X - CD 2WD', @IdProgram = 230, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C041050',@Name='TOY 130L SAF', @IdProgram = 56, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C041070',@Name='Honda CRV Europe', @IdProgram = 394, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C041080',@Name='AUD P32K', @IdProgram = 226, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041110',@Name='DC KK 07 - KA', @IdProgram = 184, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041120',@Name='DC JK 07', @IdProgram = 154, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041130',@Name='DC DR / DH', @IdProgram = 56, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041140',@Name='GMN GMT 836 Cab Chassis', @IdProgram = 91, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041150',@Name='PL 48 Generic', @IdProgram = 350, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041160',@Name='NIS X61 B', @IdProgram = 414, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041170',@Name='KIA ED Generic', @IdProgram = 339, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041180',@Name='PSA X7 Generic', @IdProgram = 163, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041190',@Name='PSA T7 generic', @IdProgram = 359, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041191',@Name='PSA T72', @IdProgram = 32, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041192',@Name='PSA T76', @IdProgram = 283, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041200',@Name='VW PQ Mix Generic', @IdProgram = 199, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041210',@Name='AUD JS - PZEV', @IdProgram = 99, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041220',@Name='NIS P32M', @IdProgram = 218, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041230',@Name='NIS X11C Coex', @IdProgram = 171, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041240',@Name='HMC HD - XD Platform', @IdProgram = 295, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041260',@Name='SUZ Wagon R - Opel Agila', @IdProgram = 157, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041270',@Name='T7-X7 - Additional FAP Gen 4', @IdProgram = 365, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041280',@Name='DC DC/DM   07/08', @IdProgram = 210, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041300',@Name='AUD GMT 361/371', @IdProgram = 74, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041310',@Name='AUD GMX 322 (Sigma repl.)', @IdProgram = 85, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041320',@Name='TOY Yaris Thailand', @IdProgram = 86, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041330',@Name='AUD JC 49', @IdProgram = 82, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041340',@Name='NIS L42A PZEV', @IdProgram = 28, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041341',@Name='NIS L42 Lev 2', @IdProgram = 181, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041342',@Name='NIS L42A LWB Lev II', @IdProgram = 412, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041350',@Name='GMN GMT 930 (830 Repl.)', @IdProgram = 96, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041360',@Name='GMN GMT 920 (820 Repl.)', @IdProgram = 25, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041370',@Name='GMN GMX 365 & 222 PZEV', @IdProgram = 368, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C041380',@Name='DAE C100 generic', @IdProgram = 428, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C041390',@Name='GMN GMT 355 Lev II', @IdProgram = 253, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C041400',@Name='HMC MG (Nafta & Domestic)', @IdProgram = 80, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C041410',@Name='GMN GMT 800 (SS Box)', @IdProgram = 415, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C041411',@Name='GMN GMT 800 (26 & 34)', @IdProgram = 370, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C041420',@Name='AUD W42E - D-Platform', @IdProgram = 64, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C041430',@Name='HMC CM Dom', @IdProgram = 16, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C041440',@Name='NIS X11C MEX generic', @IdProgram = 25, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041470',@Name='Opel Meriva/Montana Generic', @IdProgram = 380, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C041480',@Name='Corsa/Celta Brazil Generic', @IdProgram = 188, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C041490',@Name='AUD GMX 280 - Zeta Platform', @IdProgram = 95, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041500',@Name='GMN GMT 900 (26 Gallons)', @IdProgram = 71, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041510',@Name='K72 Generic', @IdProgram = 231, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041520',@Name='P32L', @IdProgram = 179, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C041530',@Name='NIS X11C SAF generic', @IdProgram = 175, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041531',@Name='NIS X11C Mono Rayong', @IdProgram = 277, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041532',@Name='NIS X11C Mono - Brits', @IdProgram = 279, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041533',@Name='NIS X11C Mexico', @IdProgram = 110, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041550',@Name='HMC TQ', @IdProgram = 149, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041580',@Name='HON CRV', @IdProgram = 283, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041590',@Name='NIS P32K generic', @IdProgram = 351, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041600',@Name='NIS W42D generic', @IdProgram = 299, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C041610',@Name='MAS M139', @IdProgram = 293, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C041620',@Name='DC Actros - Urea - HDV', @IdProgram = 292, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C041630',@Name='AUD G-100', @IdProgram = 234, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C049860',@Name='AUD C2 / C4', @IdProgram = 217, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C049870',@Name='AUD PQ25', @IdProgram = 332, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C049880',@Name='AUD W car & 222', @IdProgram = 62, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C049890',@Name='AUD GMX 282 & VE', @IdProgram = 305, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C049910',@Name='SUZ YS7 - (AA)', @IdProgram = 408, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C049920',@Name='SUZ YS6 - (AA)', @IdProgram = 109, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C049930',@Name='HON MD2', @IdProgram = 225, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C049940',@Name='FOR U222', @IdProgram = 219, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C049950',@Name='VW_ PQ25', @IdProgram = 281, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C049960',@Name='TOY 800x', @IdProgram = 379, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C049970',@Name='HMC UN', @IdProgram = 223, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C049980',@Name='GMW A3300 - Brazil', @IdProgram = 297, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C049990',@Name='NIS J32B', @IdProgram = 206, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051000',@Name='NIS W12A generic', @IdProgram = 435, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051010',@Name=' AUD AU416 generic', @IdProgram = 337, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051021',@Name='GM Epsilon Front Wheel Drive', @IdProgram = 4, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051022',@Name='GM Epsilon All Wheel Drive', @IdProgram = 291, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051023',@Name='GM Epsilon PZEV', @IdProgram = 245, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051030',@Name='SUZ YP0', @IdProgram = 72, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051050',@Name='GMN GMT 319', @IdProgram = 386, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051051',@Name='GMN GMT 319 PZEV', @IdProgram = 46, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051060',@Name='SUZ YN3 domestic', @IdProgram = 393, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C051070',@Name='MER BR212', @IdProgram = 14, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051080',@Name='REN W62 generic', @IdProgram = 178, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C051090',@Name='AUD ZW - LWB', @IdProgram = 304, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C051100',@Name='GMN GMT 001', @IdProgram = 98, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051110',@Name='GMN GMT 610', @IdProgram = 208, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051120',@Name='MER X204', @IdProgram = 231, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C051130',@Name='AUD BR 204 - Sth Africa TI', @IdProgram = 98, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051140',@Name='BMW K25 Motorbike', @IdProgram = 203, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051150',@Name='DC NCV3 Argentina', @IdProgram = 302, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051160',@Name='RSA W95', @IdProgram = 156, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051180',@Name='GMW X3500 (Epsilon) FP', @IdProgram = 426, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051190',@Name='SUZ YD2', @IdProgram = 389, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051200',@Name='DCW LE', @IdProgram = 408, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051210',@Name='MIT I3-I4', @IdProgram = 5, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C051220',@Name='TOY IMV - SWB 80L', @IdProgram = 257, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C051230',@Name='NIS W02A', @IdProgram = 317, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C051240',@Name='DC LCV', @IdProgram = 160, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051250',@Name='NIS L42F', @IdProgram = 428, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051260',@Name='SUZ ATV Tank homologation', @IdProgram = 405, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C051270',@Name='SUZ ATV Smac', @IdProgram = 421, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051280',@Name='SUZ Tank A', @IdProgram = 171, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051290',@Name='HON Accord', @IdProgram = 239, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051300',@Name='VW_ VW249', @IdProgram = 365, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051320',@Name='GMN Epsilon 1 PZEV', @IdProgram = 125, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051360',@Name='POR Panamera 970', @IdProgram = 149, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051370',@Name='DC CT09', @IdProgram = 391, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051380',@Name='GMN GMT 511', @IdProgram = 52, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051390',@Name='GMN GM Theta Epsilon', @IdProgram = 154, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051400',@Name='PSA A58', @IdProgram = 252, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051410',@Name='BMW X3', @IdProgram = 242, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051420',@Name='BMW E89', @IdProgram = 44, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051430',@Name='MER BR 212 Urea', @IdProgram = 6, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051440',@Name='GMW T3600 (Delta)', @IdProgram = 94, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051450',@Name='TOY 681X', @IdProgram = 201, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051460',@Name='PSA A51', @IdProgram = 91, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051470',@Name='PSA T3', @IdProgram = 423, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051480',@Name='RSA X93', @IdProgram = 25, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051490',@Name='FOR Galaxy', @IdProgram = 397, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051500',@Name='NIS P32 E/L', @IdProgram = 266, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051510',@Name='NIS X11M', @IdProgram = 56, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C051520',@Name='RSA R77', @IdProgram = 166, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C051530',@Name='BMW E88 Pzev', @IdProgram = 338, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C051540',@Name='PSA T8', @IdProgram = 234, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C051550',@Name='PSA W31', @IdProgram = 204, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C051560',@Name='VW_ PQ46 China', @IdProgram = 104, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051570',@Name='VW_ AU5XX', @IdProgram = 434, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051580',@Name='VW_ D4 (AUD A8)', @IdProgram = 120, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C051590',@Name='VW_ D4 (A SUV)', @IdProgram = 357, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C051600',@Name='NIS New Cube', @IdProgram = 158, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C051610',@Name='SUZ Tank B', @IdProgram = 155, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C051620',@Name='DAE V300', @IdProgram = 241, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C051630',@Name='HMC PO', @IdProgram = 273, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051660',@Name='PSA W2Z', @IdProgram = 378, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051670',@Name='HMC AM', @IdProgram = 285, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051680',@Name='SUZ ATV LT6', @IdProgram = 314, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C051691',@Name='VW_ SCR Urea PQ35 NAR', @IdProgram = 36, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C051692',@Name='VW_ SCR Urea PQ35 EUR', @IdProgram = 37, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C051693',@Name='VW_ SCR Urea Colorado', @IdProgram = 374, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C051694',@Name='VW_ SCR Urea PL71', @IdProgram = 47, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C060010',@Name='GMN GMX 222 generic', @IdProgram = 320, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C060020',@Name='GMN GMX 365 generic', @IdProgram = 233, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C060030',@Name='GMW NCV3 & NCV2 CHI generic', @IdProgram = 362, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C060050',@Name='ISU I190 repl generic', @IdProgram = 227, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C060060',@Name='VW_ 817 RPU', @IdProgram = 40, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C060071',@Name='RSM LP1 FP', @IdProgram = 340, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C060080',@Name='NIS J42G UL Lev2 generic', @IdProgram = 208, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C060090',@Name='NIS K11 repl generic', @IdProgram = 46, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C060100',@Name='GMW S4200 ARG generic', @IdProgram = 216, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C060110',@Name='GMW S10 Brazil', @IdProgram = 155, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C060120',@Name='TOY 445L generic', @IdProgram = 167, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C060130',@Name='SYM Y300 generic', @IdProgram = 193, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C060140',@Name='Haitec NV1 generic', @IdProgram = 125, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C060150',@Name='DC HB HEV/PZEV generic', @IdProgram = 358, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C060160',@Name='Daihatsu Car', @IdProgram = 249, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C750010',@Name='PSA S90', @IdProgram = 171, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C800010',@Name='PSA M24', @IdProgram = 26, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C810010',@Name='PSA VDU', @IdProgram = 84, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C840010',@Name='PSA ZA', @IdProgram = 181, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C891130',@Name='PSA S8', @IdProgram = 392, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C891680',@Name='PSA X1', @IdProgram = 231, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C900010',@Name='PSA N2', @IdProgram = 222, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C901680',@Name='MER T1N Filler Pipe', @IdProgram = 205, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C910400',@Name='PCA N3', @IdProgram = 39, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C920631',@Name='REN X65 LUB', @IdProgram = 144, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C920632',@Name='REN X65 TUR', @IdProgram = 341, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C920633',@Name='REN X65 Mercosur', @IdProgram = 96, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C920634',@Name='REN X65 Flex fuel Mercosur', @IdProgram = 59, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C920635',@Name='REN X65 RAM', @IdProgram = 123, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C920636',@Name='REN X65 FP LAV', @IdProgram = 76, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C920637',@Name='REN X65 FP Mercosur', @IdProgram = 236, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C920790',@Name='REN F40 Valladolid', @IdProgram = 158, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C929990',@Name='RSA X57', @IdProgram = 321, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C940730',@Name='PSA T1 Europe Generic', @IdProgram = 22, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C940731',@Name='PSA T1 PFA', @IdProgram = 405, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C940732',@Name='PSA T1 TEL', @IdProgram = 190, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C940733',@Name='PSA T1 NUC', @IdProgram = 409, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C940734',@Name='PSA T1 LAV', @IdProgram = 95, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C941320',@Name='RSA M2S Platform - X74', @IdProgram = 200, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C949970',@Name='DC T0', @IdProgram = 101, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C949980',@Name='VW_ S03 Arevalo', @IdProgram = 163, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C949981',@Name='VW_ S03 Vigo', @IdProgram = 390, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C949990',@Name='PSA SAMAND', @IdProgram = 378, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C959990',@Name='HMC A-1', @IdProgram = 292, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C960670',@Name='PSA X2', @IdProgram = 68, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C961581',@Name='REN X64 BUE', @IdProgram = 341, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C962190',@Name='PSA T6 (T5)', @IdProgram = 238, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C962191',@Name='PSA T5 - Argentina', @IdProgram = 354, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C969990',@Name='GMW T3000', @IdProgram = 349, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C971080',@Name='RSA M2S Platform - X73', @IdProgram = 99, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C979980',@Name='HMC LC', @IdProgram = 247, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C979990',@Name='NIS U13', @IdProgram = 397, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C980180',@Name='RSA M2S Platform - X81', @IdProgram = 333, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C980700',@Name='REN X84 Generic', @IdProgram = 80, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C980701',@Name='REN X84 Curitiba', @IdProgram = 100, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C980702',@Name='REN X84 Compiegne', @IdProgram = 422, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C980703',@Name='REN X84 Arevalo', @IdProgram = 229, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C980704',@Name='REN X84 Bursa', @IdProgram = 325, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C980705',@Name='REN X84 Vigo', @IdProgram = 105, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C981010',@Name='PSA V', @IdProgram = 377, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C989920',@Name='BMW E53', @IdProgram = 388, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C989930',@Name='HMC XD', @IdProgram = 186, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C989931',@Name='HMC GK', @IdProgram = 266, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C989940',@Name='NIS H21', @IdProgram = 274, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C989950',@Name='GMN GMX 320', @IdProgram = 159, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C989960',@Name='GMN GMT 200 AWD', @IdProgram = 349, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C989980',@Name='MCC MCC 22 L', @IdProgram = 22, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C989990',@Name='ISU i190 generic', @IdProgram = 80, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C989991',@Name='GMW I190 Soja', @IdProgram = 402, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C990571',@Name='PSA N6/N7', @IdProgram = 114, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C990660',@Name='DAC L90 generic', @IdProgram = 335, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C990661',@Name='DAC L90 diesel', @IdProgram = 264, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C990662',@Name='DAC X90 RF', @IdProgram = 83, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C990663',@Name='DAC L90 selar', @IdProgram = 409, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C990664',@Name='DAC L90 flex fuel', @IdProgram = 180, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C990665',@Name='DAC L90 Russia', @IdProgram = 257, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C990666',@Name='DAC L90 India', @IdProgram = 47, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C990667',@Name='DAC L90 CUR', @IdProgram = 357, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C990668',@Name='DAC B90 PIT', @IdProgram = 31, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C990820',@Name='PSA D2', @IdProgram = 274, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C990830',@Name='PSA X6', @IdProgram = 132, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C991330',@Name='PSA T1/T12 Mercosur', @IdProgram = 390, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C991331',@Name='PSA T1/T12', @IdProgram = 10, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C991332',@Name='PSA T1', @IdProgram = 294, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C999840',@Name='HMC TB', @IdProgram = 331, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C999860',@Name='GMW T 0600', @IdProgram = 36, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C999870',@Name='MCC MCC 35 L', @IdProgram = 201, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C999890',@Name='GMW S4300 CUR', @IdProgram = 291, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C999900',@Name='GMW Epsilon (3200/3210)', @IdProgram = 169, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C999901',@Name='GMW Epsilon cost saving', @IdProgram = 96, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C999910',@Name='RSM SM5', @IdProgram = 274, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C999940',@Name='GMW S0411 ARE', @IdProgram = 329, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C999941',@Name='GMW S4300 EIS', @IdProgram = 422, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='C999980',@Name='DAC W41', @IdProgram = 399, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C999990',@Name='POR Colorado', @IdProgram = 251, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='C999991',@Name='VW_ PL75 additive', @IdProgram = 309, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='CPLA',@Name='NIS CPLA generic', @IdProgram = 171, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='E10',@Name='JPN - 5 Layer EVOH', @IdProgram = 247, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='G100',@Name='SYM G100', @IdProgram = 74, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='GMWH',@Name='GMW H Car', @IdProgram = 323, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='GMWV',@Name='GMW V Car', @IdProgram = 246, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='HA1',@Name='HMC A1', @IdProgram = 265, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='HCM',@Name='HMC CM', @IdProgram = 192, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='HMG',@Name='HMC MG', @IdProgram = 330, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='I000010',@Name='RES Patents', @IdProgram = 321, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I000020',@Name='DEV Tech days', @IdProgram = 60, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I000031',@Name='LAB Synergy', @IdProgram = 392, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='I000033',@Name='VP Synergy', @IdProgram = 188, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='I000034',@Name='P&P-Industrial Synergy', @IdProgram = 271, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='I000035',@Name='SA&A Synergy', @IdProgram = 104, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='I000040',@Name='ISO-TS 16949', @IdProgram = 203, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='I000041',@Name='INPRO-R', @IdProgram = 137, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='I000052',@Name='RES EA Dept Means', @IdProgram = 20, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='I000053',@Name='VP dept Means', @IdProgram = 35, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='I000054',@Name='RES P&P Department Means', @IdProgram = 127, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='I000055',@Name='RES SA&C Dept Means', @IdProgram = 437, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='I000062',@Name='RES EA Exploratory + Techwatch', @IdProgram = 167, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='I000063',@Name='RES VP Exporatory and Techwatch', @IdProgram = 171, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='I000064',@Name='RES P&P Exploratory + Techwatch', @IdProgram = 9, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='I000065',@Name='RES SA&C Exploratory + Techwatch', @IdProgram = 42, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='I030011',@Name='KM Product', @IdProgram = 211, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I030012',@Name='KM Process', @IdProgram = 322, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I030013',@Name='KM Simulation', @IdProgram = 272, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I030014',@Name='KM Material', @IdProgram = 198, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I040011',@Name='Filler Pipe strategy', @IdProgram = 28, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I040012',@Name='Corporate Industrial support', @IdProgram = 355, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I040020',@Name='IMIS', @IdProgram = 290, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I040030',@Name='JPN 5 layer EVOH - E10', @IdProgram = 385, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I040031',@Name='JPN 5 layer EVOH - H154', @IdProgram = 253, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I050010',@Name='Corporate Marketing support', @IdProgram = 275, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I050011',@Name='Marketing Support', @IdProgram = 297, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I050021',@Name='HMC/KIA - Marketing support', @IdProgram = 164, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050022',@Name='HMC/KIA - Innocation day', @IdProgram = 205, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I050031',@Name='RSM - Marketing support', @IdProgram = 130, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I050041',@Name='SYM - Marketing support', @IdProgram = 324, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I050051',@Name='DAE - Marketing support', @IdProgram = 2, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I050060',@Name='INChange 2', @IdProgram = 100, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I050061',@Name='General support to CPO', @IdProgram = 33, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I050063',@Name='INPlan', @IdProgram = 46, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050070',@Name='VAVE Support', @IdProgram = 205, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050080',@Name='VAVE support to Korea', @IdProgram = 307, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050091',@Name='Inchangeables', @IdProgram = 154, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I050092',@Name='Standard PFMEA - Control Plan', @IdProgram = 226, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050100',@Name='Coaching Japan - B2e', @IdProgram = 421, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I050111',@Name='NIS - Marketing support to Japan', @IdProgram = 177, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I050112',@Name='NIS - Marketing support to NAO', @IdProgram = 300, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050113',@Name='NIS - Innovation Day', @IdProgram = 88, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I050121',@Name='SUZ - Marketing support to Japan', @IdProgram = 106, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I050122',@Name='SUZ - Marketing support to Cesa', @IdProgram = 355, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050130',@Name='BMW – Innovation Day', @IdProgram = 190, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I050132',@Name='BMW PPQ5', @IdProgram = 116, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I050140',@Name='TOY - Marketing support', @IdProgram = 80, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I050150',@Name='INGoal general', @IdProgram = 45, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050151',@Name='Costing method definition', @IdProgram = 427, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050160',@Name='HON - Marketing support', @IdProgram = 117, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050170',@Name='JAPN - Business Development', @IdProgram = 65, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050180',@Name='JPN 5 Layer PA Nanocomposite', @IdProgram = 80, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050190',@Name='Audi/VW Innovation day', @IdProgram = 435, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050200',@Name='GMW Innovation day', @IdProgram = 433, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050201',@Name='GMW Marketing support', @IdProgram = 122, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I050210',@Name='PCA Innovation day', @IdProgram = 208, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050211',@Name='PCA Marketing support', @IdProgram = 421, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050212',@Name='PCA PF1 Module productivity', @IdProgram = 257, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050213',@Name='PCA Productivity & Purchases support', @IdProgram = 249, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050220',@Name='RSA Innovation day', @IdProgram = 271, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050221',@Name='RSA Marketing support', @IdProgram = 261, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050222',@Name='RSA Productivity & Purchases support', @IdProgram = 370, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050223',@Name='RSA Spare parts', @IdProgram = 220, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050230',@Name='Inergy University - Module creation', @IdProgram = 180, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I050240',@Name='Valves - Inergy', @IdProgram = 327, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050241',@Name='Valves - External suppliers', @IdProgram = 108, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050250',@Name='SPID 53 follow-up', @IdProgram = 393, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050251',@Name='Raw material evolution', @IdProgram = 416, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I050260',@Name='FRUK Industrial Plan', @IdProgram = 138, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I060010',@Name='HMC SCR', @IdProgram = 407, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I060011',@Name='HMC INSAS', @IdProgram = 63, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I060020',@Name='Global productivity', @IdProgram = 55, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I060021',@Name='Global sourcing Modules', @IdProgram = 180, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I060030',@Name='Low cost sourcing', @IdProgram = 44, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I060031',@Name='Logistic optimization for components', @IdProgram = 281, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I060032',@Name='Supplier panel management', @IdProgram = 390, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I060033',@Name='Support to Asia', @IdProgram = 131, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I060034',@Name='RSA FP fluorination removal', @IdProgram = 65, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I060035',@Name='ICV Procedures support', @IdProgram = 238, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='I060036',@Name='ICV Jig construction', @IdProgram = 32, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I060037',@Name='Assistance Indus Laval par B Gautherin', @IdProgram = 75, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I060038',@Name='Assistance to global raw material', @IdProgram = 147, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I060039',@Name='Pursaving Follow-up', @IdProgram = 31, @IsActive = 1, @IdProjectType = 1
exec catInsertProject @Code ='I060050',@Name='Easybench', @IdProgram = 113, @IsActive = 0, @IdProjectType = 1
exec catInsertProject @Code ='IMV',@Name='TOY IMV', @IdProgram = 191, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='JAChina',@Name='NIS JA CHina', @IdProgram = 386, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='JATQ',@Name='NIS JATQ', @IdProgram = 31, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='K9K',@Name='K9K', @IdProgram = 381, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='KORISO',@Name='Iso', @IdProgram = 280, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='KYU1',@Name='Assistance Kyushu', @IdProgram = 197, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='LAB',@Name='Lab support', @IdProgram = 89, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000010',@Name='Vacation & other absence', @IdProgram = 83, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000021',@Name='Training (received)', @IdProgram = 113, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000022',@Name='Administrative work', @IdProgram = 94, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='N000023',@Name='Intogether', @IdProgram = 410, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000024',@Name='Means maintenance & verification', @IdProgram = 430, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000025',@Name='CAD support & methodology', @IdProgram = 401, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000026',@Name='Expertise jaugeage/déformation', @IdProgram = 335, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000027',@Name='Databases maintenance & verification', @IdProgram = 374, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000028',@Name='Update Laval Lab data acquisition software', @IdProgram = 437, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000029',@Name='Lab NVH & Vibration expertise', @IdProgram = 276, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000030',@Name='Means improvment', @IdProgram = 336, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000031',@Name='Slosh noise study', @IdProgram = 404, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000032',@Name='Lab SHED & durability expertise', @IdProgram = 85, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000034',@Name='Restricted Filling improvment type CLINFILL', @IdProgram = 113, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000035',@Name='Lab car demonstrator', @IdProgram = 234, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000036',@Name='CLINFILL integration on car', @IdProgram = 209, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='N000037',@Name='Mason Jar PAC MAN', @IdProgram = 360, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000038',@Name='Industrial standards', @IdProgram = 42, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000039',@Name='Possibilité de surmoulage', @IdProgram = 45, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='N000040',@Name='Quality system - ISO TS certification', @IdProgram = 426, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000041',@Name='Training (given)', @IdProgram = 419, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000042',@Name='Leasson learned', @IdProgram = 326, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000051',@Name='Component Standardization', @IdProgram = 74, @IsActive = 0, @IdProjectType = 2
exec catInsertProject @Code ='N000053',@Name='Management of normalisation', @IdProgram = 8, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000054',@Name='Caractérisation pistolets + usure', @IdProgram = 203, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000056',@Name='Transfert & Support', @IdProgram = 433, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000057',@Name='Sac expertise (ESD, Refueling...)', @IdProgram = 248, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000058',@Name='SAC Pressurized system', @IdProgram = 171, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000059',@Name='Costing improvment plan', @IdProgram = 416, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000060',@Name='Efficiency Improvement', @IdProgram = 206, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000061',@Name='SAC Alternative material', @IdProgram = 231, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000062',@Name='Costing improvment', @IdProgram = 220, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000063',@Name='Ergonomy standards definition', @IdProgram = 421, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N000064',@Name='5S activity', @IdProgram = 399, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N030020',@Name='Synergies', @IdProgram = 69, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N040010',@Name='Benchmark', @IdProgram = 182, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N060001',@Name='Fuel system innovation misc', @IdProgram = 341, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='N060002',@Name='PCA SCR pre-study', @IdProgram = 332, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='NBC',@Name='SUZ NBC', @IdProgram = 17, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='NUBIRA',@Name='GMW Nubira', @IdProgram = 41, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='OPP3',@Name='Technical Assistance Oppama', @IdProgram = 409, @IsActive = 1, @IdProjectType = 4
exec catInsertProject @Code ='R020010',@Name='RES PZEV TRANSFER', @IdProgram = 99, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R020011',@Name='RES INFILM TRANSFER', @IdProgram = 165, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R020012',@Name='RES PZEV VAVE SYSTEM', @IdProgram = 418, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R020013',@Name='RES PZEV VAVE-SENDER CLOSING SYSTEM', @IdProgram = 325, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R020014',@Name='RES PZEV VAVE - NIPPLES - SNAPIN', @IdProgram = 76, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R020015',@Name='RES PZEV NIPPLE TRANSFER', @IdProgram = 107, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R020016',@Name='RES Evaporative losses - R&R', @IdProgram = 212, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R020017',@Name='RES PZEV VAVE INFILM', @IdProgram = 174, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R030020',@Name='RES INSAS', @IdProgram = 174, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R030030',@Name='RES Industrialisation first elbow fill siml°', @IdProgram = 138, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R030031',@Name='RES Filling Global Simulation', @IdProgram = 106, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R030032',@Name='RES Venting Model', @IdProgram = 409, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R030040',@Name='RES INERFILL', @IdProgram = 256, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R030041',@Name='RES CLINFILL', @IdProgram = 141, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R030042',@Name='RES Hot Filament Welding', @IdProgram = 12, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R030043',@Name='RES Hot Filament Welding Transfer', @IdProgram = 24, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R030044',@Name='RES ESD Solutions', @IdProgram = 238, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R030045',@Name='RES INSEAL', @IdProgram = 70, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R030050',@Name='RES Slosh Noise', @IdProgram = 330, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='R040010',@Name='RES Vaccum plasma barrier deposit', @IdProgram = 420, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='R040011',@Name='RES In/Off line Fluorination Performance', @IdProgram = 355, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='R040020',@Name='RES TSBM', @IdProgram = 215, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='R040021',@Name='RES TSBM Transfer', @IdProgram = 370, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='R040030',@Name='RES Light Weighting hope for PFT', @IdProgram = 343, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='R040040',@Name='RES Canister integration in fill pipe', @IdProgram = 163, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='R040041',@Name='RES Canister hot purge', @IdProgram = 348, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='R040050',@Name='RES INvalve', @IdProgram = 325, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='R040051',@Name='RES INFLVV', @IdProgram = 382, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='R040060',@Name='RES Crash/drop/sled test siml° add on 40°', @IdProgram = 370, @IsActive = 0, @IdProjectType = 3
exec catInsertProject @Code ='R040061',@Name='RES Aging mat law at 60°+ oth mech sim transfer', @IdProgram = 122, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R040062',@Name='RES Vibration and fatigue', @IdProgram = 223, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R040063',@Name='RES Permeation Simulation', @IdProgram = 151, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R040070',@Name='RES New Blow Molding software', @IdProgram = 80, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R040071',@Name='RES Shape Reconstruction', @IdProgram = 166, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R040072',@Name='RES Blow molding Set Up Tool Kit', @IdProgram = 39, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R040080',@Name='RES IFS NAO', @IdProgram = 210, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R040081',@Name='RES IFS Europe', @IdProgram = 369, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R040082',@Name='RES Motionles level sensor', @IdProgram = 23, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R040083',@Name='RES IFDM', @IdProgram = 153, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R040084',@Name='RES New sensors & actuators', @IdProgram = 198, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R040090',@Name='BM Process Control', @IdProgram = 404, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R050010',@Name='RES Layout definition', @IdProgram = 437, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R050020',@Name='RES SCR-UREA', @IdProgram = 50, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R050030',@Name='RES Pump Benches deployement', @IdProgram = 377, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R050031',@Name='RES Durability 2005', @IdProgram = 72, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R050040',@Name='RES Rear Floor module', @IdProgram = 130, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R050041',@Name='Thin tank', @IdProgram = 359, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R050050',@Name='RES Testing center preparation', @IdProgram = 123, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R060042',@Name='NEWFILL', @IdProgram = 331, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='R060081',@Name='INPump', @IdProgram = 347, @IsActive = 1, @IdProjectType = 3
exec catInsertProject @Code ='REX',@Name='RSM EX', @IdProgram = 423, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='SA1',@Name='SYM A100', @IdProgram = 47, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='T30',@Name='NIS T30', @IdProgram = 269, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='THA01',@Name='Thailand Local account for GM Isuzu I190', @IdProgram = 221, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='TRAIN',@Name='Training', @IdProgram = 267, @IsActive = 1, @IdProjectType = 2
exec catInsertProject @Code ='VDO',@Name='VDO workshop 545211', @IdProgram = 61, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='X11C',@Name='NIS W11C generic', @IdProgram = 402, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='X11CTHAI',@Name='NIS X11C Mono generic', @IdProgram = 280, @IsActive = 0, @IdProjectType = 5
exec catInsertProject @Code ='YN2',@Name='SUZ YN2 Generic', @IdProgram = 132, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='ZR',@Name='NIS ZR Canada', @IdProgram = 97, @IsActive = 1, @IdProjectType = 5
exec catInsertProject @Code ='ZZZZZZZ',@Name='Project test', @IdProgram = 300, @IsActive = 1, @IdProjectType = 5
-------------------END OF PROJECTS catalogue------------------------------------



------------------- catalogue------------------------------------------
-------------------END OF  catalogue------------------------------------



------------------- catalogue------------------------------------------
-------------------END OF  catalogue------------------------------------



------------------- catalogue------------------------------------------
-------------------END OF  catalogue------------------------------------



------------------- catalogue------------------------------------------
-------------------END OF  catalogue------------------------------------



------------------- catalogue------------------------------------------
-------------------END OF  catalogue------------------------------------



------------------- catalogue------------------------------------------
-------------------END OF  catalogue------------------------------------
