s3_bucket = ENV["UPLOADS_S3_BUCKET"]
s3_region = ENV["UPLOADS_S3_REGION"]
cdn_domain = ENV["UPLOADS_CDN_DOMAIN"]

if s3_bucket && s3_region && cdn_domain
  # The credentials are not provided explicitly since we rely on the default
  # provider chain.
  #
  # See: https://docs.aws.amazon.com/credref/latest/refdocs/overview.html
  Paperclip::Attachment.default_options.merge!(
    fog_credentials: {
      provider: "AWS",
      region: s3_region,
      scheme: "https",
      use_iam_profile: true,
    },
    fog_directory: s3_bucket,
    fog_host: cdn_domain,
    fog_public: false,
    storage: :fog,
  )

  Paperclip::UriAdapter.register
end
