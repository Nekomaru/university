/*		TABLE CREATION		*/

CREATE TABLE cities(
	city VARCHAR(100) NOT NULL,
	country VARCHAR(100) NOT NULL,
	PRIMARY KEY(city)
);

CREATE TABLE owners(
	id INTEGER NOT NULL,
	name VARCHAR(100) NOT NULL,
	obtain_year INTEGER NOT NULL
		CHECK(obtain_year <= EXTRACT(YEAR FROM CURRENT_TIMESTAMP)),
	city VARCHAR(100) NOT NULL,
	PRIMARY KEY(id)
);

ALTER TABLE owners ADD CONSTANT C1
FOREIGN KEY (city) REFERENCES cities(city);

CREATE TABLE automobile_models(
	id INTEGER NOT NULL,
	name VARCHAR(100) NOT NULL,
	production_start_year INTEGER NOT NULL
		CHECK(production_start_year <= EXTRACT(YEAR FROM CURRENT_TIMESTAMP)),
	production_start_year INTEGER NOT NULL
		CHECK(production_start_year <= EXTRACT(YEAR FROM CURRENT_TIMESTAMP)),
	weight FLOAT NOT NULL
		CHECK(weight >= 0.5 && weight <= 10)
);

CREATE TABLE automobiles(
	license_plate VARCHAR(6) NOT NULL,
	owner_id INTEGER NOT NULL,
	model_id INTEGER NOT NULL,
	production_year INTEGER NOT NULL
		CHECK(production_year <= EXTRACT(YEAR FROM CURRENT_TIMESTAMP)),
	obtain_year INTEGER NOT NULL
		CHECK(obtain_year <= EXTRACT(YEAR FROM CURRENT_TIMESTAMP))
);


ALTER TABLE


/*		TABLE FILLING		*/