//create_relationships

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/lucasnijder/2AMD20-group19/main/2_preprocessed_data/Municipalities.csv' AS row
WITH row.Gemeentenaam AS Gemeentenaam, row.Provincienaam AS Provincienaam
MATCH (g:Municipality {name: Gemeentenaam})
MATCH (p:Province {name: Provincienaam})
MERGE (g)-[:LIES_IN]->(p);

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/lucasnijder/2AMD20-group19/main/2_preprocessed_data/Restrictions.csv' AS row
WITH row.EnergieStation AS EnergieStation, row.Kleur AS Kleur
MATCH (e:EnergyStation {name: EnergieStation})
MATCH (d:DeliveryOptions {colour: Kleur})
MERGE (e)-[:SUPPORTS]->(d);

CALL apoc.periodic.iterate(
"MATCH (g:Municipality) RETURN g",
"MATCH (e:EnergyStation) WHERE e.postalCode IN g.postalCodes MERGE (e)-[:IS_LOCATED_IN]->(g)",
{batchSize:100, parallel:true});

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/lucasnijder/2AMD20-group19/main/2_preprocessed_data/gem_weer_distances.csv' AS row
WITH row.Gemeentenaam AS Gemeentenaam, row.WeerStation AS WeerStation, toFloat(row.distance) as Distance
WHERE Distance <=30
MATCH (g:Municipality {name: Gemeentenaam})
MATCH (w:WeatherStation {name: WeerStation})
MERGE (g)-[d:DISTANCE_TO]->(w)
    SET d.distance = Distance;