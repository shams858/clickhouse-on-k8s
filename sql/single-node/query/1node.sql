-- Query 1 --
SELECT pageURL, pageRank FROM rankings_1node WHERE pageRank > 1000;
-- Query 2 --
SELECT substring(sourceIP, 1, 8), sum(adRevenue) FROM uservisits_1node GROUP BY substring(sourceIP, 1, 8);
-- Query 3 --
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
