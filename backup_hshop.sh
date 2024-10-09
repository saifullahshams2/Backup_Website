#!/bin/bash

#Backup files
# Variable
BACKUP_SRC="/var/www/hshop"
BACKUP_DST="/backup/hshop"
BACKUP_DATE=$(date +%Y-%m-%d_%H-%M)
BACKUP_FILENAME="hshop_$BACKUP_DATE.tar.gz"

#Arcive

mkdir -p "$BACKUP_DST/$BACKUP_DATE"

tar -czf "$BACKUP_DST/$BACKUP_DATE/$BACKUP_FILENAME" "$BACKUP_SRC"

# Backup Database
# MySQL database credentials
DB_USER="user"
DB_PASS="pass"
DB_NAME="name"

# # Backup directory
# BACKUP_DIR="$BACKUP_DST"

# # Date format for backup file
# DATE=$(date +"%Y%m%d_%H%M%S")

# Backup filename
BACKUP_FILE="$BACKUP_DST/$BACKUP_DATE/$DB_NAME-$BACKUP_DATE.sql.gz"

# Dump the MySQL database
mariadb-dump -u $DB_USER -p$DB_PASS $DB_NAME | gzip > $BACKUP_FILE

# Implement backup rotation to keep last 5 backups
KEEP=5
cd "$BACKUP_DST"
find . -maxdepth 1 -name "20*" -type d | sort -r | sed -e "1,${KEEP}d" | xargs rm -rf

if [ $? -eq 0 ]; then
    echo "Backup Successful: $BACKUP_FILENAME"
else
    echo "Backup Failed"
fi