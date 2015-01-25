DROP TRIGGER IF EXISTS `inquiresallowedOperator`;

 DELIMITER //
CREATE TRIGGER `inquiresallowedOperator` AFTER
INSERT ON `student_inquiries`
FOR EACH ROW BEGIN 

DECLARE getlastBlockABOperator VARCHAR(30); 
DECLARE getLastBlockEOperator VARCHAR(30); 
DECLARE getCurrentBlockABOperatorId VARCHAR(30); 
DECLARE getCurrentBlockEOperatorId VARCHAR(30); 
DECLARE getNextBlockEOperatorId VARCHAR(30); 
DECLARE getNextBlockABOperatorId VARCHAR(30); 
DECLARE getNextBlockABOperatorName VARCHAR(30); 
DECLARE getNextBlockEOperatorName VARCHAR(30);

SET getlastBlockABOperator =
  (SELECT DISTINCT `allowedOperator`.`Operator`
   FROM `allowedOperator`
   WHERE `inqueryId` =
       (SELECT MAX(`inqueryId`)
        FROM `allowedOperator`
        INNER JOIN `student_inquiries` ON `student_inquiries`.`No` = `allowedOperator`.`inqueryId`
        WHERE (`course` != 'LMU-3-BBA'
               OR `course` != 'LMU-3-BSC-COM'
               OR `course` != 'LMU-MBA'
               OR `course` != 'LMU-T-BBA'
               OR `course` != 'LMU-T-BENG-SW'
               OR `course` != 'LMU-T-BSC-COM'
               OR `course` != 'L7-DIP'
               OR `course` != 'L7-EXT-DIP'
               OR `course` != 'CER-FO/OPT'
               OR `course` != 'CER-H/KEEP'
               OR `course` != 'CER-H/MGT'
               OR `course` != 'CER-TT/MGT'
               OR `course` != 'DIP-TT-H/MGT'
               OR `course` != 'HND-H/MGT'
               OR `course` != 'HND-TT/MGT')));

SET getLastBlockEOperator =
  (SELECT DISTINCT `allowedOperator`.`Operator`
   FROM `allowedOperator`
   WHERE `inqueryId` =
       (SELECT MAX(`inqueryId`)
        FROM `allowedOperator`
        INNER JOIN `student_inquiries` ON `student_inquiries`.`No` = `allowedOperator`.`inqueryId`
        WHERE (`course` = 'LMU-3-BBA'
               OR `course` = 'LMU-3-BSC-COM'
               OR `course` = 'LMU-MBA'
               OR `course` = 'LMU-T-BBA'
               OR `course` = 'LMU-T-BENG-SW'
               OR `course` = 'LMU-T-BSC-COM'
               OR `course` = 'L7-DIP'
               OR `course` = 'L7-EXT-DIP'
               OR `course` = 'CER-FO/OPT'
               OR `course` = 'CER-H/KEEP'
               OR `course` = 'CER-H/MGT'
               OR `course` = 'CER-TT/MGT'
               OR `course` = 'DIP-TT-H/MGT'
               OR `course` = 'HND-H/MGT'
               OR `course` = 'HND-TT/MGT')));

SET getCurrentBlockABOperatorId =
  (SELECT `Sys_U_ID`
   FROM `system_users_in`
   WHERE `Sys_U_Name` = getlastBlockABOperator
     AND `Sys_U_AccessLevel` = 'Front_Office');

SET getCurrentBlockEOperatorId =
  (SELECT `Sys_U_ID`
   FROM `system_users_in`
   WHERE `Sys_U_Name` = getLastBlockEOperator
     AND `Sys_U_AccessLevel` = 'Front_Office');

SET getNextBlockEOperatorId =
  (SELECT IF(MIN(`Sys_U_ID`) IS NULL,
                                6,
                                MIN(`Sys_U_ID`))
   FROM `system_users_in`
   WHERE `Sys_U_ID` > getCurrentBlockEOperatorId
     AND `Sys_U_ID` IN
       (SELECT `Sys_U_ID`
        FROM `system_users_in`
        WHERE `Sys_U_AccessLevel` = 'Front_Office'
          AND `Sys_U_Branch` = 'COL/E'));

SET getNextBlockABOperatorId =
  (SELECT IF(MIN(`Sys_U_ID`) IS NULL,
                                2,
                                MIN(`Sys_U_ID`))
   FROM `system_users_in`
   WHERE `Sys_U_ID` > getCurrentBlockABOperatorId
     AND `Sys_U_ID` IN
       (SELECT `Sys_U_ID`
        FROM `system_users_in`
        WHERE `Sys_U_AccessLevel` = 'Front_Office'
          AND `Sys_U_Branch` != 'COL/E'));

SET getNextBlockABOperatorName =
  (SELECT `Sys_U_Name`
   FROM `system_users_in`
   WHERE `Sys_U_ID` = getNextBlockABOperatorId
     AND `Sys_U_AccessLevel` = 'Front_Office');

SET getNextBlockEOperatorName =
  (SELECT `Sys_U_Name`
   FROM `system_users_in`
   WHERE `Sys_U_ID` = getNextBlockEOperatorId
     AND `Sys_U_AccessLevel` = 'Front_Office'); IF NEW.`course` = 'LMU-3-BBA'
OR NEW.`course` = 'LMU-3-BSC-COM'
OR NEW.`course` = 'LMU-MBA'
OR NEW.`course` = 'LMU-T-BBA'
OR NEW.`course` = 'LMU-T-BENG-SW'
OR NEW.`course` = 'LMU-T-BSC-COM'
OR NEW.`course` = 'L7-DIP'
OR NEW.`course` = 'L7-EXT-DIP'
OR NEW.`course` = 'CER-FO/OPT'
OR NEW.`course` = 'CER-H/KEEP'
OR NEW.`course` = 'CER-H/MGT'
OR NEW.`course` = 'CER-TT/MGT'
OR NEW.`course` = 'DIP-TT-H/MGT'
OR NEW.`course` = 'HND-H/MGT'
OR NEW.`course` = 'HND-TT/MGT' THEN IF NEW.`Branch` = 'Colombo'
AND NEW.`Operator` IS NULL
OR NEW.`Operator` = '' THEN
INSERT
IGNORE INTO `allowedOperator`(`inqueryId`, `Operator`)
VALUES (NEW.`No`,
        getNextBlockEOperatorName); END IF; ELSE IF NEW.`Branch` = 'Colombo'
AND NEW.`Operator` IS NULL
OR NEW.`Operator` = '' THEN
INSERT
IGNORE INTO `allowedOperator`(`inqueryId`, `Operator`)
VALUES (NEW.`No`,
        getNextBlockABOperatorName); END IF; END IF; 
END 
// DELIMITER;

