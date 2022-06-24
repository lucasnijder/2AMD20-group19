MATCH (g:Municipality)
WITH ((g.homeInstallations*300) - ((g.population/2.14)*(g.avgElectricityUsage+(10.2*g.avgNaturalGasUsage))))/g.population AS DifferenceProductionConsumption, g.name AS Municipality
RETURN DISTINCT Municipality, DifferenceProductionConsumption ORDER BY DifferenceProductionConsumption  LIMIT 5;