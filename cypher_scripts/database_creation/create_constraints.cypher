//constraints
CREATE CONSTRAINT UniqueMunicipality ON (g:Municipality) ASSERT g.name IS UNIQUE;
CREATE CONSTRAINT UniqueWeatherStation ON (w:WeatherStation) ASSERT w.name IS UNIQUE;
CREATE CONSTRAINT UniqueProvince ON (p:Province) ASSERT p.name IS UNIQUE;
CREATE CONSTRAINT UniqueEnergieStation ON (e:EnergyStation) ASSERT e.name IS UNIQUE;