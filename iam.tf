

# Create IAM groups
resource "aws_iam_group" "update_group1" {
  name = "UpdateGroup1"
}

resource "aws_iam_group" "update_group2" {
  name = "UpdateGroup2"
}

resource "aws_iam_group" "update_group3" {
  name = "UpdateGroup3"
}

resource "aws_iam_group" "read_group1" {
  name = "ReadGroup1"
}

resource "aws_iam_group" "read_group2" {
  name = "ReadGroup2"
}

# Create IAM policies
data "aws_iam_policy_document" "update_policy_doc" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject", "s3:DeleteObject", "s3:GetObject", "s3:ListBucket"]
    resources = ["arn:aws:s3:::your-bucket-name/*", "arn:aws:s3:::your-bucket-name"]
  }
}

data "aws_iam_policy_document" "readonly_policy_doc" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = ["arn:aws:s3:::your-bucket-name/*", "arn:aws:s3:::your-bucket-name"]
  }
}

resource "aws_iam_policy" "update_policy" {
  name   = "UpdatePolicy"
  policy = data.aws_iam_policy_document.update_policy_doc.json
}

resource "aws_iam_policy" "readonly_policy" {
  name   = "ReadonlyPolicy"
  policy = data.aws_iam_policy_document.readonly_policy_doc.json
}

# Attach policies to groups
resource "aws_iam_group_policy_attachment" "update_group1_policy" {
  group      = aws_iam_group.update_group1.name
  policy_arn = aws_iam_policy.update_policy.arn
}

resource "aws_iam_group_policy_attachment" "update_group2_policy" {
  group      = aws_iam_group.update_group2.name
  policy_arn = aws_iam_policy.update_policy.arn
}

resource "aws_iam_group_policy_attachment" "update_group3_policy" {
  group      = aws_iam_group.update_group3.name
  policy_arn = aws_iam_policy.update_policy.arn
}

resource "aws_iam_group_policy_attachment" "read_group1_policy" {
  group      = aws_iam_group.read_group1.name
  policy_arn = aws_iam_policy.readonly_policy.arn
}

resource "aws_iam_group_policy_attachment" "read_group2_policy" {
  group      = aws_iam_group.read_group2.name
  policy_arn = aws_iam_policy.readonly_policy.arn
}

# Create IAM users
resource "aws_iam_user" "readonly_user" {
  name = "ReadonlyUser"
}

resource "aws_iam_user" "update_user" {
  name = "UpdateUser"
}

resource "aws_iam_group_membership" "readonly_group_membership" {
  name  = "readonly_group_membership"  # Provide a unique name for the resource
  group = aws_iam_group.read_group1.name
  users = [
    aws_iam_user.readonly_user.name
  ]
}

resource "aws_iam_group_membership" "update_group_membership" {
  name  = "update_group_membership"  # Provide a unique name for the resource
  group = aws_iam_group.update_group1.name
  users = [
    aws_iam_user.update_user.name
  ]
}
