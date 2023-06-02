apiVersion: v1
kind: Secret
metadata:
  name: ${name}
  namespace: ${namespace}
type: Opaque
stringData:
  bootstrapToken: ${bootstrapToken}
  gossipEncryptionKey: ${gossipEncryptionKey}
  caCert: >
${caCert}