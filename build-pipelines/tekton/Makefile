.PHONY: all backend backend-portal backend-portal-scheduler frontend-vuejs frontend-react frontend-old ai-server crawler goyoai-web-page rms frontend-system backend-system backend-portal-system front-back-office backend-aify kustomize-patch goyoai-stock-web goyoai-backend-system goyoai-frontend-web goyoai-ai-server ecommerce-backend ecommerce-frontend

DESTINATION=./packages
DOCKER_REG=oci://gdhb.goyoai.com/tekton

all: backend backend-portal backend-portal-scheduler frontend-vuejs frontend-react frontend-old ai-server crawler goyoai-web-page rms frontend-system backend-system backend-portal-system goyoai-stock-web goyoai-backend-system goyoai-frontend-web goyoai-ai-server ecommerce-backend ecommerce-frontend

backend:
	helm package ./backend/helm --destination $(DESTINATION)
	helm push $(DESTINATION)/tekton-goyoai-web-back-0.1.0.tgz $(DOCKER_REG)/tekton/
	helm upgrade --install tekton-goyoai-web-back -n tekton-pipelines $(DOCKER_REG)/tekton/tekton-goyoai-web-back --version 0.1.0

backend-portal:
	helm package ./backend-portal/helm --destination $(DESTINATION)
	helm push $(DESTINATION)/tekton-goyoai-web-back-portal-0.1.0.tgz $(DOCKER_REG)/tekton/
	helm upgrade --install tekton-goyoai-web-back-portal -n tekton-pipelines $(DOCKER_REG)/tekton/tekton-goyoai-web-back-portal --version 0.1.0

backend-portal-scheduler:
	helm package ./backend-scheduller/helm
	helm push tekton-goyoai-web-back-portal-scheduler-0.1.0.tgz $(DOCKER_REG)/goyoai-web-helm/
	helm upgrade --install tekton-goyoai-web-back-portal-scheduller -n tekton-pipelines $(DOCKER_REG)/goyoai-web-helm/tekton-goyoai-web-back-portal-scheduler --version 0.1.0

frontend-vuejs:
	helm package ./frontend-vuejs/helm
	helm push tekton-goyoai-web-front-0.1.0.tgz $(DOCKER_REG)/goyoai-web-helm/
	helm upgrade --install tekton-goyoai-web-front -n tekton-pipelines $(DOCKER_REG)/goyoai-web-helm/tekton-goyoai-web-front --version 0.1.0

frontend-react:
	helm package ./frontend-react/helm --destination $(DESTINATION)
	helm push $(DESTINATION)/tekton-goyoai-web-front-react-0.1.0.tgz $(DOCKER_REG)/tekton/
	helm upgrade --install tekton-goyoai-web-front-react -n tekton-pipelines $(DOCKER_REG)/tekton/tekton-goyoai-web-front-react --version 0.1.0

frontend-old:
	helm package ./frontend-old/helm
	helm push tekton-goyoai-web-front-0.1.0.tgz $(DOCKER_REG)/goyoai-web-helm/
	helm upgrade --install tekton-goyoai-web-front -n tekton-pipelines $(DOCKER_REG)/goyoai-web-helm/tekton-goyoai-web-front --version 0.1.0

ai-server:
	helm package ./ai-api/helm
	helm push tekton-goyoai-ai-server-0.1.0.tgz $(DOCKER_REG)/goyoai-web-helm/
	helm upgrade --install tekton-goyoai-ai-server -n tekton-pipelines $(DOCKER_REG)/goyoai-web-helm/tekton-goyoai-ai-server --version 0.1.0

crawler:
	helm package ./crawler/helm
	helm push tekton-goyoai-backend-crawler-0.1.0.tgz $(DOCKER_REG)/goyoai-web-helm/
	helm upgrade --install tekton-goyoai-backend-crawler -n tekton-pipelines $(DOCKER_REG)/goyoai-web-helm/tekton-goyoai-backend-crawler --version 0.1.0

goyoai-web-page:
	helm package ./goyo-homepage/helm
	helm push tekton-goyoai-web-page-0.1.0.tgz $(DOCKER_REG)/goyoai-web-helm/
	helm upgrade --install tekton-goyoai-web-page -n tekton-pipelines $(DOCKER_REG)/goyoai-web-helm/tekton-goyoai-web-page --version 0.1.0

rms:
	helm package ./rms/helm --destination $(DESTINATION)
	helm push $(DESTINATION)/tekton-rms-0.1.0.tgz $(DOCKER_REG)/tekton/
	helm upgrade --install tekton-rms -n tekton-pipelines $(DOCKER_REG)/tekton/tekton-rms --version 0.1.0

frontend-system:
	helm package ./frontend-web/helm --destination $(DESTINATION)
	helm push $(DESTINATION)/tekton-frontend-web-0.1.0.tgz $(DOCKER_REG)/
	helm upgrade --install tekton-frontend-web -n tekton-pipelines $(DOCKER_REG)/tekton-frontend-web --version 0.1.0

backend-system:
	helm package ./backend-system-old/helm --destination $(DESTINATION)
	helm push $(DESTINATION)/tekton-backend-system-2.0.0.tgz $(DOCKER_REG)/
	helm upgrade --install tekton-backend-system -n tekton-pipelines $(DOCKER_REG)/tekton-backend-system --version 2.0.0

backend-aify:
	helm package ./backend-aify/helm --destination $(DESTINATION)
	helm push $(DESTINATION)/tekton-aify-backend-3.0.0.tgz $(DOCKER_REG)/
	helm upgrade --install tekton-aify-backend -n tekton-pipelines $(DOCKER_REG)/tekton-aify-backend --version 3.0.0

backend-portal-system:
	helm package ./backend-portal-system/helm --destination $(DESTINATION)
	helm push $(DESTINATION)/tekton-backend-portal-system-v2-0.1.0.tgz $(DOCKER_REG)/
	helm upgrade --install tekton-backend-portal-system-v2 -n tekton-pipelines $(DOCKER_REG)/tekton-backend-portal-system-v2 --version 0.1.0

front-back-office:
	helm package ./front-back-office/helm --destination $(DESTINATION)
	helm push $(DESTINATION)/tekton-gointern-front-backoffice-0.1.0.tgz $(DOCKER_REG)/
	helm upgrade --install tekton-gointern-front-backoffice -n tekton-pipelines $(DOCKER_REG)/tekton-gointern-front-backoffice --version 0.1.0

kustomize-patch:
	helm package ./kustomize-patch/ --destination $(DESTINATION)
	helm push $(DESTINATION)/kustomize-patch-1.0.0.tgz $(DOCKER_REG)/
	helm upgrade --install kustomize-patch -n tekton-pipelines $(DOCKER_REG)/kustomize-patch --version 1.0.0

goyoai-stock-web:
	helm package ./goyoai-stock-web/helm --destination $(DESTINATION)
	helm push $(DESTINATION)/tekton-stock-web-0.1.0.tgz $(DOCKER_REG)/
	helm upgrade --install goyoai-stock-web -n tekton-pipelines $(DOCKER_REG)/tekton-stock-web --version 0.1.0

goyoai-backend-system:
	helm package ./goyoai-backend-system/helm --destination $(DESTINATION)
	helm push $(DESTINATION)/goyoai-backend-system-0.1.3.tgz $(DOCKER_REG)/
	helm upgrade --install goyoai-backend-system -n tekton-pipelines $(DOCKER_REG)/goyoai-backend-system --version 0.1.3

goyoai-frontend-web:
	helm package ./goyoai-frontend-web/helm --destination $(DESTINATION)
	helm push $(DESTINATION)/goyoai-frontend-web-0.1.3.tgz $(DOCKER_REG)/
	helm upgrade --install goyoai-frontend-web -n tekton-pipelines $(DOCKER_REG)/goyoai-frontend-web --version 0.1.3

goyoai-backend-system-home:
	helm package ./goyoai-backend-system/helm --destination $(DESTINATION)
	helm push $(DESTINATION)/goyoai-backend-system-0.1.3.tgz $(DOCKER_REG)/
	helm upgrade --install goyoai-backend-system -n tekton-pipelines $(DOCKER_REG)/goyoai-backend-system --version 0.1.3

goyoai-ai-server:
	helm package ./goyoai-ai-server/helm --destination $(DESTINATION)
	helm push $(DESTINATION)/goyoai-ai-server-0.1.3.tgz $(DOCKER_REG)/
	helm upgrade --install goyoai-ai-server -n tekton-pipelines $(DOCKER_REG)/goyoai-ai-server --version 0.1.3

ecommerce-backend:
	helm package ./ecommerce-backend/helm --destination $(DESTINATION)
	helm push $(DESTINATION)/ecommerce-backend-0.1.0.tgz $(DOCKER_REG)/
	helm upgrade --install ecommerce-backend -n tekton-pipelines $(DOCKER_REG)/ecommerce-backend --version 0.1.0

ecommerce-frontend:
	helm package ./ecommerce-frontend/helm --destination $(DESTINATION)
	helm push $(DESTINATION)/ecommerce-frontend-0.1.0.tgz $(DOCKER_REG)/
	helm upgrade --install ecommerce-frontend -n tekton-pipelines $(DOCKER_REG)/ecommerce-frontend --version 0.1.0