FROM golang:1.23-alpine AS builder

#Since no latest version tagged, get from this version https://github.com/kubernetes-sigs/kubectl-validate/commit/d2f2d68fba097640069aaff046fa7cfddfd63326
RUN go install sigs.k8s.io/kubectl-validate@d2f2d68fba097640069aaff046fa7cfddfd63326

FROM scratch

COPY --from=builder /go/bin/kubectl-validate /kubectl-validate

ENTRYPOINT ["/kubectl-validate"]
