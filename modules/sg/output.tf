output "sg_nlb"{
    value = aws_security_group.sg_nlb.id
}
output "sg_ec2"{
    value = aws_security_group.sg_ec2.id
}
output "sg_db"{
    value = aws_security_group.sg_db.id
}
output "sg_ssm"{
      value = aws_security_group.sg_ssm.id

}