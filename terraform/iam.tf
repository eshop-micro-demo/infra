resource "aws_iam_role" "external-dns-role" {
  name        = "external-dns-role"
  description = "Role that can be assumed by external-dns via kube2iam"

  lifecycle {
    create_before_destroy = true
  }

  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    principals {
      type = "AWS"

      identifiers = [
        data.aws_iam_role.kops_nodes_role.arn
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.external-dns-role.name
  policy_arn = aws_iam_policy.external-dns-policy.arn

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "external-dns-policy" {
  name        = "external-dns-policy"
  description = "Grant permissions for external-dns"
  policy      = jsonencode(
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/${data.aws_route53_zone.main-zone.zone_id}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
  )
}
