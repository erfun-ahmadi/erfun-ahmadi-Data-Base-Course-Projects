CREATE TABLE Employee (
    eid INTEGER,
    name CHAR(20),
    age INTEGER,
    phone INTEGER,
    salary INTEGER,
    PRIMARY KEY (eid)
);

CREATE TABLE Technician (
    eid INTEGER,
    expertise CHAR(20),
    PRIMARY KEY (eid),
    FOREIGN KEY (eid)
        REFERENCES Employee (eid)
        ON DELETE CASCADE
);

CREATE TABLE FlightTeam (
    eid INTEGER,
    responsibility CHAR(20),
    PRIMARY KEY (eid),
    FOREIGN KEY (eid)
        REFERENCES Employee(eid)
        ON DELETE CASCADE
);

CREATE TABLE Catering (
	cid INTEGER,
    cost INTEGER,
    model CHAR(20),
    PRIMARY KEY (cid)
);

CREATE TABLE Airplane (
    aid INTEGER,
    weight INTEGER,
    capacity INTEGER,
    model CHAR(20),
    responsibility INTEGER NOT NULL,
    cid INTEGER, 
    PRIMARY KEY (aid),
    FOREIGN KEY (responsibility)
        REFERENCES Employee (eid)
        ON DELETE NO ACTION,
	FOREIGN KEY (cid)
        REFERENCES Catering (cid)
        ON DELETE SET NULL
);

CREATE TABLE Report (
    rid INTEGER,
    aid INTEGER NOT NULL,
    eid INTEGER NOT NULL,
    PRIMARY KEY (rid, aid),
    FOREIGN KEY (aid)
        REFERENCES Airplane (aid)
        ON DELETE CASCADE,
    FOREIGN KEY (eid)
        REFERENCES Employee (eid)
        ON DELETE NO ACTION
);

CREATE TABLE Traveler (
    national_code INTEGER,
    nationality CHAR(20),
    name CHAR(20),
    age INTEGER,
    PRIMARY KEY (national_code)
);

CREATE TABLE Flight (
	fid INTEGER,
    traveler_national_code INTEGER,
    aid INTEGER NOT NULL,
    eid INTEGER NOT NULL,
    PRIMARY KEY (fid, traveler_national_code),
    FOREIGN KEY (traveler_national_code)
        REFERENCES Traveler (national_code)
        ON DELETE NO ACTION,
    FOREIGN KEY (aid)
        REFERENCES Airplane (aid)
        ON DELETE NO ACTION,
    FOREIGN KEY (eid)
        REFERENCES Employee (eid)
        ON DELETE NO ACTION
);
