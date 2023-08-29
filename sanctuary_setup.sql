-- drop table statements
drop table Ticket;
drop table Show;
drop table AnimalProductProcured;
drop table AnimalProduct;
drop table WildAnimal;
drop table DomesticatedAnimal;
drop table Visitor;
drop table SeatBracket;
drop table GiftShop;
drop table Sponsor;
drop table Animals;
drop table PrimaryCarers;
drop table AnimalGenera;
drop table Habitats;

-- create table statements

create table Habitats(
	hname varchar(40) primary key,
	capacity int DEFAULT 0
);
-- grant select privilege on Habitats table for all users
grant select on Habitats to public;

-- insert statements for Habitats

insert into Habitats values ('Lion Pen', 5);
insert into Habitats values ('Zebra Pen', 5);
insert into Habitats values ('Hippo Pen', 5);
insert into Habitats values ('Giraffe Pen', 5);

create table AnimalGenera(
	species varchar(40) primary key,
	genus varchar(40) not null
);
-- grant select privilege on AnimalGenera table for all users
grant select on AnimalGenera to public;

-- insert statements for AnimalGenera

insert into AnimalGenera values ('Lion', 'Panthera');
insert into AnimalGenera values ('Giraffe', 'Giraffa');
insert into AnimalGenera values ('Hippo', 'Hippopotamus');
insert into AnimalGenera values ('Zebra', 'Equus');

create table PrimaryCarers(
	pID int primary key
);
-- grant select privilege on PrimaryCarers table for all users
grant select on PrimaryCarers to public;

-- insert statements for PrimaryCarers

insert into PrimaryCarers values (1000);
insert into PrimaryCarers values (1001);
insert into PrimaryCarers values (1002);
insert into PrimaryCarers values (1003);
insert into PrimaryCarers values (1004);
insert into PrimaryCarers values (1005);
insert into PrimaryCarers values (1006);
insert into PrimaryCarers values (1007);

create table Animals(
	aname varchar(40) not null, 
	species varchar(40),
	habitatName varchar(40) not null,
	primaryCarerID int,
	primary key (aname, species),
	foreign key (habitatName) references Habitats(hname) on delete cascade,
	foreign key (species) references AnimalGenera(species) on delete cascade, 
	foreign key (primaryCarerID) references PrimaryCarers(pID) on delete cascade 
);
-- grant select privilege on animals table for all users
grant select on Animals to public;

-- insert statements for Animals

insert into Animals values ('Alex', 'Lion', 'Lion Pen', 1000);
insert into Animals values ('Marty', 'Zebra', 'Zebra Pen', 1001);
insert into Animals values ('Gloria', 'Hippo', 'Hippo Pen', 1002);
insert into Animals values ('Melman', 'Giraffe', 'Giraffe Pen', 1003);
insert into Animals values ('Timmy', 'Lion', 'Lion Pen', 1000);
insert into Animals values ('Matilda', 'Zebra', 'Zebra Pen', 1001);
insert into Animals values ('Geoffrey', 'Hippo', 'Hippo Pen', 1002);
insert into Animals values ('Rory', 'Giraffe', 'Giraffe Pen', 1003);

create table Sponsor(
	sname varchar(40) primary key,
	amountSponsored int
);
-- grant select privilege on sponsor table for all users
grant select on Sponsor to public;

-- insert statements for Sponsor

insert into Sponsor values ('Timmy Rich', 550);
insert into Sponsor values ('Rachel Richer', 750);
insert into Sponsor values ('Gary Supericher', 1450);
insert into Sponsor values ('Jeffrey Bezos', 50000);

create table GiftShop(
	gname varchar(40) primary key
);
-- grant select privilege on GiftShop table for all users
grant select on GiftShop to public;

-- insert statements for GiftShop

insert into GiftShop values ('Lion Shop');
insert into GiftShop values ('Zebra Shop');
insert into GiftShop values ('Hippo Shop');
insert into GiftShop values ('Giraffe Shop');

create table SeatBracket(
	seatNum int primary key,
	price int
);
-- grant select privilege on SeatBracket table for all users
grant select on SeatBracket to public;

-- insert statements for SeatBrackets

insert into SeatBracket values (10, 100);
insert into SeatBracket values (11, 70);
insert into SeatBracket values (12, 40);
insert into SeatBracket values (13, 20);
insert into SeatBracket values (14, 20);

create table Visitor(
	vID int primary key
);
-- grant select privilege on Visitor table for all users
grant select on Visitor to public;

-- insert statements for Visitor

insert into Visitor values (2000);
insert into Visitor values (2001);
insert into Visitor values (2002);
insert into Visitor values (2003);
insert into Visitor values (2004);

create table WildAnimal(
	wname varchar(40),
	species varchar(40),
	sponsorName varchar(40) not null,
	primary key (wname, species),
	foreign key (wname, species) references Animals(aname, species) on delete cascade,
	foreign key (sponsorName) references Sponsor(sname) on delete cascade
	-- foreign key (species) references AnimalGenus(species) on delete cascade
);
-- grant select privilege on WildAnimal table for all users
grant select on WildAnimal to public;

-- insert statements for WildAnimal

insert into WildAnimal values ('Alex', 'Lion', 'Timmy Rich');
insert into WildAnimal values ('Marty', 'Zebra', 'Rachel Richer');
insert into WildAnimal values ('Gloria', 'Hippo', 'Gary Supericher');
insert into WildAnimal values ('Melman', 'Giraffe', 'Jeffrey Bezos');

create table DomesticatedAnimal(
	dname varchar(40),
	species varchar(40),
	primary key (dname, species),
	foreign key (dname, species) references Animals(aname, species) on delete cascade
	-- foreign key (species) references AnimalGenus(species) on delete cascade
);
-- grant select privilege on DomesticatedAnimal table for all users
grant select on DomesticatedAnimal to public;

-- insert statements for DomesticatedAnimal

insert into DomesticatedAnimal values ('Timmy', 'Lion');
insert into DomesticatedAnimal values ('Matilda', 'Zebra');
insert into DomesticatedAnimal values ('Geoffrey', 'Hippo');
insert into DomesticatedAnimal values ('Rory', 'Giraffe');

create table AnimalProduct(
	animalName varchar(40),
	animalSpecies varchar(40),
	productName varchar(40),
	price int,
	giftShopName varchar(40),
	primary key (animalName, animalSpecies, productName),
	foreign key (animalName, animalSpecies) references DomesticatedAnimal(dname, species) on delete cascade,
	foreign key (giftShopName) references GiftShop(gname) on delete cascade
);
-- grant select privilege on AnimalProduct table for all users
grant select on AnimalProduct to public;

-- insert statements for AnimalProduct

insert into AnimalProduct values ('Timmy', 'Lion', 'Timmy Toy', 10, 'Lion Shop');
insert into AnimalProduct values ('Matilda', 'Zebra', 'Zebra-striped Jacket', 55, 'Zebra Shop');
insert into AnimalProduct values ('Geoffrey', 'Hippo', 'Hippo Dog Toy', 20, 'Hippo Shop');
insert into AnimalProduct values ('Rory', 'Giraffe', 'Giraffe Ruler', 15, 'Giraffe Shop');

create table AnimalProductProcured(
	visitorID int,
	animalName varchar(40),
	animalSpecies varchar(40),
	productName varchar(40),
	primary key (animalName, animalSpecies, productName),
	foreign key (visitorID) references Visitor(vID) on delete cascade,
	foreign key (animalName, animalSpecies, productName) references  AnimalProduct(animalName, animalSpecies, productName) on delete cascade
);
-- grant select privilege on AnimalProductProcured table for all users
grant select on AnimalProductProcured to public;

-- insert statements for AnimalProductProcured

insert into AnimalProductProcured values (2000, 'Timmy', 'Lion', 'Timmy Toy');
insert into AnimalProductProcured values (2001, 'Matilda', 'Zebra', 'Zebra-striped Jacket');
insert into AnimalProductProcured values (2002, 'Geoffrey', 'Hippo', 'Hippo Dog Toy');
insert into AnimalProductProcured values (2003, 'Rory', 'Giraffe', 'Giraffe Ruler');

create table Show(
	sname varchar(50),
	habitatName varchar(40),	
	primary key (sname, habitatName),
	foreign key (habitatName) references Habitats(hname) on delete cascade
);
-- grant select privilege on Show table for all users
grant select on Show to public;

-- insert statements for Show

insert into Show values ('Roar of the Lions', 'Lion Pen');
insert into Show values ('Zebra Race', 'Zebra Pen');
insert into Show values ('Splash Concert', 'Hippo Pen');
insert into Show values ('Sky Ride', 'Giraffe Pen');

create table Ticket(
	ticketID int primary key,
	seatNum int,
	showName varchar(50) not null,
	habitatName varchar(40) not null,
	visitorID int,
	foreign key (seatNum) references SeatBracket(seatNum) on delete cascade,
	foreign key (showName, habitatName) references Show(sname, habitatName) on delete cascade,
	foreign key (visitorID) references Visitor(vID) on delete cascade
);
-- grant select privilege on Ticket table for all users
grant select on Ticket to public;

-- insert statements for Ticket

insert into Ticket values (100, 10, 'Roar of the Lions', 'Lion Pen', 2000);
insert into Ticket values (101, 11, 'Zebra Race', 'Zebra Pen', 2001);
insert into Ticket values (102, 12, 'Splash Concert', 'Hippo Pen', 2002);
insert into Ticket values (103, 13, 'Sky Ride', 'Giraffe Pen', 2003);