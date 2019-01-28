# Get rid off all duplicated data first before setting certain columns to unique while altering the database table
DELETE t1 FROM pregnancy AS t1
    INNER JOIN
  pregnancy AS t2
WHERE
    t1.id > t2.id AND t1.MID = t2.MID AND t1.deliveryType = t2.deliveryType AND t1.hoursInLabor = t2.hoursInLabor AND t1.weeksOfPregnant = t2.weeksOfPregnant
      AND t1.weightGain = t2.weightGain AND t1.yearOfConception = t2.yearOfConception;



# Alter the database table by setting certain column combination to unique
ALTER TABLE pregnancy
ADD UNIQUE (MID, yearOfConception, weeksOfPregnant, hoursInLabor, weightGain, deliveryType);