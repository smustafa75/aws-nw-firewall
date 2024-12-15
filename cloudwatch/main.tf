resource "aws_cloudwatch_metric_alarm" "hana01_cpu" {
     alarm_name                = "hana01-cpu-utilization"
     comparison_operator       = "GreaterThanOrEqualToThreshold"
     evaluation_periods        = "2"
     metric_name               = "CPUUtilization"
     namespace                 = "AWS/EC2"
     period                    = "120" #seconds
     statistic                 = "Average"
     threshold                 = "80"
     alarm_description         = "CPU Utilization for HANA01"
     insufficient_data_actions = []
     alarm_actions=[]

dimensions = {
       InstanceId = var.hana_db01
     }
}
resource "aws_cloudwatch_metric_alarm" "hana01_disk" {
     alarm_name                = "hana01-disk-utilization"
     comparison_operator       = "GreaterThanOrEqualToThreshold"
     evaluation_periods        = "2"
     metric_name               = "disk_used_percent"
     namespace                 = "AWS/EC2"
     period                    = "120" #seconds
     statistic                 = "Average"
     threshold                 = "60"
     alarm_description         = "Disk Utilization for HANA01"
     insufficient_data_actions = []
     alarm_actions=[]
     
dimensions = {
       InstanceId = var.hana_db01
     }
}
resource "aws_cloudwatch_metric_alarm" "hana01_mem" {
     alarm_name                = "hana01-mem-utilization"
     comparison_operator       = "GreaterThanOrEqualToThreshold"
     evaluation_periods        = "2"
     metric_name               = "mem_used"
     namespace                 = "AWS/EC2"
     period                    = "120" #seconds
     statistic                 = "Average"
     threshold                 = "60"
     alarm_description         = "Memory Utilization for HANA01"
     insufficient_data_actions = []
     alarm_actions=[]
     
dimensions = {
       InstanceId = var.hana_db01
     }
}



resource "aws_cloudwatch_metric_alarm" "hana02_cpu" {
     alarm_name                = "hana02-cpu-utilization"
     comparison_operator       = "GreaterThanOrEqualToThreshold"
     evaluation_periods        = "2"
     metric_name               = "CPUUtilization"
     namespace                 = "AWS/EC2"
     period                    = "120" #seconds
     statistic                 = "Average"
     threshold                 = "80"
     alarm_description         = "CPU Utilization for HANA01"
     insufficient_data_actions = []
     alarm_actions=[]

dimensions = {
       InstanceId = var.hana_db02
     }
}
resource "aws_cloudwatch_metric_alarm" "hana02_disk" {
     alarm_name                = "hana02-disk-utilization"
     comparison_operator       = "GreaterThanOrEqualToThreshold"
     evaluation_periods        = "2"
     metric_name               = "disk_used_percent"
     namespace                 = "AWS/EC2"
     period                    = "120" #seconds
     statistic                 = "Average"
     threshold                 = "60"
     alarm_description         = "Disk Utilization for HANA01"
     insufficient_data_actions = []
     alarm_actions=[]
     
dimensions = {
       InstanceId = var.hana_db02
     }
}
resource "aws_cloudwatch_metric_alarm" "hana02_mem" {
     alarm_name                = "hana02-mem-utilization"
     comparison_operator       = "GreaterThanOrEqualToThreshold"
     evaluation_periods        = "2"
     metric_name               = "mem_used"
     namespace                 = "AWS/EC2"
     period                    = "120" #seconds
     statistic                 = "Average"
     threshold                 = "60"
     alarm_description         = "Memory Utilization for HANA01"
     insufficient_data_actions = []
     alarm_actions=[]
     
dimensions = {
       InstanceId = var.hana_db02
     }
}