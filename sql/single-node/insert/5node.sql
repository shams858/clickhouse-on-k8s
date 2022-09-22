INSERT INTO rankings_5nodes_on_single
SELECT * 
FROM s3('https://big-data-benchmark.s3.amazonaws.com/pavlo/text-deflate/5nodes/rankings/*.deflate', 
    'CSV', 'pageURL String, pageRank UInt32, avgDuration UInt32', 'deflate') 
    SETTINGS max_threads=8, max_insert_threads=8, input_format_parallel_parsing=0;
    
INSERT INTO uservisits_5nodes_on_single
select * 
from s3('https://big-data-benchmark.s3.amazonaws.com/pavlo/text-deflate/5nodes/uservisits/*.deflate', 'CSV', 'sourceIP String,
    destinationURL String,
    visitDate Date,
    adRevenue Float32,
    UserAgent String,
    cCode FixedString(3),
    lCode FixedString(6),
    searchWord String,
    duration UInt32', 'deflate') SETTINGS max_threads=8, max_insert_threads=8, input_format_parallel_parsing=0;

