output "instances" {
  value = module.collator_nodes
}

output "collator_nodes_iam_role_id" {
  value = aws_iam_role.collator_nodes_iam_role.id
}
