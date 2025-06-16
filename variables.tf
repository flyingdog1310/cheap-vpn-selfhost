variable "region" {
  description = <<-EOT
    The region where the VPN server will be deployed. Available regions:
    - lax: Los Angeles, USA
    - ewr: New York, USA
    - yto: Toronto, Canada
    - mex: Mexico City, Mexico
    - sao: Sao Paulo, Brazil
    - bom: Mumbai, India
    - nrt: Tokyo, Japan
    - icn: Seoul, South Korea
    - sgp: Singapore
    - ams: Amsterdam, Netherlands
    - fra: Frankfurt, Germany
    - man: Manchester, Great Britain
    - mad: Madrid, Spain
    - par: Paris, France
    - sto: Stockholm, Sweden
    - waw: Warsaw, Poland
    - syd: Sydney, Australia
  EOT
  type        = string

  validation {
    condition     = contains(["lax", "ewr", "yto", "mex", "sao", "bom", "nrt", "icn", "sgp", "ams", "fra", "man", "mad", "par", "sto", "waw", "syd"], var.region)
    error_message = "The region must be one of: lax (Los Angeles), ewr (New York), yto (Toronto), mex (Mexico City), sao (Sao Paulo), bom (Mumbai), nrt (Tokyo), icn (Seoul), sgp (Singapore), ams (Amsterdam), fra (Frankfurt), man (Manchester), mad (Madrid), par (Paris), sto (Stockholm), waw (Warsaw), syd (Sydney)."
  }
}
