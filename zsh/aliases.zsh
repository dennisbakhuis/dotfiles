#########################################
# My general aliases for zsh            #
#                                       #
# Author: Dennis Bakhuis                #
# Date: 2023-11-12                      #
#########################################

###########
# General #
###########
alias history='history -i'
alias hist='history'


##########
# Python #
##########
alias jl='jupyter lab --ip=0.0.0.0'  # Jupyter Lab (keep as general alias as it could be available in multiple environments (or not))


###########
# Kubectl #
###########
alias k='kubectl'
alias kd='kubectl describe'
alias kg='kubectl get'
alias kl='kubectl logs'


##########
# Docker #
##########
alias dps='python3 ~/dotfiles/python/docker-pretty-print/docker-pretty-print.py'
alias dprune='docker system prune -a'


##########
# TenneT #
##########
alias main='kubectl config use-context intelligent-document-checker-dpe-dev-aks'
alias ydigital='kubectl config use-context tennet-idc-aks'
alias models='kubectl config use-context tennet-idc-aml-models-aks'
alias argoprod='argo server -n argo --configmap argo-argo-workflows-workflow-controller-configmap --auth-mode=server --secure=false'

