INSTANCE_ID=`curl http://169.254.169.254/latest/meta-data/instance-id`

# wait for ebs volume to be attached
while :
do
    # self-attach ebs volume
    aws --region us-east-1 ec2 attach-volume --volume-id ${volume_id} --instance-id $INSTANCE_ID --device ${device_name}

    if lsblk | grep ${lsblk_name}; then
        echo "attached"
        break
    else
        sleep 5
    fi
done

# create fs if needed
if file -s ${device_name} | grep "${device_name}: data"; then
    echo "creating fs"
    mkfs -t ext4 ${device_name}
fi

# mount it
mkdir ${mount_point}
echo "${device_name}       ${mount_point}   ext4    defaults,nofail  0 2" >> /etc/fstab
echo "mounting"
mount -a
