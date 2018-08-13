class Clobber < Formula
  desc "Command-line application for building Clover"
  homepage "https://github.com/Dids/clobber"
  url "https://github.com/Dids/clobber/archive/v0.0.2.tar.gz"
  sha256 "e766e757fe592cdf875eb110fa94e1ea4fd71d2319a9a07e2b9b16bb40751b9c"
  revision 0

  # Setup head/master branch support (install with --HEAD)
  head "https://github.com/Dids/Clobber.git"

  # No bottling necessary
  bottle :unneeded

  # We need go for building
  depends_on "go@1.10" => :build

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

    # Install build dependencies
    system "cd go/src/github.com/Dids/clobber && govendor sync"

    # Print out target version
    opoo "Building version #{version}"

    # Build the application
    #versionFlags = "-ldflags=\"-X main.Version=" + version + "\""
    #system "go", "build", versionFlags, "-o", buildpath/"clobber"
    system "./.scripts/build.sh", version, buildpath/"clobber"
    #system "go", "build", "-ldflags", "\"-X main.Version=#{version}\"", "-o", buildpath/"clobber"

    # Print the version
    system buildpath/"clobber",  "--version"

    # Install the application
    bin.install buildpath/"clobber"

    # Print the version
    system bin/"clobber",  "--version"

    # Test that the version matches
    opoo "Version: " + `#{bin}/clobber --version`.strip
    if version != `#{bin}/clobber --version`.strip
      odie "Output of 'clobber --version' did not match the current version (#{version})."
    end
    #assert_equal version, `#{bin}/clobber --version`.strip
  end

  test do
    # Test that the version matches
    assert_equal version, `#{bin}/clobber --version`.strip
  end
end
