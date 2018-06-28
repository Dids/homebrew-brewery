class Clobber < Formula
  desc "Command-line application for building Clover"
  homepage "https://github.com/Dids/clobber"
  url "https://github.com/Dids/clobber/archive/3180c0a8189d8f34b95c097ec66a068d1f03eb01.tar.gz"
  sha256 "a4059d8c035ba04f160cc5a286df1d5cd5f839951936671c7b7ce75a89c01775"
  # version "0.0.1"

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
    # system "cd", buildpath/"go/src/github.com/Dids/clobber", "&&", "go", "get", "."

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
