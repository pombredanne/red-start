# This script creates a compress database dump every time it runs. It also keep the old copies and deletes the ones that are older than the number of day established bit KEEP_FOR_N_DAYS.

DUMP_DIR="/backups/db_dumps" # Directory where the dumps are going to be store
FILE_PREFIX="" # Dump file prefix
KEEP_FOR_N_DAYS=10 # Number of days to keep the dump
DB_NAME = "" # Database name

if [ $DB_NAME == "" ]
then
    echo "ERROR: You need to specify the database name."
    exit 1
if

mkdir -p $DUMP_DIR


cd $DUMP_DIR

current_date=`date "+%Y-%m-%d"`

# Dumping the database
pg_dump -U postgres "$DB_NAME" > "$FILE_PREFIX-$current_date.sql"

# Compressing the dump file
tar -cf "$FILE_PREFIX-$current_date.tar" "$FILE_PREFIX-$current_date.sql"

# Deleting the dump file
rm "$FILE_PREFIX-$current_date.sql"

for ((i=$KEEP_FOR_N_DAYS; i<=$KEEP_FOR_N_DAYS*2; i++))
do
        file_date=`date "+%Y-%m-%d" --date="$i days ago"`
        if [ -f "$FILE_PREFIX-$file_date.tar" ]
        then
                rm "$FILE_PREFIX-$file_date.tar"
        fi
done