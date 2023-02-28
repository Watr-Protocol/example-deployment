output "target_attachment_ids" {
  value = [for attachment in aws_lb_target_group_attachment.nodes_target_group_attachment : attachment.target_id]
}
