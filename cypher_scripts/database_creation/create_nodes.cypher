//create_nodes

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/lucasnijder/2AMD20-group19/main/2_preprocessed_data/EnergyUsage.csv' AS row
WITH row.Gemeentenaam AS Gemeentenaam, toFloat(row.GemiddeldAardgasverbruik) AS GemiddeldAardgasverbruik, toFloat(row.GemiddeldElektriciteitsverbruik) AS GemiddeldElektriciteitsverbruik
MERGE (g:Municipality {name: Gemeentenaam})
    ON CREATE SET 
        g.avgNaturalGasUsage = GemiddeldAardgasverbruik,
        g.avgElectricityUsage = GemiddeldElektriciteitsverbruik
    ON MATCH SET 
        g.avgNaturalGasUsage = GemiddeldAardgasverbruik,
        g.avgElectricityUsage = GemiddeldElektriciteitsverbruik;


LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/lucasnijder/2AMD20-group19/main/2_preprocessed_data/InhabitantsMunicipality.csv' AS row
WITH row.Gemeentenaam AS Gemeentenaam, toInteger(row.Inwoneraantal) AS Inwoneraantal
MERGE (g:Municipality {name: Gemeentenaam})
    SET g.population = Inwoneraantal;

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/lucasnijder/2AMD20-group19/main/2_preprocessed_data/Municipalities.csv' AS row
WITH row.Gemeentenaam AS Gemeentenaam, row.Provincienaam AS Provincienaam, toInteger(row.Gemeentecode) AS Gemeentecode
MERGE (g:Municipality {name: Gemeentenaam})
    SET g.municipalityCode = Gemeentecode
MERGE (p:Province {name: Provincienaam});
   

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/lucasnijder/2AMD20-group19/main/2_preprocessed_data/Sun.csv' AS row
WITH toUpper(row.Gemeentenaam) AS Gemeentenaam, toInteger(row.AantalInstallatiesBijWoningen) AS AantalInstallatiesBijWoningen,
toInteger(row.OpgesteldVermogenVanZonnepanelen) AS OpgesteldVermogenVanZonnepanelen
MERGE (g:Municipality {name: Gemeentenaam})
    ON CREATE SET 
        g.homeInstallations = AantalInstallatiesBijWoningen,
        g.installedCapacitySolarPanels = OpgesteldVermogenVanZonnepanelen
    ON MATCH SET 
        g.homeInstallations = AantalInstallatiesBijWoningen,
        g.installedCapacitySolarPanels = OpgesteldVermogenVanZonnepanelen;


LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/lucasnijder/2AMD20-group19/main/2_preprocessed_data/TotaalWeerStation.csv' AS row
WITH row.WeerStation AS WeerStation, toFloat(row.pctzon_gemiddeld) AS PctZonGemiddeld,
toFloat(row.FG_gemiddeld) AS FGGemiddeld
MERGE (w:WeatherStation {name: WeerStation})
    ON CREATE SET 
        w.avgPctSunPerDay = PctZonGemiddeld,
        w.avgWindSpeed =  FGGemiddeld
    ON MATCH SET 
        w.avgPctSunPerDay = PctZonGemiddeld,
        w.avgWindSpeed =  FGGemiddeld;


LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/lucasnijder/2AMD20-group19/main/2_preprocessed_data/WindEnergie.csv' AS row
WITH row.Regio AS Provincienaam, toFloat(replace(row.`Elektriciteitsproductie/Productiefactor (%)`, ",", ".")) AS ProductieFactor, toFloat(row.`Elektriciteitsproductie/Genormaliseerde productie (mln kWh)`) AS Elektriciteitsproductie
MERGE (p:Province {name: Provincienaam})
    ON CREATE SET 
        p.productionFactor = ProductieFactor,
        p.electricityProduction =  Elektriciteitsproductie
    ON MATCH SET 
        p.productionFactor = ProductieFactor,
        p.electricityProduction =  Elektriciteitsproductie;

:auto USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/lucasnijder/2AMD20-group19/main/2_preprocessed_data/postcodeMunicipality.csv' AS row
WITH toInteger(row.Gemeentecode) AS Gemeentecode, trim(row.Postcode) AS Postcode
MERGE (g:Municipality {municipalityCode: Gemeentecode})
  ON CREATE SET g.postalCodes = [Postcode]
  ON MATCH SET g.postalCodes = CASE WHEN NOT EXISTS(g.postalCodes)
    THEN [Postcode]
    ELSE g.postalCodes + [Postcode] END;

LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/lucasnijder/2AMD20-group19/main/2_preprocessed_data/Restrictions.csv' AS row
WITH row.EnergieStation AS EnergieStation, row.Kleur AS Kleur, row.Postcode AS Postcode
MERGE (e:EnergyStation {name: EnergieStation})
    SET e.postalCode = Postcode
MERGE (d:DeliveryOptions {colour: Kleur});








