# moving-colddata-to-huaweicloud
Move cold data from the standard OBS bucket on OREL Cloud to the Archive OBS bucket on Huawei Cloud.

**Step 1**
Create a standard OBS bucket on OREL Cloud.
Create a archieve OBS bucket on Huawei Cloud.

**Step 2**
Create a ECS on OREL Cloud.

Install s3fs on your Linux ECS.
    sudo apt-get update
    sudo apt-get install -y s3fs

Create a credentials file
    echo "ACCESS_KEY_ID:SECRET_ACCESS_KEY" > ~/.passwd-s3fs
    chmod 600 ~/.passwd-s3fs

Mount OBS Buckets
    s3fs my-standard-bucket /mnt/standard-bucket \
    -o url=https://obs.{region-id}.myhuaweicloud.com \
    -o passwd_file=~/.passwd-s3fs \
    -o use_path_request_style \
    -o allow_other \
    -o umask=000
    
For Automatic Mounting at Boot (Add to /etc/fstab)
    s3fs#my-standard-bucket /mnt/standard-bucket fuse _netdev,url=https://obs.{region-id}.myhuaweicloud.com,passwd_file=/home/ubuntu/.passwd-s3fs,use_path_request_style,allow_other,umask=000 0 0
    s3fs#my-archive-bucket /mnt/archive-bucket fuse _netdev,url=https://obs.{region-id}.myhuaweicloud.com,passwd_file=/home/ubuntu/.passwd-s3fs,use_path_request_style,allow_other,umask=000 0 0

Create script (to move files older than 5 mins)
  vim obs_archiver.sh 
  chmod +x obs_archiver.sh

For Cron (to run every 5 mins)
  (crontab -l 2>/dev/null; echo "*/5 * * * * /path/to/simple_archiver.sh >> /var/log/archiver.log 2>&1") | crontab -


