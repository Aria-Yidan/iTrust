INSERT INTO TravelHistories(patientMID, startDate, endDate, travelledCities) VALUES
(16, CONCAT(YEAR(NOW())-5, '-06-04 10:30:00'), CONCAT(YEAR(NOW())-5, '-06-10 10:30:00'), 'Vancouver,Canada & Cancun, Mexico'),
(1, CONCAT(YEAR(NOW())-3, '-07-11 10:30:00'), CONCAT(YEAR(NOW())-3, '-07-24 10:30:00'), 'Paris,France & Seoul,South Korea'),
(1, CONCAT(YEAR(NOW())-1, '-01-21 10:30:00'), CONCAT(YEAR(NOW())-1, '-01-29 10:30:00'), 'Barcelona,Spain & Tokyo,Japan'),
(1, CONCAT(YEAR(NOW())-1, '-03-19 10:30:00'), CONCAT(YEAR(NOW())-1, '-03-30 10:30:00'), 'Illinois,USA & Washington,USA'),
(1, CONCAT(YEAR(NOW())-1, '-09-21 10:30:00'), CONCAT(YEAR(NOW()), '-01-29 10:30:00'), 'Los Angeles,USA & New York,USA & Toronto,Canada');