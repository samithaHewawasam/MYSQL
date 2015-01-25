SELECT `C_Code` cCode,count(*) getCount,
  (SELECT count(*)
   FROM `registrations` rs
   LEFT JOIN `batch_master` bm ON rs.`Default_Batch`= bm.`BM_Batch_Code`
   WHERE bm.`BM_Course_Code`= c.`C_Code`
     AND rs.`RG_Status` = 'Inactive') getInactive,
  (SELECT count(*)
   FROM `registrations` reg
   LEFT JOIN `batch_master` bmt ON reg.`Default_Batch`= bmt.`BM_Batch_Code`
   WHERE reg.`Default_Batch`= r.`Default_Batch`
     AND reg.`RG_Final_Fee` = reg.`RG_Total_Paid`) getFullPaid,
  (SELECT count(*)
   FROM `registrations` regs
   LEFT JOIN `batch_master` bmts ON regs.`Default_Batch`= bmts.`BM_Batch_Code`
   WHERE regs.`Default_Batch`= r.`Default_Batch`
     AND regs.`RG_Final_Fee` > regs.`RG_Total_Paid`
     AND `BM_Status` = 'Active') getDue
FROM `registrations` r
LEFT JOIN `batch_master` b ON r.`Default_Batch`=b.`BM_Batch_Code`
LEFT JOIN `registration_type` t ON r.`RG_Reg_Type`= t.`RT_Code`
LEFT JOIN `course` c ON b.`BM_Course_Code`= c.`C_Code`
AND c.`C_Code` IS NOT NULL
GROUP BY c.`C_Code`
