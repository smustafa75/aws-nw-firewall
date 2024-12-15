output "private_instance" {
value = aws_instance.private_instance.id
#value = "${join(", ", aws_instance.hana_db01.id)}"
}