#!/usr/bin/env bash

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install mongo bitnami/mongodb --version "$KX_MONGODB_HELM_CHART_VER" \
  --set global.defaultStorageClass=nfs-csi \
  --set architecture=replicaset \
  --set useStatefulSet=true \
  --set auth.rootPassword=xtech42 \
  --set replicaCount=3 \
  --set persistentVolumeClaimRetentionPolicy.enabled=true \
  --set persistentVolumeClaimRetentionPolicy.whenDeleted=Delete \
  --set service.nameOverride=mongodb
