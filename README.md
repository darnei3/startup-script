# startup-script
A simple script to run the application locally or via ssh.

You just need the following variables to your own:
1. name="demo-0.0.1.jar" - Name of your JAR
2. basedir="/home/dev/demo" - The directory for your JAR
3. backupdir="/home/dev/demo/backup" - The directory where you want to save the JAR backup before updating
4. downloadurl="http://HOST:PORT/REPOSITORYPATH/0.0.1/demo-0.0.1.jar" - The url of your repository for the JAR download

You can use this script as follows:
1. (sudo) bash start.sh download - Downloads the JAR to the base directory at the specified URL
2. (sudo) bash start.sh start - Launches your application
3. (sudo) bash start.sh restart - Restarts your application
4. (sudo) bash start.sh status - Displays the current status of the application: Running/Not running
5. (sudo) bash start.sh stop - Stops your application
6. (sudo) bash start.sh backup - Allows you to make a backup copy of the JAR and put it into a directory named by the current time (Year-Month-Day-Hour-Minute)
7. (sudo) bash start.sh update - The update stops the current JAR, backs it up, replaces the current JAR with the file from the repository, and then runs it


