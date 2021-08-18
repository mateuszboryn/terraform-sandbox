resource "aws_s3_bucket" "test_bucket" {
  bucket = "zzz-541147820420-test-bucket"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.test_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_sns_topic" "s3_notify" {
  name = "zzz-s3-notify"

    policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": { "Service": "s3.amazonaws.com" },
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:zzz-s3-notify",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.test_bucket.arn}"}
        }
    }]
}
POLICY
}

resource "aws_sns_topic" "s3_notify2" {
  name = "zzz-s3-notify2"

    policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": { "Service": "s3.amazonaws.com" },
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:zzz-s3-notify2",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.test_bucket.arn}"}
        }
    }]
}
POLICY
}

resource "aws_s3_bucket_notification" "test_bucket_notify" {
  bucket = aws_s3_bucket.test_bucket.id

/*
  // having multiple "topic" entries here works well.
  topic {
    topic_arn     = aws_sns_topic.s3_notify.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "dir-a"
  }
  topic {
    topic_arn     = aws_sns_topic.s3_notify.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "dir-b"
  }
  topic {
    topic_arn     = aws_sns_topic.s3_notify.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "dir-c-2"
  }
  topic {
    topic_arn     = aws_sns_topic.s3_notify.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "dir-d"
  }
*/

  /*
  // this approach keeps overwriting one entry with another
  for_each = var.s3_notifications_list
  topic {
    topic_arn     = each.value.topic
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = each.value.prefix
  }
  */


/*
  // using for_each inside "topic" appears to be prohibited
  topic {
    for_each = var.s3_notifications_list

    topic_arn     = each.value.topic
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = each.value.prefix
  }
  */


  // this works as expected: create multiple notifications entries for a single bucket from a list or map
  dynamic "topic" {
    for_each = var.s3_notifications_list
    content {
      topic_arn     = topic.value.topic
      events        = ["s3:ObjectCreated:*"]
      filter_prefix = topic.value.prefix
    }
  }
}

