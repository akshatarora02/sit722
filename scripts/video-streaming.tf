# Deploys the Video streaming microservice to the Kubernetes cluster.


locals {
    service_name = "video-streaming"
    login_server = "gcr.io/${var.gcp_project}"
    image_tag = "${local.login_server}/${local.service_name}:${var.app_version}"
}

resource "null_resource" "docker_build" {

    triggers = {
        always_run = timestamp()
    }

    provisioner "local-exec" {
        command = "docker build -t ${local.image_tag} --file ../${local.service_name}/Dockerfile-prod ../${local.service_name}"
    }
}

resource "null_resource" "docker_login" {

    depends_on = [ null_resource.docker_build ]

    triggers = {
        always_run = timestamp()
    }

    provisioner "local-exec" {
        command = "gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://australia-southeast1-docker.pkg.dev"
        
        }
}
resource "null_resource" "docker_push" {

    triggers = {
        always_run = timestamp()
    }

    provisioner "local-exec" {
        command = "docker push ${local.image_tag}"
    }
}

#locals {
#    dockercreds = {
#        auths = {
#            "${local.login_server}" = {
#                auth = base64encode("${local.username}:${local.password}")
#            }
#        }
#    }
#}

#resource "kubernetes_secret" "docker_credentials" {
#    metadata {
#        name = "docker-credentials"
#    }

#    data = {
#        ".dockerconfigjson" = jsonencode(local.dockercreds)
#    }
#
#   type = "kubernetes.io/dockerconfigjson"
#}

resource "kubernetes_deployment" "service_deployment" {

    depends_on = [ null_resource.docker_push ]

    metadata {
        name = local.service_name

    labels = {
            pod = local.service_name
        }
    }

    spec {
        replicas = 1

        selector {
            match_labels = {
                pod = local.service_name
            }
        }

        template {
            metadata {
                labels = {
                    pod = local.service_name
                }
            }

            spec {
                container {
                    image = local.image_tag
                    name  = local.service_name

                    env {
                        name = "PORT"
                        value = "80"
                    }
                }

                #image_pull_secrets {
                #    name = kubernetes_secret.docker_credentials.metadata[0].name
                #}
            }
        }
    }
}

resource "kubernetes_service" "service" {
    metadata {
        name = local.service_name
    }

    spec {
        selector = {
            pod = kubernetes_deployment.service_deployment.metadata[0].labels.pod
        }   

        session_affinity = "ClientIP"

        port {
            port        = 80
            target_port = 80
        }

        type             = "LoadBalancer"
    }
}
