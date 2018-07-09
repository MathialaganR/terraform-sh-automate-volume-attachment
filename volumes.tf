resource "aws_ebs_volume" "elasticsearch_master" {
    count = 3
    availability_zone = "${lookup(var.azs, count.index)}"
    size = 8
    type = "gp2"
    tags {
        Name = "elasticsearch_master_az${count.index}.${var.env_name}"
    }
}

resource "template_file" "elasticsearch_mount_vol_sh" {
    filename = "${path.module}/elasticsearch_mount_vol.sh"
    count = 3
    vars {
        volume_id = "${element(aws_ebs_volume.elasticsearch_master.*.id, count.index)}"
        lsblk_name = "xvdf"
        device_name = "/dev/xvdf"
        mount_point = "/esvolume"
    }
}
