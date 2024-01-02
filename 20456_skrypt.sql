set dateformat ymd;
GO
create table uzytkownik (
	id int primary key,
	imie varchar(15) not null,
	nazwisko varchar(30) not null,
	nazwa_uzytkownika varchar(30) unique not null,
	data_urodzenia date not null,
	email varchar(30) unique not null
);
GO


create table dzien (
	id int primary key,
	dat datetime not null default getdate(),
	notatki varchar(150),
	uzytkownik_id int foreign key references uzytkownik(id)
);
GO

create table aktywnosc_medytacja (
	id int primary key,
	czas_trwania time not null,
	intencja varchar(50),
	dzien_id int foreign key references dzien(id)
);
GO

create table typ_treningu (
	id int primary key,
	nazwa varchar(50) unique not null,
	opis varchar(200)
);
GO

create table aktywnosc_trening (
	id int primary key,
	czas_trwania time not null,
	typ_treningu_id int foreign key references typ_treningu(id),
	spalone_kalorie int not null,
	dzien_id int foreign key references dzien(id)
);
GO

create table typ_pracy (
	id int primary key,
	nazwa varchar(25) unique not null,
	opis varchar(100)
);
GO

create table aktywnosc_praca (
	id int primary key,
	czas float not null,
	zarobek money not null default 0,
	dzien_id int foreign key references dzien(id),
	typ_pracy_id int foreign key references typ_pracy(id)
);
GO

create table ksiazka (
	id int primary key,
	tytul varchar(100) not null,
	autor_imie varchar(20) not null,
	autor_nazwisko varchar(30) not null
);
GO

create table aktywnosc_czytanie (
	id int primary key,
	ile_stron int not null default 0,
	dzien_id int foreign key references dzien(id),
	ksiazka_id int foreign key references ksiazka(id)
);
GO

create table grattitude_journal (
	id int primary key,
	opis varchar(500) not null,
	ocena_nastroju int not null, default 10,
	dzien_id int foreign key references dzien(id),
);
GO

create table posilek (
	id int primary key,
	id_nazwa varchar(30) unique not null,
	kalorie int not null,
	bialka int not null,
	tluszcze int not null,
	weglowodany int not null
);
GO

create table aktywnosc_dieta (
	id int primary key,
	opis varchar(100),
	dzien_id int foreign key references dzien(id),
	suma_kalorii int not null,
	suma_b int not null,
	suma_t int not null,
	suma_ww int not null
);
GO

create table posilek_w_diecie (
	posilek_id int foreign key references posilek(id),
	aktywnosc_dieta_id int foreign key references aktywnosc_dieta(id)
);
GO

create table rzecz_do_nauki (
	id int primary key,
	nazwa varchar(50) not null,
	opis varchar(200),
);
GO

create table aktywnosc_nauka (
	id int primary key,
	czas int not null,
	dzien_id int foreign key references dzien(id),
	rzecz_do_nauki_id int foreign key references rzecz_do_nauki(id)
);
insert into uzytkownik values (1, 'Jan', 'Kowalski', 'jankowalski', '1990-01-01', 'jankowalski@gmail.com')
insert into uzytkownik values (2, 'Adam', 'Nowak', 'adamnowak', '1990-01-01', 'adamnowak@icloud.com')
insert into uzytkownik values (3, 'Anna', 'Kowalska', 'annakowalska', '1990-01-01', 'annakowalska@wp.pl')

insert into dzien values (1, '2020-01-01', '', 1)
insert into dzien values (2, '2020-01-02', '', 1)
insert into dzien values (3, '2020-01-03', '', 2)
insert into dzien values (4, '2020-01-04', '', 2)
insert into dzien values (5, '2020-01-05', '', 3)
insert into dzien values (6, '2020-01-06', '', 3)

insert into aktywnosc_medytacja values (1, '00:05:00', '', 1)
insert into aktywnosc_medytacja values (2, '00:10:00', '', 2)
insert into aktywnosc_medytacja values (3, '00:15:00', '', 3)
insert into aktywnosc_medytacja values (4, '00:20:00', '', 4)
insert into aktywnosc_medytacja values (5, '00:25:00', '', 5)
insert into aktywnosc_medytacja values (6, '00:30:00', '', 6)

insert into typ_treningu values (1, 'Bieganie', '')
insert into typ_treningu values (2, 'Siłownia', '')
insert into typ_treningu values (3, 'Joga', '')
insert into typ_treningu values (4, 'Pływanie', '')
insert into typ_treningu values (5, 'Jazda na rowerze', '')

insert into aktywnosc_trening values (1, '00:30:00', 1, 100, 1)
insert into aktywnosc_trening values (2, '00:45:00', 2, 200, 2)
insert into aktywnosc_trening values (3, '01:00:00', 3, 300, 3)
insert into aktywnosc_trening values (4, '01:15:00', 4, 400, 4)
insert into aktywnosc_trening values (5, '01:30:00', 5, 500, 5)
insert into aktywnosc_trening values (6, '01:45:00', 1, 600, 6)

insert into typ_pracy values (1, 'Etat', '')
insert into typ_pracy values (2, 'Własny biznes', '')
insert into typ_pracy values (3, 'Korepetycje', '')
insert into typ_pracy values (4, 'Praca dorywcza', '')
insert into typ_pracy values (5, 'Praca sezonowa', '')

insert into aktywnosc_praca values (1, 8, 100, 1, 1)
insert into aktywnosc_praca values (2, 8, 200, 2, 2)
insert into aktywnosc_praca values (3, 8, 300, 3, 3)
insert into aktywnosc_praca values (4, 8, 400, 4, 4)
insert into aktywnosc_praca values (5, 8, 500, 5, 5)
insert into aktywnosc_praca values (6, 8, 600, 6, 1)

insert into ksiazka values (1, 'Władca Pierścieni', 'J.R.R.', 'Tolkien')
insert into ksiazka values (2, 'Harry Potter', 'J.K.', 'Rowling')
insert into ksiazka values (3, 'Wiedźmin', 'Andrzej', 'Sapkowski')
insert into ksiazka values (4, 'Hobbit', 'J.R.R.', 'Tolkien')
insert into ksiazka values (5, 'Pan Tadeusz', 'Adam', 'Mickiewicz')
insert into ksiazka values (6, 'Lalka', 'Bolesław', 'Prus')

insert into aktywnosc_czytanie values (1, 100, 1, 1)
insert into aktywnosc_czytanie values (2, 200, 2, 2)
insert into aktywnosc_czytanie values (3, 300, 3, 3)
insert into aktywnosc_czytanie values (4, 400, 4, 4)
insert into aktywnosc_czytanie values (5, 500, 5, 5)
insert into aktywnosc_czytanie values (6, 600, 6, 6)

insert into grattitude_journal values (1, 'Dziś jest piękny dzień', 10, 1)
insert into grattitude_journal values (2, 'Mam wspaniałą rodzinę', 10, 2)
insert into grattitude_journal values (3, 'Jestem zdrowy', 10, 3)
insert into grattitude_journal values (4, 'Mam wspaniałych przyjaciół', 10, 4)
insert into grattitude_journal values (5, 'Mam wspaniałą pracę', 10, 5)
insert into grattitude_journal values (6, 'Mam wspaniałą rodzinę', 10, 6)

insert into posilek values (1, 'Jajecznica', 200, 20, 10, 5)
insert into posilek values (2, 'Kanapka z szynką', 300, 30, 20, 10)
insert into posilek values (3, 'Kanapka z serem', 400, 40, 30, 15)
insert into posilek values (4, 'Kanapka z serem i szynką', 500, 50, 40, 20)
insert into posilek values (5, 'Kanapka z serem i szynką i jajkiem', 600, 60, 50, 25)
insert into posilek values (6, 'Kanapka z serem i szynką i jajkiem i pomidorem', 700, 70, 60, 30)

insert into aktywnosc_dieta values (1, '', 1, 3000, 160, 80, 400)
insert into aktywnosc_dieta values (2, '', 2, 3000, 160, 80, 400)
insert into aktywnosc_dieta values (3, '', 3, 3000, 160, 80, 400)
insert into aktywnosc_dieta values (4, '', 4, 3000, 160, 80, 400)
insert into aktywnosc_dieta values (5, '', 5, 3000, 160, 80, 400)
insert into aktywnosc_dieta values (6, '', 6, 3000, 160, 80, 400)

insert into posilek_w_diecie values (1, 1)
insert into posilek_w_diecie values (2, 2)
insert into posilek_w_diecie values (3, 3)
insert into posilek_w_diecie values (4, 4)
insert into posilek_w_diecie values (5, 5)
insert into posilek_w_diecie values (6, 6)

insert into rzecz_do_nauki values (1, 'Nauka języka angielskiego', '')
insert into rzecz_do_nauki values (2, 'Nauka języka niemieckiego', '')
insert into rzecz_do_nauki values (3, 'Nauka języka francuskiego', '')
insert into rzecz_do_nauki values (4, 'Nauka programowania', '')
insert into rzecz_do_nauki values (5, 'Nauka gry na gitarze', '')
insert into rzecz_do_nauki values (6, 'Rozwój umiejętności interpersonalnych', '')

insert into aktywnosc_nauka values (1, 30, 1, 1)
insert into aktywnosc_nauka values (2, 30, 2, 2)
insert into aktywnosc_nauka values (3, 30, 3, 3)
insert into aktywnosc_nauka values (4, 30, 4, 4)
insert into aktywnosc_nauka values (5, 30, 5, 5)
insert into aktywnosc_nauka values (6, 30, 6, 6)





