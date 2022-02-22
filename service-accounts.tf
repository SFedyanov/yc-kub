resource "yandex_iam_service_account" "docker-registry" {
  name        = "docker-registry"
  description = "service account to use container registry"
}

resource "yandex_iam_service_account" "instance-editor" {
  name        = "instance-editor"
  description = "service account to manage VMs"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.yc_folder_id

  role = "editor"

  members = [
    "serviceAccount:${yandex_iam_service_account.instance-editor.id}"
  ]

  depends_on = [
    yandex_iam_service_account.instance-editor
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "pusher" {
  folder_id = var.yc_folder_id

  role = "container-registry.images.puser"

  members = [
    "serviceAccount:${yandex_iam_service_account.instance-editor.id}"
  ]

  depends_on = [
    yandex_iam_service_account.docker-registry
  ]
}
