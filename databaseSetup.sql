drop table Sponsor;
drop table GiftShop;
drop table PrimaryCarer;
drop table AnimalGenus;
drop table SeatBracket;
drop table Visitor;
drop table Animal;
drop table WildAnimal;
drop table DomesticatedAnimal;
drop table AnimalProduct;
drop table AnimalProductProcured;
drop table Show;
drop table Ticket;
drop table Habitat;

CREATE TABLE Sponsor (
	name char(20) PRIMARY KEY,
	amountSponsored int
);
grant select on Sponsor to public;

INSERT into Sponsor values ('Timmy Rich', 550);
INSERT into Sponsor values ('Rachel Richer', 750);
INSERT into Sponsor values ('Gary Supericher', 1450);
INSERT into Sponsor values ('Melinda Ubericher', 5000);
INSERT into Sponsor values ('Jeffrey Bezos', 50000);

CREATE TABLE GiftShop (
	name char(20) PRIMARY KEY
);
grant select on GiftShop to public;

INSERT into GiftShop values ('Cow Shop');
INSERT into GiftShop values ('Goat Shop');
INSERT into GiftShop values ('Pig Shop');
INSERT into GiftShop values ('Small Chicken Shop');
INSERT into GiftShop values ('Large Chicken Shop');

CREATE TABLE PrimaryCarer (
id int PRIMARY KEY
);
grant select on PrimaryCarer to public;

INSERT into PrimaryCarer values (56789);
INSERT into PrimaryCarer values (56780);
INSERT into PrimaryCarer values (56781);
INSERT into PrimaryCarer values (56782);
INSERT into PrimaryCarer values (56783);

CREATE TABLE AnimalGenus (
species char(20) PRIMARY KEY,
genus char(20) NOT NULL
);
grant select on AnimalGenus to public;

INSERT into AnimalGenus values ('Tiger', 'Panthera');
INSERT into AnimalGenus values ('Moose', 'Alces');
INSERT into AnimalGenus values ('Giraffe', 'Giraffa');
INSERT into AnimalGenus values ('Rhinoceros', 'Linnaeus');
INSERT into AnimalGenus values ('Jaguar', 'Panthera');
INSERT into AnimalGenus values ('Rooster', 'Junglefowl');
INSERT into AnimalGenus values ('Hen', 'Junglefowl');
INSERT into AnimalGenus values ('Cow', 'Bos');
INSERT into AnimalGenus values ('Goat', 'Capra');
INSERT into AnimalGenus values ('Pig', 'Sus');

CREATE TABLE Habitat (
name char(20) PRIMARY KEY,
capacity int DEFAULT 0
);
grant select on Habitat to public;

INSERT into Habitat values ('Chicken Coop', 50);
INSERT into Habitat values ('Pig Pen', 99);
INSERT into Habitat values ('Tiger Enclosure', 50);
INSERT into Habitat values ('Jaguar VIP Room', 10);
INSERT into Habitat values ('Cow Barn', 75);
INSERT into Habitat values ('Rehab Center', 75);
INSERT into Habitat values ('Tall', 50);
INSERT into Habitat values ('Chunky', 75);
INSERT into Habitat values ('Farm', 99);

CREATE TABLE SeatBracket(
	seatNum INT PRIMARY KEY,
	price INT
);
grant select on SeatBracket to public;

INSERT into SeatBracket values (9, 100);
INSERT into SeatBracket values (23, 70);
INSERT into SeatBracket values (37, 40);
INSERT into SeatBracket values (44, 20);
INSERT into SeatBracket values (50, 20);

CREATE TABLE Visitor (
	ID int PRIMARY KEY,
);
grant select on Visitor to public;

INSERT into Visitor values (12345);
INSERT into Visitor values (12346);
INSERT into Visitor values (12347);
INSERT into Visitor values (12348);
INSERT into Visitor values (12349);

CREATE TABLE Animal (
	name char(20),
	species char(20),
	habitatName char(20) NOT NULL,
	primaryCarerID char(20),
	PRIMARY KEY (name, species),
	FOREIGN KEY (habitatName) REFERENCES Habitat(name) ON DELETE CASCADE,
	FOREIGN KEY (species) REFERENCES AnimalGenus(species) ON DELETE CASCADE,
	FOREIGN KEY (primaryCarerID) REFERENCES PrimaryCarer (id) ON DELETE CASCADE
);
grant select on Animal to public;

INSERT into Animal values ('Timmy', 'Tiger', 'Tiger Enclosure', 56789);
INSERT into Animal values ('Matilda', 'Moose', 'Deers', 56783);
INSERT into Animal values ('Giovanni', 'Giraffe', 'Tall', 56783);
INSERT into Animal values ('Rory', ' Rhinoceros', 'Chunky', 56783);
INSERT into Animal values ('Juanita', ' Jaguar', 'Jaguar VIP Room', 56789);
INSERT into Animal values ('Romelu', 'Rooster', 'Chicken Coop', null);
INSERT into Animal values ('Holly', 'Hen', 'Chicken Coop', null);
INSERT into Animal values ('Helen', 'Hen', 'Chicken Coop', null);
INSERT into Animal values ('Carrey', 'Cow', 'Chicken Coop', null);
INSERT into Animal values ('Grace', 'Goat', 'Farm', null);
INSERT into Animal values ('Peppa', 'Pig', 'Pig Pen', null);
INSERT into Animal values ('Sammy', 'Squirrel', 'Rehab Center', 56789);

CREATE TABLE WildAnimal (
	name char(20),
	species char(20),
	sponsorName char(20) NOT NULL,
	PRIMARY KEY (name, species),
	FOREIGN KEY (name, species) REFERENCES Animal (name, species) ON DELETE CASCADE,
	FOREIGN KEY (sponsorName) REFERENCES Sponsor (name) ON DELETE CASCADE,
	FOREIGN KEY (species) REFERENCES AnimalGenus(species) ON DELETE CASCADE
);
grant select on WildAnimal to public;

INSERT into WildAnimal values ('Timmy', 'Tiger', 'Timmy Rich');
INSERT into WildAnimal values ('Matilda', 'Moose', 'Melinda Ubericher');
INSERT into WildAnimal values ('Giovanni', 'Giraffe', 'Gary Supericher');
INSERT into WildAnimal values ('Rory', ' Rhinoceros', 'Rachel Richer');
INSERT into WildAnimal values ('Juanita', ' Jaguar', 'Jeffrey Bezos');

CREATE TABLE DomesticatedAnimal (
	name char(20),
	species char(20),
	PRIMARY KEY (name, species),
	FOREIGN KEY (name, species) REFERENCES Animal(name, species) ON DELETE CASCADE,
	FOREIGN KEY (species) REFERENCES AnimalGenus(species) ON DELETE CASCADE
);
grant select on DomesticatedAnimal to public;

INSERT into DomesticatedAnimal values ('Romelu', 'Rooster');
INSERT into DomesticatedAnimal values ('Holly', 'Hen');
INSERT into DomesticatedAnimal values ('Helen', 'Hen');
INSERT into DomesticatedAnimal values ('Carrey', 'Cow');
INSERT into DomesticatedAnimal values ('Grace', 'Goat');
INSERT into DomesticatedAnimal values ('Peppa', 'Pig');

CREATE TABLE AnimalProduct (
	animalName char(20),
	animalSpecies char(20),
	productName char(20),
	price int,
	giftShopName char(20),
	PRIMARY KEY(animalName, animalSpecies, productName),
	FOREIGN KEY (animalName, animalSpecies) REFERENCES DomesticatedAnimal(name, species) ON DELETE CASCADE,
	FOREIGN KEY (giftShopName) REFERENCES GiftShop (name) ON DELETE CASCADE
);
grant select on AnimalProduct to public;

INSERT into AnimalProduct values ('Holly', 'Hen','Eggs', 10, 'Small Chicken Shop');
INSERT into AnimalProduct values ('Helen', 'Hen','Eggs', 15, 'Large Chicken Shop');
INSERT into AnimalProduct values ('Grace', 'Goat','Cheese', 20, 'Goat Shop');
INSERT into AnimalProduct values ('Carrey', 'Cow','Yogurt', 15, 'Cow Shop');
INSERT into AnimalProduct values ('Carrey', 'Cow','Cheese', 25, 'Cow Shop');

CREATE TABLE AnimalProductProcured (
	visitorID int,
	animalName char(20),
	animalSpecies char(20),
	productName char(20),
	PRIMARY KEY (animalName, animalSpecies, productName),
	FOREIGN KEY (visitorID) REFERENCES Visitor(ID) ON DELETE CASCADE,
	FOREIGN KEY (animalName, animalSpecies, productName) REFERENCES AnimalProduct ON DELETE CASCADE
);
grant select on AnimalProductProcured to public;

INSERT into AnimalProductProcured values (12345,  'Grace', 'Goat','Cheese');
INSERT into AnimalProductProcured values (12345,  'Carrey', 'Cow','Cheese');
INSERT into AnimalProductProcured values (12346,  'Carrey', 'Cow','Cheese');
INSERT into AnimalProductProcured values (12347,  'Carrey', 'Cow','Yogurt');
INSERT into AnimalProductProcured values (12348,  'Holly', 'Hen','Eggs');

CREATE TABLE Show (
	name char(50),
	habitatName char(20),	
	PRIMARY KEY (name, habitatName),
	FOREIGN KEY (habitatName) REFERENCES Habitat(name) ON DELETE CASCADE
);
grant select on Show to public;

INSERT into Show values ('Jaguar VIP Experience',  'Jaguar VIP Room');
INSERT into Show values ('Chicken Dance', 'Chicken Coop');
INSERT into Show values ('Peppa Pig Concert', 'Pig Pen');
INSERT into Show values ('Barnyard Tour', 'Cow Barn');
INSERT into Show values ('Timmy The Tiger Stand Up Routine', 'Tiger Enclosure');

CREATE TABLE Ticket (
	ticketID int PRIMARY KEY,
	seatNum int,
	showName char(50) NOT NULL,
	visitorID int,
	FOREIGN KEY (seatNum) REFERENCES SeatBracket(seatNum) ON DELETE CASCADE,
	FOREIGN KEY (showName) REFERENCES Show (name) ON DELETE CASCADE,
	FOREIGN KEY (visitorID) REFERENCES Visitor(ID) ON DELETE CASCADE
);
grant select on Ticket to public;

INSERT into Ticket values (109, 9, 'Jaguar VIP Experience', 12345);
INSERT into Ticket values (237, 37, 'Chicken Dance', 12346);
INSERT into Ticket values (350, 50, 'Peppa Pig Concert', 12347);
INSERT into Ticket values (444, 44, 'Barnyard Tour', 12348);
INSERT into Ticket values (523, 23, 'Timmy The Tiger Stand Up Routine', 12349);










