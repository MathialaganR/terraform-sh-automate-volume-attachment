resource "aws_instance" "elasticsearch_master" {
    count = 3
    ...
    user_data = <<SCRIPT
#!/bin/bash

# Attach and Mount ES EBS volume
${element(template_file.elasticsearch_mount_vol_sh.*.rendered, count.index)}

SCRIPT
}
