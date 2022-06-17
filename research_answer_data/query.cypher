MATCH (g:Municipality)<-[:IS_LOCATED_IN]-(e:EnergyStation)-[:SUPPORTS]->(d:DeliveryOptions)
WITH (g.installedCapacitySolarPanels - (g.avgElectricityUsage)) AS DifferenceProductionConsumption, g.name AS Municipality
WHERE d.colour <> 'ROOD' 
RETURN DISTINCT Municipality, DifferenceProductionConsumption ORDER BY DifferenceProductionConsumption  LIMIT 5;
