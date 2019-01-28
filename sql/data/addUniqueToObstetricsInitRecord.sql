# Get rid off all duplicated data first before setting certain columns to unique while altering the database table
DELETE t1 FROM obstetricsInitRecord AS t1
    INNER JOIN
  obstetricsInitRecord AS t2
WHERE t1.id > t2.id
  AND t1.MID = t2.MID AND t1.LMP = t2.LMP AND t1.EDD = t2.EDD AND t1.weeksOfPregnant = t2.weeksOfPregnant;

# Alter the database table by setting certain column combination to unique
ALTER TABLE obstetricsInitRecord
ADD UNIQUE (MID, LMP, EDD, weeksOfPregnant);