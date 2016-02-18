variable name { }
variable description { default = "" }
variable subnet_ids { }

resource "aws_db_subnet_group" "default" {
    name = "${var.name}"
    description = "${var.description}"
    subnet_ids = ["${split(",", var.subnet_ids)}"]
    tags {
        Name = "${var.name}"
    }
}

output "id" { value = "aws_db_subnet_group.default.id}" }
output "arn" { value = "aws_db_subnet_group.default.arn}" }
