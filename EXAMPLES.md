# Bash Copilot Examples

This document contains practical examples of using Bash Copilot for various tasks.

## File Operations

### Finding Files

**What you type**: `find all python files modified in last 7 days`
**Ctrl+Space gives**: `find . -name "*.py" -mtime -7`

**What you type**: `find files larger than 100MB`
**Ctrl+Space gives**: `find . -type f -size +100M`

**What you type**: `find empty directories`
**Ctrl+Space gives**: `find . -type d -empty`

### File Manipulation

**What you type**: `rename all txt files to md`
**Ctrl+Space gives**: `for f in *.txt; do mv "$f" "${f%.txt}.md"; done`

**What you type**: `compress folder to tar.gz`
**Ctrl+Space gives**: `tar -czf archive.tar.gz folder/`

**What you type**: `extract tar.gz file`
**Ctrl+Space gives**: `tar -xzf archive.tar.gz`

## System Information

### Disk and Memory

**What you type**: `show disk usage human readable`
**Ctrl+Space gives**: `df -h`

**What you type**: `show largest directories`
**Ctrl+Space gives**: `du -h --max-depth=1 | sort -hr | head -10`

**What you type**: `show memory usage`
**Ctrl+Space gives**: `free -h`

### Process Management

**What you type**: `find process using port 8080`
**Ctrl+Space gives**: `lsof -i :8080`

**What you type**: `show top 10 memory consuming processes`
**Ctrl+Space gives**: `ps aux --sort=-%mem | head -11`

**What you type**: `kill all node processes`
**Ctrl+Space gives**: `pkill -f node`

## Network Operations

### Connectivity

**What you type**: `test connection to google`
**Ctrl+Space gives**: `ping -c 4 google.com`

**What you type**: `show all listening ports`
**Ctrl+Space gives**: `netstat -tuln | grep LISTEN`

**What you type**: `download file from url`
**Ctrl+Space gives**: `wget URL` or `curl -O URL`

### Network Information

**What you type**: `show my ip address`
**Ctrl+Space gives**: `ip addr show`

**What you type**: `show network connections`
**Ctrl+Space gives**: `netstat -an`

**What you type**: `trace route to google`
**Ctrl+Space gives**: `traceroute google.com`

## Git Operations

### Repository Management

**What you type**: `show git status`
**Ctrl+Space gives**: `git status`

**What you type**: `create new branch`
**Ctrl+Space gives**: `git checkout -b branch-name`

**What you type**: `undo last commit keep changes`
**Ctrl+Space gives**: `git reset --soft HEAD~1`

### Git History

**What you type**: `show commit history with graph`
**Ctrl+Space gives**: `git log --graph --oneline --all`

**What you type**: `show files changed in last commit`
**Ctrl+Space gives**: `git diff HEAD~1 HEAD --name-only`

**What you type**: `find commits by author`
**Ctrl+Space gives**: `git log --author="author-name"`

## Text Processing

### Search and Replace

**What you type**: `find all files containing text`
**Ctrl+Space gives**: `grep -r "search-text" .`

**What you type**: `replace text in all files`
**Ctrl+Space gives**: `find . -type f -exec sed -i 's/old/new/g' {} +`

**What you type**: `count lines in all python files`
**Ctrl+Space gives**: `find . -name "*.py" -exec wc -l {} + | tail -1`

### File Content

**What you type**: `show first 10 lines of file`
**Ctrl+Space gives**: `head -10 filename`

**What you type**: `show last 20 lines of log file`
**Ctrl+Space gives**: `tail -20 logfile.log`

**What you type**: `follow log file in real time`
**Ctrl+Space gives**: `tail -f logfile.log`

## Docker Operations

### Container Management

**What you type**: `list all running containers`
**Ctrl+Space gives**: `docker ps`

**What you type**: `stop all containers`
**Ctrl+Space gives**: `docker stop $(docker ps -q)`

**What you type**: `remove all stopped containers`
**Ctrl+Space gives**: `docker container prune -f`

### Images

**What you type**: `list all docker images`
**Ctrl+Space gives**: `docker images`

**What you type**: `remove unused images`
**Ctrl+Space gives**: `docker image prune -a`

**What you type**: `build docker image`
**Ctrl+Space gives**: `docker build -t image-name .`

## Database Operations

### MySQL

**What you type**: `connect to mysql database`
**Ctrl+Space gives**: `mysql -u username -p database_name`

**What you type**: `dump mysql database`
**Ctrl+Space gives**: `mysqldump -u username -p database_name > backup.sql`

**What you type**: `import mysql dump`
**Ctrl+Space gives**: `mysql -u username -p database_name < backup.sql`

### PostgreSQL

**What you type**: `connect to postgres database`
**Ctrl+Space gives**: `psql -U username -d database_name`

**What you type**: `dump postgres database`
**Ctrl+Space gives**: `pg_dump -U username database_name > backup.sql`

## System Monitoring

### Resource Usage

**What you type**: `show real time system stats`
**Ctrl+Space gives**: `top` or `htop`

**What you type**: `show io statistics`
**Ctrl+Space gives**: `iostat -x 1`

**What you type**: `check system load`
**Ctrl+Space gives**: `uptime`

### Logs

**What you type**: `show system logs`
**Ctrl+Space gives**: `journalctl -xe`

**What you type**: `show auth log`
**Ctrl+Space gives**: `tail -f /var/log/auth.log`

**What you type**: `show errors from syslog`
**Ctrl+Space gives**: `grep -i error /var/log/syslog`

## Package Management

### APT (Debian/Ubuntu)

**What you type**: `update package list`
**Ctrl+Space gives**: `sudo apt update`

**What you type**: `upgrade all packages`
**Ctrl+Space gives**: `sudo apt upgrade -y`

**What you type**: `search for package`
**Ctrl+Space gives**: `apt search package-name`

### YUM/DNF (RedHat/Fedora)

**What you type**: `install package with yum`
**Ctrl+Space gives**: `sudo yum install package-name`

**What you type**: `list installed packages`
**Ctrl+Space gives**: `yum list installed`

## Archive Operations

### Creating Archives

**What you type**: `create zip archive`
**Ctrl+Space gives**: `zip -r archive.zip folder/`

**What you type**: `create tar archive`
**Ctrl+Space gives**: `tar -czf archive.tar.gz folder/`

**What you type**: `create encrypted archive`
**Ctrl+Space gives**: `tar -czf - folder/ | gpg -c > archive.tar.gz.gpg`

### Extracting Archives

**What you type**: `extract zip file`
**Ctrl+Space gives**: `unzip archive.zip`

**What you type**: `extract tar.bz2 file`
**Ctrl+Space gives**: `tar -xjf archive.tar.bz2`

**What you type**: `list contents of tar file`
**Ctrl+Space gives**: `tar -tzf archive.tar.gz`

## Security and Permissions

### File Permissions

**What you type**: `make file executable`
**Ctrl+Space gives**: `chmod +x filename`

**What you type**: `change owner of directory recursively`
**Ctrl+Space gives**: `sudo chown -R user:group directory/`

**What you type**: `find files with 777 permissions`
**Ctrl+Space gives**: `find . -type f -perm 0777`

### SSH

**What you type**: `generate ssh key`
**Ctrl+Space gives**: `ssh-keygen -t rsa -b 4096`

**What you type**: `copy ssh key to server`
**Ctrl+Space gives**: `ssh-copy-id user@host`

**What you type**: `connect via ssh with key`
**Ctrl+Space gives**: `ssh -i keyfile user@host`

## Advanced Examples

### Complex Pipeline

**What you type**: `find largest files in home directory`
**Ctrl+Space gives**: `find ~ -type f -exec du -h {} + | sort -rh | head -20`

**What you type**: `count unique ips in access log`
**Ctrl+Space gives**: `awk '{print $1}' access.log | sort | uniq -c | sort -rn`

**What you type**: `monitor network traffic on interface`
**Ctrl+Space gives**: `sudo tcpdump -i eth0 -n`

### System Administration

**What you type**: `create new user with home directory`
**Ctrl+Space gives**: `sudo useradd -m -s /bin/bash username`

**What you type**: `schedule cron job to run daily`
**Ctrl+Space gives**: `crontab -e` (then add: `0 0 * * * /path/to/script`)

**What you type**: `check disk health`
**Ctrl+Space gives**: `sudo smartctl -a /dev/sda`

---

**Tips:**
- Be specific in your descriptions for better results
- Include context like file types, time ranges, or specific criteria
- Combine multiple operations in your description
- Review generated commands before executing

**Note:** The actual completions may vary based on the AI model and context. Always review commands before executing, especially those that modify or delete data.
