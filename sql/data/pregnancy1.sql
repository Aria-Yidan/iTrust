INSERT INTO officevisitrecord
(id, patientID, HCPID, weeksOfPregnant, weightGain, highbloodPressure, lowbloodPressure, fetalHeartRate,
numberOfPregnancy, lowLyingPlacenta, currentDate)
VALUES
    (
    1, 1, 9000000000, "21-01", 1, 2, 3, 4, 5, FALSE, CONCAT(YEAR(NOW())+1, '-06-04 10:30:00')
    );

INSERT INTO pregnancy
(MID,
yearOfConception,
weeksOfPregnant,
hoursInLabor,
weightGain,
deliveryType)
VALUES
    (
      6,
      2018,
      '40-6',
      4.5,
      20,
      'vaginal delivery'
    ),
    (
      6,
      2017,
      '35-4',
      5.0,
      25,
      'vaginal delivery forceps assist'
    ),
    (
      6,
      2018,
      '31-6',
      5.5,
      23.4,
      'caesarean section'
    ),
    (
      7,
      2016,
      '40-6',
      4.5,
      20,
      'vaginal delivery'
    ),
    (
      7,
      2017,
      '40-6',
      4.5,
      20,
      'miscarriage'
    ),
    (
      8,
      2013,
      '40-6',
      4.5,
      20,
      'vaginal delivery'
    ),
    (
      8,
      2018,
      '40-6',
      4.5,
      20,
      'caesarean section'
    ),
    (
      12,
      2018,
      '40-6',
      4.5,
      20,
      'caesarean section'
    );
