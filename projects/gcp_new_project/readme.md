There are three major parts required to create a new project on GCP via Terraform. The major sections are:  
* "create_project"
* "create_bucket"
* "create_service_account"

#### "CREATE_PROJECT"  
"name", "project_id", "billing_account" and "auto_create_network" are user supplied variables.  
* "name" and "project_id" accepts any value but must be unique across the account; they can share the same name.
* "billing_account" should be the same across deployments.
* "auto_create_network" only access "true" or "false"

#### "CREATE_BUCKET"
"location", "storage_class", and "uniform_bucket_level_access" are user supplied variables.  
* "storage_class" only accepts "standard", "muli_regional", or "archive".
* "uniform_bucket_level_access" only accepts true or false.
* "location" must conform to the regional settings described in the article (https://cloud.google.com/storage/docs/location)

#### "CREATE_SERVICE_ACCOUNT"  
"account_id", "displayName", and "role" are user supplied variables
