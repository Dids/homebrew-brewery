class Clobber < Formula
  desc "Command-line application for building Clover"
  homepage "https://github.com/Dids/clobber"
  url "https://github.com/Dids/clobber/archive/c0e0370aac151f068f62baa977d27551b7ca03b2.tar.gz"
  sha256 "bcdfa31d986960afe497b148e31596dd00045c1fe35db8fc43b9bb803ab8999f"
  #version "0.0.1"

  ## TODO: What is this?
  bottle :unneeded

  ## TODO: We technically require build tools too, so Xcode CLI tools should be required?

  # We need go for building
  depends_on "go" => :build

  # The rest are required for running
  depends_on "subversion"

  def install
    # Define GOPATH
    ENV["GOPATH"] = buildpath/"go"

    # Create the required directories
    (buildpath/"go/bin").mkpath
    (buildpath/"go/pkg").mkpath
    (buildpath/"go/src").mkpath
    (buildpath/"go/src/github.com/Dids").mkpath

    # Symlink the package directory
    ln_s buildpath, buildpath/"go/src/github.com/Dids/clobber"

    ## FIXME: Do not use `go get`. Please ask upstream to implement Go vendoring
    # Install build dependencies
    ## NOTE: Doesn't work
    #system "cd", buildpath/"go/src/github.com/Dids/clobber", "&&", "go", "get", "."
    system "cd go/src/github.com/Dids/clobber && go get ."

    # Build the application
    system "go", "build", "-o", buildpath/"clobber"
    bin.install buildpath/"clobber"
  end

  ## TODO: Properly test and implement this
  test do
    ## TODO: Also run go tests? Maybe? No?
    system bin/"clobber", "--help"
  end
end
