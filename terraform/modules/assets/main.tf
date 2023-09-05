resource "google_storage_bucket" "assets" {
  name          = "stooks-gke-assets-bucket-${var.env}"
  location      = "${var.location}"
  storage_class = "${var.storage_class}"
  project = var.project_id

  website {
    main_page_suffix = "index.html"
  }
}

resource "google_storage_bucket_iam_binding" "assets" {
  bucket = "${google_storage_bucket.assets.name}"
  role   = "roles/storage.legacyObjectReader"

  members = [
    "allUsers",
  ]
}