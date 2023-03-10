#!/usr/bin/env bash

sed -i "s/kafka.strimzi.io/strimzi.rhoc.bf2.dev/g" api/src/main/java/io/strimzi/api/kafka/model/Constants.java
sed -i "s/core.strimzi.io/core.strimzi.rhoc.bf2.dev/g" api/src/main/java/io/strimzi/api/kafka/model/Constants.java

yq -i '.rules[1].apiGroups[0] = "strimzi.rhoc.bf2.dev"' packaging/install/cluster-operator/023-ClusterRole-strimzi-cluster-operator-role.yaml
yq -i '.rules[2].apiGroups[0] = "core.strimzi.rhoc.bf2.dev"' packaging/install/cluster-operator/023-ClusterRole-strimzi-cluster-operator-role.yaml
yq -i '.rules[0].apiGroups[0] = "strimzi.rhoc.bf2.dev"' packaging/install/cluster-operator/031-ClusterRole-strimzi-entity-operator.yaml

for F in api/src/test/resources/io/strimzi/api/kafka/model/*.yaml; do
    if [ $(yq e '.apiVersion == "kafka.strimzi.io/v1alpha1"' "${F}") == "true" ]; then
         yq -i '.apiVersion = "strimzi.rhoc.bf2.dev/v1alpha1"' "${F}"
    fi 
    if [ $(yq e '.apiVersion == "kafka.strimzi.io/v1beta1"' "${F}") == "true" ]; then
         yq -i '.apiVersion = "strimzi.rhoc.bf2.dev/v1beta1"' "${F}"
    fi
    if [ $(yq e '.apiVersion == "kafka.strimzi.io/v1beta2"' "${F}") == "true" ]; then
         yq -i '.apiVersion = "strimzi.rhoc.bf2.dev/v1beta2"' "${F}"
    fi
    if [ $(yq e '.apiVersion == "core.strimzi.io/v1beta2"' "${F}") == "true" ]; then
         yq -i '.apiVersion = "core.strimzi.rhoc.bf2.dev/v1beta2"' "${F}"
    fi
done