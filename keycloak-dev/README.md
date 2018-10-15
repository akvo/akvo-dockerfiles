## Keycloak

The admin password for keycloak is "admin" / "password". There is an
"akvo" realm, where two tenants (t1 & t2) and they are represesnted by
the following groups:

```
akvo
└── lumen
    ├── t1
    │   └── admin
    └── t2
        └── admin
```

Available users are:

- "lumen" service account
- "jerome" t1 admin
- "salim" t1 user
- "ruth" t2 admin
- "harry" t2 user
- "kaj" keycloak user not on a tenant

All passwords are "password".
