//clear_database
// clear nodes and relationships
CALL apoc.periodic.iterate('MATCH (n) RETURN n', 'DETACH DELETE n', {batchSize:1000, iterateList:true});
// clear indexes and constraints
CALL apoc.schema.assert({}, {});