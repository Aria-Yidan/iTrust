INSERT INTO officevisitrecord
(id, patientID, HCPID, weeksOfPregnant, weightGain, highbloodPressure, lowbloodPressure, fetalHeartRate,
numberOfPregnancy, lowLyingPlacenta, currentDate)
VALUES
    (
    1, 1, 9000000000, "21-01", 1, 2, 3, 4, 5, FALSE, CONCAT(YEAR(NOW())+1, '-06-04 10:30:00')
    );