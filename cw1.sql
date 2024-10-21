-- zestaw zadań ćwiczenia 1 

-- 1
CREATE DATABASE firma;

-- 2
CREATE SCHEMA ksiegowosc;

-- 3
CREATE TABLE ksiegowosc.pracownicy(

id_pracownika SERIAL PRIMARY KEY,
imie VARCHAR(50) NOT NULL,
nazwisko VARCHAR(50) NOT NULL,
adres VARCHAR(100) NOT NULL,
telefon VARCHAR(13)

);

CREATE TABLE ksiegowosc.godziny(

id_godziny SERIAL PRIMARY KEY,
data DATE NOT NULL,
liczba_godzin NUMERIC(4,2) NOT NULL,
id_pracownika INT REFERENCES ksiegowosc.pracownicy(id_pracownika) ON DELETE CASCADE

);

CREATE TABLE ksiegowosc.pensja(

id_pensji SERIAL PRIMARY KEY,
stanowisko VARCHAR(50) NOT NULL,
kwota NUMERIC(10,2) NOT NULL

);

CREATE TABLE ksiegowosc.premia(

id_premii SERIAL PRIMARY KEY,
rodzaj VARCHAR(50) NOT NULL,
kwota NUMERIC(10,2) NOT NULL

);

CREATE TABLE ksiegowosc.wynagrodzenie(

id_wynagrodzenia SERIAL PRIMARY KEY,
data DATE NOT NULL,
id_pracownika INT REFERENCES ksiegowosc.pracownicy(id_pracownika) ON DELETE CASCADE,
id_godziny INT REFERENCES ksiegowosc.godziny(id_godziny) ON DELETE CASCADE,
id_pensji INT REFERENCES ksiegowosc.pensja(id_pensji) ON DELETE SET NULL,
id_premii INT REFERENCES ksiegowosc.premia(id_premii) ON DELETE SET NULL

);

-- 4
INSERT INTO ksiegowosc.pracownicy (imie, nazwisko, adres, telefon) VALUES
('Adam', 'Nowak', 'Warszawa, ul. Zielona 5', '123456789'),
('Ewa', 'Kowalska', 'Kraków, ul. Czerwona 10', '987654321'),
('Jan', 'Wiśniewski', 'Poznań, ul. Niebieska 7', '234567890'),
('Anna', 'Szymańska', 'Wrocław, ul. Biała 12', '345678901'),
('Marek', 'Lewandowski', 'Gdańsk, ul. Pomarańczowa 9', '456789012'),
('Agnieszka', 'Kamińska', 'Lublin, ul. Fioletowa 11', '567890123'),
('Piotr', 'Zieliński', 'Łódź, ul. Żółta 14', '678901234'),
('Karolina', 'Wojciechowska', 'Szczecin, ul. Szara 4', '789012345'),
('Tomasz', 'Kaczmarek', 'Bydgoszcz, ul. Czarna 16', '890123456'),
('Monika', 'Piotrowska', 'Katowice, ul. Różowa 13', '901234567');

INSERT INTO ksiegowosc.godziny (data, liczba_godzin, id_pracownika) VALUES
('2024-10-01', 8.0, 1),
('2024-10-02', 7.5, 2),
('2024-10-03', 6.0, 3),
('2024-10-04', 8.0, 4),
('2024-10-05', 4.0, 5),
('2024-10-06', 9.0, 6),
('2024-10-07', 8.0, 7),
('2024-10-08', 7.0, 8),
('2024-10-09', 6.5, 9),
('2024-10-10', 8.0, 10);

INSERT INTO ksiegowosc.pensja (stanowisko, kwota) VALUES
('Manager', 7000.00),
('Księgowy', 5000.00),
('Analityk', 6000.00),
('Specjalista HR', 4500.00),
('Programista', 8000.00),
('Technik', 4000.00),
('Administrator', 5500.00),
('Sprzedawca', 3500.00),
('Magazynier', 3000.00),
('Kierownik', 6500.00);

INSERT INTO ksiegowosc.premia (rodzaj, kwota) VALUES
('Świąteczna', 1000.00),
('Uznaniowa', 500.00),
('Roczna', 2000.00),
('Za wyniki', 750.00),
('Lojalnościowa', 1200.00),
('Projektowa', 600.00),
('Bonus', 800.00),
('Dodatkowa', 400.00),
('Okolicznościowa', 900.00),
('Motywacyjna', 1100.00);

INSERT INTO ksiegowosc.wynagrodzenie (data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES
('2024-10-10', 1, 1, 1, 1),
('2024-10-10', 2, 2, 2, 2),
('2024-10-10', 3, 3, 3, 3),
('2024-10-10', 4, 4, 4, 4),
('2024-10-10', 5, 5, 5, 5),
('2024-10-10', 6, 6, 6, 6),
('2024-10-10', 7, 7, 7, 7),
('2024-10-10', 8, 8, 8, 8),
('2024-10-10', 9, 9, 9, 9),
('2024-10-10', 10, 10, 10, 10);

-- 5
-- a)
SELECT id_pracownika, nazwisko
FROM ksiegowosc.pracownicy;

-- b)
SELECT w.id_pracownika
FROM ksiegowosc.wynagrodzenie w
JOIN ksiegowosc.pensja p ON w.id_pensji = p.id_pensji
WHERE p.kwota > 1000;

-- c)
SELECT w.id_pracownika
FROM ksiegowosc.wynagrodzenie w
JOIN ksiegowosc.pensja p ON w.id_pensji = p.id_pensji
WHERE w.id_premii IS NULL
AND p.kwota > 2000;

-- d)
SELECT *
FROM ksiegowosc.pracownicy
WHERE imie LIKE 'J%';

-- e)
SELECT *
FROM ksiegowosc.pracownicy
WHERE nazwisko LIKE '%n%'
AND imie LIKE '%a';

-- f)
SELECT p.imie, p.nazwisko, GREATEST(SUM(g.liczba_godzin) - 160, 0) AS nadgodziny
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.godziny g ON p.id_pracownika = g.id_pracownika
GROUP BY p.imie, p.nazwisko;

-- g)
SELECT p.imie, p.nazwisko
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.pensja pe ON w.id_pensji = pe.id_pensji
WHERE pe.kwota BETWEEN 1500 AND 3000;

-- h)
SELECT p.imie, p.nazwisko
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.godziny g ON w.id_godziny = g.id_godziny
WHERE w.id_premii IS NULL
GROUP BY p.imie, p.nazwisko
HAVING SUM(g.liczba_godzin) > 160;

-- i)
SELECT p.imie, p.nazwisko, pe.kwota
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.pensja pe ON w.id_pensji = pe.id_pensji
ORDER BY pe.kwota;

-- j)

SELECT p.imie, p.nazwisko, pe.kwota AS pensja, pr.kwota AS premia
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.pensja pe ON w.id_pensji = pe.id_pensji
LEFT JOIN ksiegowosc.premia pr ON w.id_premii = pr.id_premii
ORDER BY pe.kwota DESC, pr.kwota DESC;

-- k)
SELECT pe.stanowisko, COUNT(p.id_pracownika) AS liczba_pracowników
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.pensja pe ON w.id_pensji = pe.id_pensji
GROUP BY pe.stanowisko;

-- l)
SELECT pe.stanowisko, AVG(pe.kwota) AS średnia_pensja, MIN(pe.kwota) AS minimalna_pensja, MAX(pe.kwota) AS maksymalna_pensja
FROM ksiegowosc.wynagrodzenie w
JOIN ksiegowosc.pensja pe ON w.id_pensji = pe.id_pensji
WHERE pe.stanowisko = 'Kierownik'
GROUP BY pe.stanowisko;

-- m)
SELECT SUM(pe.kwota) + SUM(pr.kwota)
FROM ksiegowosc.wynagrodzenie w
JOIN ksiegowosc.pensja pe ON w.id_pensji = pe.id_pensji
JOIN ksiegowosc.premia pr ON w.id_premii = pr.id_premii;

-- F)
SELECT pe.stanowisko, SUM(pe.kwota) + SUM(pr.kwota) AS suma_wynagrodzeń
FROM ksiegowosc.wynagrodzenie w
JOIN ksiegowosc.pensja pe ON w.id_pensji = pe.id_pensji
JOIN ksiegowosc.premia pr ON w.id_premii = pr.id_premii
GROUP BY pe.stanowisko;

-- G)
SELECT pe.stanowisko, COUNT(pr.id_premii) AS ilosc_premii
FROM ksiegowosc.wynagrodzenie w
JOIN ksiegowosc.pensja pe ON w.id_pensji = pe.id_pensji
JOIN ksiegowosc.premia pr ON w.id_premii = pr.id_premii
GROUP BY pe.stanowisko;

-- H)
DELETE FROM ksiegowosc.pracownicy
WHERE id_pracownika IN(

SELECT p.id_pracownika
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.pensja pe ON w.id_pensji = pe.id_pensji
WHERE pe.kwota < 1200

);
