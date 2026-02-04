DECLARE @i INT = 1

WHILE @i <= 50
BEGIN

    INSERT INTO dbo.Kullanicilar
    (FirstName, CreatedDate, Lastname, Email, Role)
    VALUES
    (
        CONCAT('User', FLOOR(RAND() * 10000)), -- FirstName
        DATEADD(SECOND, -ABS(CHECKSUM(NEWID()) % 31536000), GETDATE()), -- CreatedDate (random last 1 year)
        CONCAT('Soyad', FLOOR(RAND() * 10000)), -- Lastname
        CONCAT('user', FLOOR(RAND() * 10000), '@mail.com'), -- Email
        CASE 
            WHEN RAND() < 0.2 THEN 'Admin'
            ELSE 'User'
        END
    )

    SET @i = @i + 1
END
