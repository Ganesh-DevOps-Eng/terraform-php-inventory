resource "aws_codepipeline" "codepipeline" {
  name     = "my-codepipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = var.s3_location # Replace with your S3 bucket
    type     = "S3"
  }

  stage {
    name = "Source"

      action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]


      configuration = {
        ConnectionArn = var.ConnectionArn
        FullRepositoryId = var.FullRepositoryId
        BranchName = var.BranchName
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "DeployAction"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ElasticBeanstalk"
      version         = "1"
      input_artifacts = ["source_output"]

      configuration = {
        ApplicationName    = "matelliocorp-eb-app"
        EnvironmentName    = "matelliocorp-eb-env"
      }
    }
  }
}
