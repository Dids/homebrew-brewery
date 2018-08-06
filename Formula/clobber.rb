class Clobber < Formula
  desc "Command-line application for building Clover"
  homepage "https://github.com/Dids/clobber"
  url "https://github.com/Dids/clobber/archive/e4fd18966e3515116c21ea719b3d20b4cc593751.tar.gz"
  version "0.0.1"
  sha256 "05ef28a7d642a91d48695a8fdf84845ca676a7a81d07639ff50abb96af95d785"
  revision 0

  # Setup head/master branch support (install with --HEAD)
  head "https://github.com/Dids/Clobber.git"

  # No bottling necessary
  bottle :unneeded

  # We need go for building
  depends_on "go" => :build

  # We also need govendor for build dependencies
  depends_on "govendor" => :build
  
  # We need Xcode/xcodebuild for running the application
  depends_on :xcode

  # The rest are required for running
  depends_on "subversion"

  # Define the installation steps
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
    #system "cd go/src/github.com/Dids/clobber && go get -d -t -v ./"
    system "cd go/src/github.com/Dids/clobber && govendor sync"

    # Build the application
    #system "go", "build", "-o", buildpath/"clobber"
    #system "go", "build", "-o", buildpath/"clobber", "-ldflags=\"-X main.version=$(git describe --always --long --dirty)\""
    versionFlags = "-ldflags=\"-X main.version=" + version + "\""
    system "go", "build", "-o", buildpath/"clobber", versionFlags
    bin.install buildpath/"clobber"
  end

  ## TODO: Properly test and implement this
  test do
    ## TODO: Also run go tests? Maybe? No?
    system bin/"clobber", "--help"
  end
end
