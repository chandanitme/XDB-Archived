

SELECT interactionid,
       Row_number()
         OVER (
           partition BY contactid
           ORDER BY lastmodified DESC) AS RowNum
INTO   #temp
FROM   [sc10dev_Xdb.Collection.Shard1].[xdb_collection].[interactions]
WHERE  contactid IN (SELECT contactid
                     FROM   [sc10dev_Xdb.Collection.Shard1].[xdb_collection].[interactions]
                     --Where ContactId in ('CC1CC7F5-26CF-0000-0000-06EB227A992C')
                     GROUP  BY contactid
                     HAVING Count(contactid) > 1000)
ORDER  BY 2

DELETE FROM #temp
WHERE  rownum  <=1000;

WITH newrownum
     AS (SELECT interactionid,
                Row_number()
                  OVER (
                    ORDER BY interactionid ASC) AS NewRowNum
         FROM   #temp)
UPDATE t
SET    t.rownum = n.newrownum
FROM   #temp t
       JOIN newrownum n
         ON t.interactionid = n.interactionid;

--select * from   #temp   order by RowNum desc
DECLARE @BatchSize INT = 1000; -- Set batch size for each operation
DECLARE @ProcessedCount INT = 0; -- Track number of records processed
DECLARE @TotalCount INT;

-- Get the total number of rows to process
SELECT @TotalCount = Count(*)
FROM   #temp;

WHILE EXISTS (SELECT 1
              FROM   #temp
              WHERE  rownum > @ProcessedCount)
  BEGIN
      -- Print progress
      PRINT 'Processing batch: '
            + Cast(@ProcessedCount / @BatchSize + 1 AS VARCHAR(10))
            + ' of '
            + Cast((@TotalCount / @BatchSize) + 1 AS VARCHAR(10))
            + ' (Rows '
            + Cast(@ProcessedCount + 1 AS VARCHAR(10))
            + ' to '
            + Cast(@ProcessedCount + @BatchSize AS VARCHAR(10))
            + ')';

      BEGIN try
          -- Start a transaction for the batch
          BEGIN TRANSACTION;

          INSERT INTO [XDB_Interaction_Archived].[dbo].[InteractionFacets_Archive_Shard1]
          SELECT *
          FROM   [sc10dev_Xdb.Collection.Shard1].[xdb_collection].[interactionfacets]
          WHERE  interactionid IN (SELECT interactionid
                                   FROM   #temp
                                   WHERE  rownum > @ProcessedCount
                                          AND rownum <= ( @ProcessedCount +
                                                          @BatchSize
                                                        ))

          DELETE FROM [sc10dev_Xdb.Collection.Shard1].[xdb_collection].[interactionfacets]
          WHERE  interactionid IN (SELECT interactionid
                                   FROM   #temp
                                   WHERE  rownum > @ProcessedCount
                                          AND rownum <= ( @ProcessedCount +
                                                          @BatchSize
                                                        ))

          INSERT INTO [XDB_Interaction_Archived].[dbo].[Interactions_Archive_Shard1]
          SELECT *
          FROM   [sc10dev_Xdb.Collection.Shard1].[xdb_collection].[interactions]
          WHERE  interactionid IN (SELECT interactionid
                                   FROM   #temp
                                   WHERE  rownum > @ProcessedCount
                                          AND rownum <= ( @ProcessedCount +
                                                          @BatchSize
                                                        ))

          DELETE FROM [sc10dev_Xdb.Collection.Shard1].[xdb_collection].[interactions]
          WHERE  interactionid IN (SELECT interactionid
                                   FROM   #temp
                                   WHERE  rownum > @ProcessedCount
                                          AND rownum <= ( @ProcessedCount +
                                                          @BatchSize
                                                        ))

          COMMIT TRANSACTION;

          SET @ProcessedCount = @ProcessedCount + @BatchSize;
      END try

      BEGIN catch
          -- If an error occurs, roll back the transaction and print error message
          ROLLBACK TRANSACTION;

          PRINT
      'Error occurred while processing batch. Rolling back transaction.'
          ;

          PRINT 'Error Message: ' + Error_message();

          -- Optionally, you can exit the loop or break here
          BREAK;
      END catch
  END

DROP TABLE #temp 
