output "hana_db01_id" {
value = aws_instance.hana_db01.id
#value = "${join(", ", aws_instance.hana_db01.id)}"
}
output "hana_db02_id" {
value = aws_instance.hana_db02.id
#value = "${join(", ", aws_instance.hana_db01.id)}"
}

