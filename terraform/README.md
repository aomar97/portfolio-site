# Terraform — public hosting (Phase B)

Private **S3** bucket behind **CloudFront** (Origin Access Control), **ACM** TLS, and a
**Route53** alias. This is the free-tier public finale; it's written and
`validate`/`tfsec`-verified now, applied at launch.

## Cost

S3 (KB of HTML), CloudFront (1 TB out / 10M requests free for 12 months) and a Route53
hosted zone (~$0.50/mo) are effectively free for a portfolio site.

## Usage (at launch)

```bash
export AWS_PROFILE=portfolio
terraform init
terraform apply \
  -var="domain_name=portfolio.example.com" \
  -var="hosted_zone_name=example.com" \
  -var="bucket_name=<you>-portfolio-site"

# publish the built site + bust the CDN cache (see `publish_command` output)
aws s3 sync ../site s3://<bucket>/ --delete
aws cloudfront create-invalidation --distribution-id <id> --paths '/*'
```

## Verify without spending (what CI runs)

```bash
terraform fmt -check && terraform validate && tfsec .
```
