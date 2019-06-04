A Bitnami postgres image but with jq and lzop, which are required for the initial seeding of the RSR environments.

We are not using the official postgres images because the official Helm postgres chart is based on Bitnami's images, and 
the postgres images do not work out of the box. 

Bitnami's images come without PostGIS or plv8, which may require some additional work in the future.

