FROM golang:1.25-alpine AS builder

#Latest release is v0.0.4 (2024-05-29) - older than upstream master; pinning to current master HEAD instead for Kubernetes 1.35 schema support. Ref: https://github.com/kubernetes-sigs/kubectl-validate/commit/a97ccfaca20b164819afdae780392496f6ed6bbd
RUN go install sigs.k8s.io/kubectl-validate@a97ccfaca20b164819afdae780392496f6ed6bbd

FROM scratch

COPY --from=builder /go/bin/kubectl-validate /kubectl-validate

ENTRYPOINT ["/kubectl-validate"]
