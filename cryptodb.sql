create database cryptodb;

---- table 1 (user)
create table User (UserId int auto_increment primary key  , Username varchar(20) not null , Password varchar(20), Email varchar (20) unique  , Created_at datetime , 
Verified_at boolean , Status Boolean , Role varchar(30), Referralcode varchar(50) unique  ,Refer_by int ,foreign key(Refer_by) references User(UserId) ) ;


DELIMITER $$
USE `cryptodb`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `user_AFTER_INSERT` AFTER INSERT ON `user` FOR EACH ROW BEGIN
insert into wallet(user_id)
Values(new.userid);
END$$
DELIMITER ;

-- table 2 (wallet)
create table Wallet (Id int auto_increment primary key ,User_id int , foreign key (User_id) references User(UserId) on update cascade on delete cascade, Available_Balance float , Reserved_Balance float , 
Level_Income float , Referral_Income float , Reward_Income float , ROI_Income float , Status varchar(20));



----- table 3 (packages)
create table Packages (Id int auto_increment primary key ,Package_name varchar(30) unique   ,Amount float , Period datetime , ROI_per_day float , Status boolean);


----- table 4 (user membership)
create table User_Membership (Id int auto_increment primary key , UserId int , foreign key (UserId) references User(UserId) on update cascade on delete cascade, 
PackageId int ,foreign key (PackageId) references Packages(Id) on update cascade on delete cascade, Created_at datetime , Status boolean, ROI_Recevied_date datetime, Next_date datetime);



----- table 5 (ROI income ) 
create table ROI_Income (Id int auto_increment primary key , foreign key (Id) references User_Membership(Id) on update cascade on delete cascade,Date_time datetime , 
ROI_Received float);

DELIMITER $$
USE `cryptodb`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `roi_income_AFTER_INSERT` AFTER INSERT ON `roi_income` FOR EACH ROW BEGIN
insert into wallet(roi_income)
Values(new.roi_received);
END$$
DELIMITER ;



-- table 6 (userreferral)
create table UserReferral (Id int auto_increment primary key , ChildId int , foreign key (ChildId) references User(UserId) on update cascade on delete cascade, 
ParentId int , foreign key (ParentId) references User(UserId) on update cascade on delete cascade, Date_time datetime , Referral_income int);
DELIMITER $$
USE `cryptodb`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `userreferral_AFTER_INSERT` AFTER INSERT ON `userreferral` FOR EACH ROW BEGIN
insert into wallet(referral_income)
Values(new.referral_income);
END$$
DELIMITER ;


-- table 10 (levels)
create table Levels (Id int auto_increment  primary key , Points decimal(10,2));

--- table 7 (levelincome)
create table LevelIncome (Id int primary key , ChildId int ,  foreign key (ChildId) references User(UserId) on update cascade on delete cascade, 
ParentId int , foreign key (ParentId) references User(UserId) on update cascade on delete cascade, Date datetime , Level_Income_Rec varchar(30), 
Level_Id int , foreign key (Level_Id) references Levels(Id) on update cascade on delete cascade);

DELIMITER $$
USE `cryptodb`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `levelincome_AFTER_INSERT` AFTER INSERT ON `levelincome` FOR EACH ROW BEGIN
insert into wallet(level_income)
Values(new.level_income_rec);
END$$
DELIMITER ;

-- table 8 (reward)
create table Reward (Id int auto_increment primary key , Reward_name varchar(50), Reward varchar(50), Business_required varchar(50) , Status boolean);


---- table 9 (user reward )
create table User_Reward (Id int auto_increment primary key , UserId int , foreign key (UserId) references User(UserId) on update cascade on delete cascade, 
RewardId int , foreign key (RewardId) references Reward(Id) on update cascade on delete cascade,Date datetime , Reward_rec varchar(30));

DELIMITER $$
USE `cryptodb`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `user_reward_AFTER_INSERT` AFTER INSERT ON `user_reward` FOR EACH ROW BEGIN
insert into wallet(reward_income)
Values(new.reward_rec);
END$$
DELIMITER ;


-- table 11 (ledger)
create table Ledger (Id int auto_increment primary key , Wallet_Id int , foreign key (Wallet_Id) references Wallet(Id) on update cascade on delete cascade,
Opening_balance float , Closing_balance float , Credit float , Debit float , Type_income varchar(30), Date_time datetime , Status boolean , Amount float , Comment varchar(30));

