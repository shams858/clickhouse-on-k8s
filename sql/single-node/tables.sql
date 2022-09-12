CREATE TABLE rankings_1node
(
    pageURL String,
    pageRank UInt32,
    avgDuration UInt32
)ENGINE = Log;
CREATE TABLE uservisits_1node
(
    sourceIP String,
    destinationURL String,
    visitDate Date,
    adRevenue Float32,
    UserAgent String,
    cCode FixedString(3),
    lCode FixedString(6),
    searchWord String,
    duration UInt32
) ENGINE = MergeTree()
ORDER BY (visitDate, destinationURL, sourceIP);
INSERT INTO rankings_1node(pageURL, pageRank, avgDuration)  
SELECT * 
FROM s3('https://big-data-benchmark.s3.amazonaws.com/pavlo/text-deflate/1node/rankings/*.deflate', 'CSV', 'pageURL String,
    pageRank UInt32,
    avgDuration UInt32', 'deflate');
INSERT INTO uservisits_1node(sourceIP, destinationURL, visitDate, adRevenue, UserAgent, cCode,lCode,searchWord,duration)
select * 
from s3('https://big-data-benchmark.s3.amazonaws.com/pavlo/text-deflate/1node/uservisits/*.deflate', 'CSV', 'sourceIP String,
    destinationURL String,
    visitDate Date,
    adRevenue Float32,
    UserAgent String,
    cCode FixedString(3),
    lCode FixedString(6),
    searchWord String,
    duration UInt32', 'deflate');
-------------------------------------------------Query----------------------------------------------------
SELECT pageURL, pageRank FROM rankings_1node WHERE pageRank > 1000;
SELECT substring(sourceIP, 1, 8), sum(adRevenue) FROM uservisits_1node GROUP BY substring(sourceIP, 1, 8);

SELECT
    sourceIP,
    sum(adRevenue) AS totalRevenue,
    avg(pageRank) AS pageRank
FROM rankings_1node ALL INNER JOIN
(
    SELECT
        sourceIP,
        destinationURL AS pageURL,
        adRevenue
    FROM uservisits_1node
    WHERE (visitDate > '1980-01-01') AND (visitDate < '1980-04-01')
) as uservisit 
USING pageURL
GROUP BY sourceIP
ORDER BY totalRevenue DESC
LIMIT 1;
