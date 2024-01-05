CREATE VIEW DailyActivitySummary AS
SELECT
    d.id AS DayID,
    d.dat AS Date,
    u.imie AS FirstName,
    u.nazwisko AS LastName,
    ISNULL(SUM(am.czas_trwania), 0) AS TotalMeditationTime,
    ISNULL(SUM(at.czas_trwania), 0) AS TotalTrainingTime,
    ISNULL(SUM(ap.czas), 0) AS TotalWorkTime,
    ISNULL(SUM(ac.ile_stron), 0) AS TotalPagesRead,
    ISNULL(SUM(an.czas), 0) AS TotalStudyTime
FROM dzien d
JOIN uzytkownik u ON d.uzytkownik_id = u.id
LEFT JOIN aktywnosc_medytacja am ON d.id = am.dzien_id
LEFT JOIN aktywnosc_trening at ON d.id = at.dzien_id
LEFT JOIN aktywnosc_praca ap ON d.id = ap.dzien_id
LEFT JOIN aktywnosc_czytanie ac ON d.id = ac.dzien_id
LEFT JOIN aktywnosc_nauka an ON d.id = an.dzien_id
GROUP BY d.id, d.dat, u.imie, u.nazwisko;

CREATE VIEW DailyDietSummary AS
SELECT
    d.id AS DayID,
    d.dat AS Date,
    u.imie AS FirstName,
    u.nazwisko AS LastName,
    ISNULL(SUM(ad.suma_kalorii), 0) AS TotalCaloriesConsumed,
    ISNULL(SUM(ad.suma_b), 0) AS TotalProteinsConsumed,
    ISNULL(SUM(ad.suma_t), 0) AS TotalFatsConsumed,
    ISNULL(SUM(ad.suma_ww), 0) AS TotalCarbsConsumed
FROM dzien d
JOIN uzytkownik u ON d.uzytkownik_id = u.id
LEFT JOIN aktywnosc_dieta ad ON d.id = ad.dzien_id
GROUP BY d.id, d.dat, u.imie, u.nazwisko;

CREATE FUNCTION GetBooksReadByUser
(
    @UserId INT
)
RETURNS TABLE
AS
RETURN (
    SELECT k.tytul AS BookTitle, ac.ile_stron AS PagesRead
    FROM aktywnosc_czytanie ac
    JOIN ksiazka k ON ac.ksiazka_id = k.id
    JOIN dzien d ON ac.dzien_id = d.id
    WHERE d.uzytkownik_id = @UserId
);

CREATE FUNCTION CalculateBMI
(
    @WeightKg DECIMAL(5,2),
    @HeightMeters DECIMAL(5,2)
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @BMI DECIMAL(5,2);
    
    SET @BMI = @WeightKg / POWER(@HeightMeters, 2);

    RETURN @BMI;
END;

CREATE PROCEDURE GenerateMonthlyReport
(
    @UserId INT,
    @Year INT,
    @Month INT
)
AS
BEGIN
    DECLARE @StartDate DATE = DATEFROMPARTS(@Year, @Month, 1);
    DECLARE @EndDate DATE = DATEADD(DAY, -1, DATEADD(MONTH, 1, @StartDate));
    SELECT
        d.dat AS Date,
        COALESCE(SUM(am.czas_trwania), 0) AS TotalMeditationTime,
        COALESCE(SUM(at.czas_trwania), 0) AS TotalTrainingTime,
        COALESCE(SUM(ap.czas), 0) AS TotalWorkTime,
        COALESCE(SUM(ac.ile_stron), 0) AS TotalPagesRead,
        COALESCE(SUM(an.czas), 0) AS TotalStudyTime
    FROM dzien d
    LEFT JOIN aktywnosc_medytacja am ON d.id = am.dzien_id
    LEFT JOIN aktywnosc_trening at ON d.id = at.dzien_id
    LEFT JOIN aktywnosc_praca ap ON d.id = ap.dzien_id
    LEFT JOIN aktywnosc_czytanie ac ON d.id = ac.dzien_id
    LEFT JOIN aktywnosc_nauka an ON d.id = an.dzien_id
    WHERE d.uzytkownik_id = @UserId
        AND d.dat BETWEEN @StartDate AND @EndDate
    GROUP BY d.dat;
END;

CREATE PROCEDURE ArchiveOldData
AS
BEGIN
    DECLARE @ArchiveDate DATE = DATEADD(MONTH, -6, GETDATE());

    INSERT INTO archiwum_medytacji
    SELECT *
    FROM aktywnosc_medytacja
    WHERE dzien_id IN (SELECT id FROM dzien WHERE dat < @ArchiveDate);

    INSERT INTO archiwum_treningu
    SELECT *
    FROM aktywnosc_trening
    WHERE dzien_id IN (SELECT id FROM dzien WHERE dat < @ArchiveDate);

    DELETE FROM aktywnosc_medytacja WHERE dzien_id IN (SELECT id FROM dzien WHERE dat < @ArchiveDate);
    DELETE FROM aktywnosc_trening WHERE dzien_id IN (SELECT id FROM dzien WHERE dat < @ArchiveDate);
    DELETE FROM dzien WHERE dat < @ArchiveDate;
END;

CREATE TRIGGER PreventDuplicateEmail
ON uzytkownik
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted i INNER JOIN uzytkownik u ON i.email = u.email WHERE i.id <> u.id)
    BEGIN
        RAISEERROR ('Użytkownik o podanym adresie e-mail już istnieje.', 16, 1);
        ROLLBACK;
    END
END;

CREATE TRIGGER UpdateBookCountOnReadingActivity
ON aktywnosc_czytanie
AFTER INSERT
AS
BEGIN
    UPDATE ksiazka
    SET ilosc_przeczytanych = ilosc_przeczytanych + inserted.ile_stron
    FROM ksiazka
    JOIN inserted ON ksiazka.id = inserted.ksiazka_id;
END;

CREATE TRIGGER EnforcePositiveSalary
ON aktywnosc_praca
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE zarobek < 0)
    BEGIN
        RAISEERROR ('Wynagrodzenie nie może być ujemne.', 16, 1);
        ROLLBACK;
    END
END;

CREATE TRIGGER UpdateAverageRatingOnGratitudeEntry
ON grattitude_journal
AFTER INSERT
AS
BEGIN
    DECLARE @AverageRating INT;

    SELECT @AverageRating = AVG(ocena_nastroju)
    FROM grattitude_journal
    WHERE dzien_id IN (SELECT id FROM inserted);

    UPDATE dzien
    SET srednia_ocena_nastroju = @AverageRating
    WHERE id IN (SELECT id FROM inserted);
END;


