resource "aws_eks_node_group" "webapp_node_group" {
  cluster_name    = aws_eks_cluster.webapp.name
  node_group_name = "webapp_node_group"
  node_role_arn   = aws_iam_role.AmazonEKSNodeRole.arn
  subnet_ids      = [aws_subnet.subnet-public-1.id, aws_subnet.subnet-public-2.id]
  instance_types  = ["t2.medium"]

  scaling_config {
    desired_size = 4
    max_size     = 5
    min_size     = 2
  }

  update_config {
    max_unavailable = 2
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [aws_iam_role.AmazonEKSNodeRole]
}