# Sports Stats Utilities
Scripts/Binaries used to fetch, load or work with sport related stats
=======

## Generating Data Structures
The data structures are generated by reading the [Baseball Databank](https://github.com/chadwickbureau/baseballdatabank) CSV files and creating a language specific structure that maps to each of the CSV files. Currently only Go data structures are supported but in the future I will add others as I need them. If there is a particular language you would like to see you can create an issue or even better, submit a pull request.

### create_data_structures.py
  ```
usage: create_data_structures.py [-h] [--bson] [--csv] [--db] [--input INPUT]
                                 [--input-dir INPUT_DIR] [--json] [--package]
                                 --language {go} [--name NAME]
                                 [--output-dir OUTPUT_DIR] [--verbose]

Generate language specific data structures that model each of the Baseball
Databank CSV files.

optional arguments:
  -h, --help            show this help message and exit
  --bson                If the language supports add bson tags or bson
                        representation to the structure
  --csv                 If the language supports add CSV tags or CSV
                        representation to the structure
  --db                  adds db tags to Go structs.
  --input INPUT         the path to the input CSV file
  --input-dir INPUT_DIR
                        the path to the directory that contains the CSV files
                        to parse
  --json                If the language supports add JSON tags or JSON
                        representation to the structure
  --package             sets the package to the correct name for Go structs
  --language {go}       create language specific data structures
  --name NAME           name of the data structure being created
  --output-dir OUTPUT_DIR
                        the directory where the generated file should be
                        written. If not provided file will be written to
                        stdout
  --verbose             more output during the parsing and creation of the
                        data structures
```

Before running this script you will need to have already downloaded the [Baseball Databank](https://github.com/chadwickbureau/baseballdatabank) repository and installed the Python `inflection` package by running `pip install inflection`.  The next step is to change into the the `scripts/generate-code`.  I used the following command to generate the data structures that are in this repository.

`python create_data_structures.py --language go --csv --db --json --input-dir ~/src/baseballdatabank/core --package --output-dir ../../pkg/bd/models`

Required parameters: 
 - `--language` Since Go is the only supported language at the moment so if `--language` is not given it defaults to Go.
 - `--input` or `--input-dir`.  The first option takes a path to a single csv file and the second option takes a path to a directory of CSV files.

Optional parameters:
- `--name` The value of this parameter will be used to name the data structure that is being created for the file provided in the `--input` parameter
- `--output-dir` Where the newly created files will be stored. If this parameter is not used the output will be written to stdout
- `--verbose`.  

#### Go specific command line options

There following arguments depend on language support `--bson`, `--csv`, `--db`, and `--json`. If any of the `--csv`, `--db`, and `--json` flags are used the generated structs will contain the `csv`, `db` and/or `json` tags.


## Building the databases yourself
_I used the following script to generate the original database schema but have since started updating the schema files to make any changes I needed to make.  You can use this script to build the database if you wish but __I would suggest using either the the schema files or the backups__.  In the future I plan on moving the database generation process out of python and into a language that does not require installation of packages or modules._ 

Before running the database script you will need to install `peewee`. Peewee is what creates the tables and other schema related requirements.  To install `peewee` run the following:

```
pip install peewee
```

### create_database_schema.py
Order of the data structure creation and schema script doesn't really matter but I typically create the schema after creating the structures.  Create the schema is as simple as running `python create_database_schema.py`.  The script lives in the `scripts/create-database` directory and has the options listed below.

```
usage: create_database_schema.py [-h] --dbtype {mysql,postgres,sqlite}
                                 [--dbhost DBHOST] [--dbname DBNAME]
                                 [--dbpath DBPATH] [--dbpass DBPASS]
                                 [--dbport DBPORT] [--dbuser DBUSER]

Generates a DB schema based on the Baseball Databank csv files.

optional arguments:
  -h, --help            show this help message and exit
  --dbtype {mysql,postgres,sqlite}
                        the database type you'd like to generate the schema
                        for
  --dbhost DBHOST       host of the database server
  --dbname DBNAME       Name of the database where the tables are to be added.
                        REQUIRED if not sqlite
  --dbpath DBPATH       SQLITE ONLY - the path for the newly created database
  --dbpass DBPASS       The password for the user given in the --dbuser
                        option, ignored for SQLite
  --dbport DBPORT       The port the database server is listening on, ignored
                        for SQLite, defaults to appropriate value for server
                        type if not provided
  --dbuser DBUSER       username to use when creating the database, ignored
                        for SQLite databases, REQUIRED for others.
  ```

Before you can use this script you will need to have already created the database in Postgres.  In future versions the database will be created for you.

#### Creating the Schema in a SQLite DB
`python create_database_schema.py --dbtype sqlite --dbpath ./baseball_database_db.py`

For SQLite any of the other command line arguments given besides the two used above will be ignored

#### Creating the Schema in a Postgres DB
`python create_database_schema.py --dbtype postgres --dbname baseballdatabank --dbuser myusername --dbpass mypassword`

For PostgreSQL if `--dbport` is not given the default port 5432 is used. 

After creating the schema you will have a db with a matching table for each of the CSV files