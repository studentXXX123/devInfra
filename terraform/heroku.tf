# Create Heroku apps for staging and production
resource "heroku_app" "ci" {
  name = "${var.app_prefix}-app-ci"
  region = "eu"
  config_vars = {
    /*
      We need to set JAVA_TOOL_OPTIONS = -Xmx300m , because of free account on Heroku
    */
    JAVA_TOOL_OPTIONS = "-Xmx300m"
  }
}

resource "heroku_app" "staging" {
  name = "${var.app_prefix}-app-staging"
  region = "eu"
}

resource "heroku_app" "production" {
  name = "${var.app_prefix}-app-production"
  region = "eu"
}

resource "heroku_addon" "ci" {
  app  = "${heroku_app.ci.name}"
  plan = "hostedgraphite"
}

resource "heroku_addon" "staging" {
  app  = "${heroku_app.staging.name}"
  plan = "hostedgraphite"
}

resource "heroku_addon" "production" {
  app  = "${heroku_app.production.name}"
  plan = "hostedgraphite"
}

resource "heroku_pipeline" "gotrest_app" {
  name = "${var.pipeline_name}"
}

# Couple apps to different pipeline stages
resource "heroku_pipeline_coupling" "ci" {
  app = "${heroku_app.ci.name}"
  pipeline = "${heroku_pipeline.gotrest_app.id}"
  stage = "development"
}

# Couple apps to different pipeline stages
resource "heroku_pipeline_coupling" "staging" {
  app = "${heroku_app.staging.name}"
  pipeline = "${heroku_pipeline.gotrest_app.id}"
  stage = "staging"
}

resource "heroku_pipeline_coupling" "production" {
  app = "${heroku_app.production.name}"
  pipeline = "${heroku_pipeline.gotrest_app.id}"
  stage = "production"
}
