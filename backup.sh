MYSQL_SERVER="127.0.0.1"
MYSQL_USER="root"
MYSQL_PASS="h|+Y%6pXb|z^Qz7US"
SSH_SERVER="kiteware.com"
SSH_USER="root"

NOW=$(date +"%Y.%m.%d")

echo "Select which folder you would like to back up: "
read backup_folder

if [ ! -f "$backup_folder.tar" ]; then
        echo "Transferring files..."
        # Compress the target directory
        tar -cvf "$backup_folder.tar" "/home/$backup_folder"
fi


echo "Do you wish to transfer a database?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) make install;
        echo "Which database would you like to backup?"
        read mysql_database
        echo "transfering database..."
        # Backup MySQL Databases
        mysqldump -u $MYSQL_USER -h $MYSQL_SERVER -p$MYSQL_PASS $mysql_database > "$NOW-$mysql_database.sql"
        tar -cvf "$NOW-$mysql_database.tar" "$NOW-$mysql_database.sql"
        # Send file via scp
        scp "$NOW-$MYSQL_DATABASE.tar" "$backup_folder.tar" "$SSH_USER@$SSH_SERVER:~/"
        break;;
        No )
        # Send file via scp
        scp "$backup_folder.tar" "$SSH_USER@$SSH_SERVER:~/"
        break;;
    esac
done

echo "Done backing up"
