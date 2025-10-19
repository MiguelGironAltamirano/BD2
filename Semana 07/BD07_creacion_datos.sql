-- Tabla SUPPLIERS
CREATE TABLE suppliers (
    id_supplier CHAR(2) PRIMARY KEY,
    supplier_name VARCHAR2(40),
    status NUMBER(2),
    city VARCHAR2(40)
);

-- Tabla PARTS
CREATE TABLE parts (
    id_part CHAR(2) PRIMARY KEY,
    part_name VARCHAR2(40),
    color VARCHAR2(20),
    weight NUMBER(4),
    city VARCHAR2(40)
);

-- Tabla SP (envíos)
CREATE TABLE sp (
    id_supplier CHAR(2),
    id_part CHAR(2),
    qty NUMBER,
    CONSTRAINT pk_sp PRIMARY KEY (id_supplier, id_part),
    CONSTRAINT fk_sp_supplier FOREIGN KEY (id_supplier) REFERENCES suppliers(id_supplier),
    CONSTRAINT fk_sp_part FOREIGN KEY (id_part) REFERENCES parts(id_part)
);

-- Tabla PROJECTS
CREATE TABLE projects (
    id_project CHAR(2) PRIMARY KEY,
    project_name VARCHAR2(40),
    city VARCHAR2(40)
);

-- Tabla SPJ (envíos a proyectos)
CREATE TABLE spj (
    id_supplier CHAR(2),
    id_part CHAR(2),
    id_project CHAR(2),
    qty NUMBER,
    CONSTRAINT pk_spj PRIMARY KEY (id_supplier, id_part, id_project),
    CONSTRAINT fk_spj_supplier FOREIGN KEY (id_supplier) REFERENCES suppliers(id_supplier),
    CONSTRAINT fk_spj_part FOREIGN KEY (id_part) REFERENCES parts(id_part),
    CONSTRAINT fk_spj_project FOREIGN KEY (id_project) REFERENCES projects(id_project)
);

INSERT INTO suppliers VALUES ('S1', 'Smith', 20, 'London');
INSERT INTO suppliers VALUES ('S2', 'Jones', 10, 'Paris');
INSERT INTO suppliers VALUES ('S3', 'Blake', 30, 'Paris');
INSERT INTO suppliers VALUES ('S4', 'Clark', 20, 'London');
INSERT INTO suppliers VALUES ('S5', 'Adams', 30, 'Athens');

INSERT INTO parts VALUES ('P1', 'Nut', 'Red', 12, 'London');
INSERT INTO parts VALUES ('P2', 'Bolt', 'Green', 17, 'Paris');
INSERT INTO parts VALUES ('P3', 'Screw', 'Blue', 17, 'Rome');
INSERT INTO parts VALUES ('P4', 'Screw', 'Red', 14, 'London');
INSERT INTO parts VALUES ('P5', 'Cam', 'Blue', 12, 'Paris');
INSERT INTO parts VALUES ('P6', 'Cog', 'Red', 19, 'London');
